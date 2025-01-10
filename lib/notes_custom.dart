import 'package:flutter/material.dart';

class NotesCustom extends StatelessWidget {
  final TextEditingController _noteController = TextEditingController();

  NotesCustom({super.key});

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
                    "Add Note", 
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
                          controller: _noteController,
                          decoration: const InputDecoration(
                            labelText: "Note",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_noteController.text.isNotEmpty) {
                              Navigator.pop(context, _noteController.text);
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
