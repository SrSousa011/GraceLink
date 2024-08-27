import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;
    if (kDebugMode) {
      print('Path: ${file.path}');
    }

    OpenFile.open(file.path);
  }

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
