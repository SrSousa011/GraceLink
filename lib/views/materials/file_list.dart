import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FileListView extends StatelessWidget {
  final List<Map<String, dynamic>> fileDocs;
  final bool isDarkMode;

  const FileListView({
    super.key,
    required this.fileDocs,
    required this.isDarkMode,
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

  Future<void> _freezeFile(
      BuildContext context, String courseId, String fileId) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses/$courseId/materials')
          .doc(fileId)
          .update({'visibility': 'frozen'});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File frozen successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error freezing file: $e')),
        );
      }
    }
  }

  Future<void> _unfreezeFile(
      BuildContext context, String courseId, String fileId) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses/$courseId/materials')
          .doc(fileId)
          .update({'visibility': 'public'});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File unfrozen successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error unfrozen file: $e')),
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
        final visibility = file['visibility'] as String? ?? 'public';

        final isFrozen = visibility == 'frozen';

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
                onPressed: isFrozen
                    ? null // Disable if file is frozen
                    : () async {
                        if (url.isNotEmpty) {
                          try {
                            final Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Could not launch URL')),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error opening URL: $e')),
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
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: isFrozen
                    ? null // Disable if file is frozen
                    : () {
                        _deleteFile(context, file['courseId'], fileId);
                      },
              ),
              IconButton(
                icon: Icon(
                  isFrozen ? Icons.lock_open : Icons.lock,
                  color: isFrozen ? Colors.green : Colors.orange,
                ),
                onPressed: () {
                  if (isFrozen) {
                    _unfreezeFile(context, file['courseId'], fileId);
                  } else {
                    _freezeFile(context, file['courseId'], fileId);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
