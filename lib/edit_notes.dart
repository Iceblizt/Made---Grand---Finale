import 'package:flutter/material.dart';

class EditNotes extends StatelessWidget {
  final TextEditingController _noteController;
  final String initialNote;

  EditNotes({super.key, required this.initialNote})
      : _noteController = TextEditingController(text: initialNote);

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "Edit Note",
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
                            maxLines: null, 
                            keyboardType: TextInputType
                                .multiline, 
                            textInputAction: TextInputAction
                                .newline, 
                            decoration: const InputDecoration(
                              labelText: "Note",
                              border: OutlineInputBorder(),
                              alignLabelWithHint:
                                  true, 
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal:
                                      12.0),
                            ),
                            style: const TextStyle(
                              fontSize: 16.0,
                              height: 1.5, 
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
      ),
    );
  }

  void dispose() {
    _noteController.dispose();
  }
}
