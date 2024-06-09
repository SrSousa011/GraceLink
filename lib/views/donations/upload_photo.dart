import 'package:flutter/material.dart';

class UploadPhotoScreen extends StatelessWidget {
  const UploadPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement photo upload logic
            // For now, just navigate back to the previous screen
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF5AAFf9),
          ),
          child: const Text('Upload Photo'),
        ),
      ),
    );
  }
}
