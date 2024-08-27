import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class FileListView extends StatelessWidget {
  final List<Map<String, dynamic>> fileDocs;
  final bool isDarkMode;
  final String userRole;

  const FileListView({
    super.key,
    required this.fileDocs,
    required this.isDarkMode,
    required this.userRole,
  });

  Future<void> _deleteFile(
      BuildContext context, String courseId, String fileId) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses/$courseId/materials')
          .doc(fileId)
          .delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File deleted successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting file: $e')),
        );
      }
    }
  }

  Future<void> _openFile(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
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
                  onPressed: () {
                    _deleteFile(context, courseId, fileId);
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
