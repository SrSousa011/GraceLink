import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class CourseFileList extends StatelessWidget {
  final String selectedCourseId;
  final bool isDarkMode;
  final String userRole;
  final Future<void> Function(String, String, String) onFileDeleted;
  final List<Map<String, String?>> fileDocs;

  const CourseFileList({
    super.key,
    required this.selectedCourseId,
    required this.isDarkMode,
    required this.userRole,
    required this.onFileDeleted,
    required this.fileDocs,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fileDocs.length,
      itemBuilder: (context, index) {
        final file = fileDocs[index];
        final url = file['url'] ?? '';
        final name = file['name'] ?? 'Unknown File';
        final fileId = file['id'] ?? '';
        final courseId = file['courseId'] ?? '';

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
                    await _openFile(context, url, name);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.link),
                onPressed: () {
                  if (url.isNotEmpty) {
                    _showUrl(context, url);
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
                      await _confirmDeleteFile(context, courseId, fileId, url);
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

  Future<void> _openFile(
      BuildContext context, String url, String fileName) async {
    try {
      // Print the URL to the terminal
      debugPrint('Opening file with URL: $url');

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$fileName';

      debugPrint('Downloading file to: $filePath');

      if (!File(filePath).existsSync()) {
        final response = await Dio().download(url, filePath);
        if (response.statusCode == 200) {
          debugPrint('File downloaded successfully.');
        } else {
          throw Exception(
              'Failed to download file. Status code: ${response.statusCode}');
        }
      } else {
        debugPrint('File already exists.');
      }

      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception('Failed to open file. Result type: ${result.type}');
      }
    } catch (e) {
      debugPrint('Error opening file: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening file: $e')),
        );
      }
    }
  }

  void _showUrl(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('File URL'),
          content: Text(url),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteFile(BuildContext context, String courseId,
      String fileId, String fileUrl) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content:
              const Text('Tem certeza de que deseja excluir este arquivo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await onFileDeleted(courseId, fileId, fileUrl);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File deleted successfully')),
        );
      }
    }
  }
}
