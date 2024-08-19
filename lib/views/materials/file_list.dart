import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                icon: const Icon(Icons.download),
                onPressed: () async {
                  if (url.isNotEmpty) {
                    try {
                      final Uri uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not launch URL'),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error opening URL: $e'),
                          ),
                        );
                      }
                    }
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
