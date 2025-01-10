import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadItems();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadItems() async {
    if (_auth.currentUser == null) return;

    _formatDate(selectedDate);

    try {
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('Error loading items: $e');
      }
    }
  }

  Future<void> _addItem(String text, bool isTodo) async {
    if (_auth.currentUser == null) return;

    String dateStr = _formatDate(selectedDate);
    String userId = _auth.currentUser!.uid;
    String collection = isTodo ? 'todos' : 'notes';

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .add({
        'text': text,
        'completed': false,
        'date': dateStr,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _loadItems();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item: $e');
      }
    }
  }

  Future<void> _deleteItem(String docId, bool isTodo) async {
    if (_auth.currentUser == null) return;

    String userId = _auth.currentUser!.uid;
    String collection = isTodo ? 'todos' : 'notes';

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .doc(docId)
          .delete();

      _loadItems();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting item: $e');
      }
    }
  }

  Future<void> _editNote(String docId, String currentText) async {
    if (_auth.currentUser == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotes(initialNote: currentText),
      ),
    );

    if (result != null && result is String) {
      String userId = _auth.currentUser!.uid;
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('notes')
            .doc(docId)
            .update({
          'text': result,
        });

        _loadItems();
      } catch (e) {
        if (kDebugMode) {
          print('Error updating note: $e');
        }
      }
    }
  }

  Future<void> _toggleCompletion(String docId, bool currentStatus) async {
    if (_auth.currentUser == null) return;

    String userId = _auth.currentUser!.uid;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .doc(docId)
          .update({
        'completed': !currentStatus,
      });

      _loadItems();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating item: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadItems();
    }
  }

  Widget _buildList(bool isTodo) {
    if (_auth.currentUser == null) {
      return const Center(child: Text("Please login"));
    }

    String userId = _auth.currentUser!.uid;
    String dateStr = _formatDate(selectedDate);
    String collection = isTodo ? 'todos' : 'notes';

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .where('date', isEqualTo: dateStr)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var items = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            var data = item.data() as Map<String, dynamic>;
            bool isCompleted = data['completed'] ?? false;

            if (isTodo) {
              return ListTile(
                title: Text(
                  data['text'] ?? '',
                  style: TextStyle(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: isCompleted ? Colors.green : null,
                  ),
                  onPressed: () => _toggleCompletion(item.id, isCompleted),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteItem(item.id, true),
                ),
              );
            } else {
              return ListTile(
                title: Text(data['text'] ?? ''),
                leading: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editNote(item.id, data['text'] ?? ''),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteItem(item.id, false),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Taskmaster"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    tabs: const [
                      Tab(text: "To-Do List"),
                      Tab(text: "Notes"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildList(true), // To-Do List
                        _buildList(false), // Notes
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_tabController.index == 0) {
            final result = await Navigator.pushNamed(context, '/add_todo');
            if (result != null && result is String) {
              await _addItem(result, true);
            }
          } else {
            final result = await Navigator.pushNamed(context, '/add_note');
            if (result != null && result is String) {
              await _addItem(result, false);
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
