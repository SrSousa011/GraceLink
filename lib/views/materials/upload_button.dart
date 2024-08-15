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

    return ElevatedButton.icon(
      icon: isUploading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : const Icon(
              Icons.upload,
              color: Colors.white,
            ),
      label: Text(
        isUploading ? 'Uploading...' : 'Upload File',
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? const Color(0xFF333333) : Colors.blue,
        shape: const StadiumBorder(),
        foregroundColor: Colors.white,
      ),
      onPressed: isUploading ? null : onPressed,
    );
  }
}
