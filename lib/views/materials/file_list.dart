import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FileListView extends StatelessWidget {
  final List<Map<String, dynamic>> fileDocs;
  final bool isDarkMode;

  const FileListView({
    super.key,
    required this.fileDocs,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fileDocs.length,
      itemBuilder: (context, index) {
        final file = fileDocs[index];
        final url = file['url'] as String;
        final name = file['title'] as String;

        return ListTile(
          title: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              try {
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch URL')),
                  );
                }
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error opening URL: $e')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
