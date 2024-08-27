import 'package:flutter/foundation.dart';
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

  const CourseFileList({
    super.key,
    required this.selectedCourseId,
    required this.isDarkMode,
    required this.userRole,
    required this.onFileDeleted,
    required List<Map<String, String?>> fileDocs,
  });

  Future<File?> downloadFile(String url, String name) async {
    try {
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File('${appStorage.path}/$name');

      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: Duration.zero,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
      return null;
    }
  }

  Future<void> openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;
    if (kDebugMode) {
      print('Path: ${file.path}');
    }

    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses/$selectedCourseId/materials')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorMessage(
              message: 'Error loading files: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
          return const Center(child: Text('No files available.'));
        }

        final fileDocs = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'url': data['url'] as String?,
            'name': data['name'] as String?,
            'courseId': selectedCourseId,
            'visibility': data['visibility'] as String? ?? 'public',
          };
        }).toList();

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
                        await openFile(url: url, fileName: name);
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
                          await _confirmDeleteFile(
                              context, courseId, fileId, url);
                        }
                      },
                    ),
                  ],
                ],
              ),
            );
          },
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
          title: const Text('Confirm deletion'),
          content: const Text('Are you sure you want to delete this file?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      await onFileDeleted(courseId, fileId, fileUrl);
    }
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
