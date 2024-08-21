import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FileListView extends StatelessWidget {
  final List<Map<String, dynamic>> fileDocs;
  final bool isDarkMode;
  final String userRole;
  final Future<void> Function(String fileUrl, String fileName) onDownload;

  const FileListView({
    super.key,
    required this.fileDocs,
    required this.isDarkMode,
    required this.userRole,
    required this.onDownload,
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

  Future<void> _downloadFile(
      String fileUrl, String fileName, BuildContext context) async {
    final shouldDownload = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Download'),
          content: Text('Do you want to download "$fileName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Download'),
            ),
          ],
        );
      },
    );

    if (shouldDownload == true) {
      try {
        final dio = Dio();

        // Get the Downloads directory
        final directories = await getExternalStorageDirectories(
            type: StorageDirectory.downloads);
        final directory =
            directories?.first; // Pick the first available directory

        if (directory == null) {
          throw Exception('Failed to get the Downloads directory.');
        }

        final filePath = '${directory.path}/$fileName';

        // Download the file
        await dio.download(fileUrl, filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded to $filePath')),
        );
      } catch (e) {
        print('Error downloading file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading file: $e')),
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
                    await _downloadFile(url, name, context);
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
