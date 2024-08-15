import 'package:churchapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final iconColor = isDarkMode ? Colors.white : Colors.blue;

    return ElevatedButton.icon(
      icon: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: iconColor,
      ),
      label: isUploading
          ? const CircularProgressIndicator()
          : const Text('Upload File'),
      onPressed: isUploading ? null : onPressed,
    );
  }
}
