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
          child: const Text('Upload Photo'),
        ),
      ),
    );
  }
}
