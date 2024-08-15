import 'package:flutter/material.dart';

class UploadButton extends StatelessWidget {
  final bool isUploading;
  final VoidCallback onPressed;

  const UploadButton({
    super.key,
    required this.isUploading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isUploading ? null : onPressed,
      child: isUploading
          ? const CircularProgressIndicator()
          : const Text('Upload File'),
    );
  }
}
