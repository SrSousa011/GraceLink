import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FileListView extends StatelessWidget {
  final List<Map<String, dynamic>> fileDocs;
  final bool isDarkMode;
  final String userRole;
  final Future<void> Function(String, String, String) onFileDeleted;

  const FileListView({
    super.key,
    required this.fileDocs,
    required this.isDarkMode,
    required this.userRole,
    required this.onFileDeleted,
  });

  Future<void> _openFile(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open file.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fileDocs.length,
      itemBuilder: (context, index) {
        final file = fileDocs[index];
        final url = file['url'] as String? ?? '';
        final name = file['name'] as String? ?? 'Unknown File';
        final fileId = file['id'] as String? ?? '';
        final courseId = file['courseId'] as String? ?? '';

        return ListTile(
          title: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () async {
                  if (url.isNotEmpty) {
                    await _openFile(url, context);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid URL')),
                      );
                    }
                  }
                },
              ),
              if (userRole == 'admin') ...[
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    if (fileId.isNotEmpty &&
                        courseId.isNotEmpty &&
                        url.isNotEmpty) {
                      await onFileDeleted(courseId, fileId, url);
                    }
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
