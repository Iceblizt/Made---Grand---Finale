import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
import 'notes_custom.dart';
import 'add_todo_list.dart';
import 'login_screen.dart';
import 'edit_notes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
    if (kDebugMode) {
      print("Firebase initialized successfully");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error initializing Firebase: $e");
    }
  }
  runApp(const TaskMasterApp());
}

class TaskMasterApp extends StatelessWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskmaster',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add_note': (context) => NotesCustom(),
        '/add_todo': (context) => AddToDoList(),
        '/edit_note': (context) => EditNotes(initialNote: ''),
      },
    );
  }
}
