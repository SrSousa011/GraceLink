import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
                icon: const Icon(Icons.open_in_browser_sharp),
                onPressed: () {
                  if (url.isNotEmpty) {
                    _showUrl(context, url, name);
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

  void _showUrl(BuildContext context, String url, String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Abrir arquivo'),
          content: Text('Você quer abrir o arquivo "$fileName"?'),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('URL copiada')),
                );
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Copiar URL'),
            ),
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Não foi possível abrir o URL')),
                    );
                  }
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(' URL Invalida')),
                  );
                }
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Abrir'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
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
          title: const Text('Confirm Deletion'),
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
      await onFileDeleted(courseId, fileId, fileUrl);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File deleted successfully')),
        );
      }
    }
  }
}
