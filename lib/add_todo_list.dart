import 'package:flutter/material.dart';

class AddToDoList extends StatelessWidget {
  final TextEditingController _toDoController = TextEditingController();

  AddToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        leading: IconButton( 
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: Center( 
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600, 
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0), 
                  child: Text(
                    "Add To-Do List", 
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2), 
                    borderRadius: BorderRadius.circular(12), 
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, 
                      children: [
                        TextField(
                          controller: _toDoController,
                          decoration: const InputDecoration(
                            labelText: "To-Do",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_toDoController.text.isNotEmpty) {
                              Navigator.pop(context, _toDoController.text);
                            }
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
