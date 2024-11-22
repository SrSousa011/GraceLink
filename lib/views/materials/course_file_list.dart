import 'package:flutter/material.dart';
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
                      await _handleFileDeletion(context, courseId, fileId, url);
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
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) {
              return;
            }
          },
          child: AlertDialog(
            title: const Text('Abrir arquivo'),
            actions: [
              TextButton(
                onPressed: () async {
                  final uri = Uri.tryParse(url);
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('URL Inválida')),
                      );
                    }
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
          ),
        );
      },
    );
  }

  Future<void> _handleFileDeletion(
    BuildContext context,
    String courseId,
    String fileId,
    String url,
  ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content:
              const Text('Você tem certeza que deseja excluir este arquivo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await onFileDeleted(courseId, fileId, url);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao excluir o arquivo')),
          );
        }
      }
    }
  }
}
