import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/materials/course_file_list.dart';

class FileListWidget extends StatelessWidget {
  final String selectedCourseId;
  final String? userRole;
  final Future<void> Function(String, String, String) onFileDeleted;

  const FileListWidget({
    super.key,
    required this.selectedCourseId,
    required this.userRole,
    required this.onFileDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses/$selectedCourseId/materials')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error loading files: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
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

        return CourseFileList(
          fileDocs: fileDocs,
          isDarkMode: isDarkMode,
          userRole: userRole ?? 'user',
          onFileDeleted: onFileDeleted,
          selectedCourseId: selectedCourseId,
        );
      },
    );
  }
}
