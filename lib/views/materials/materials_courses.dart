import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/materials/file_list.dart';
import 'package:churchapp/views/materials/upload_button.dart';
import 'package:churchapp/views/materials/error_message.dart';

class CourseMaterialsPage extends StatefulWidget {
  const CourseMaterialsPage({super.key});

  @override
  State<CourseMaterialsPage> createState() => _CourseMaterialsPageState();
}

class _CourseMaterialsPageState extends State<CourseMaterialsPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _courses = [];
  bool _isFetchingCourses = true;
  String? _selectedCourseId;
  String? _userRole;
  String? _errorMessage;
  String? _selectedCourseTitle;
  String? _selectedCourseImageUrl;
  String? _selectedInstructorName;

  @override
  void initState() {
    super.initState();
    _fetchUserRoleAndCourses();
  }

  Future<void> _fetchUserRoleAndCourses() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      setState(() {
        _errorMessage = 'User not logged in.';
        _isFetchingCourses = false;
      });
      return;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      _userRole = userDoc.data()?['role'] as String? ?? 'user';

      if (_userRole == 'admin') {
        final coursesSnapshot = await _firestore.collection('courses').get();
        _courses = coursesSnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'courseName': data['courseName'] as String? ?? 'Unknown Course',
          };
        }).toList();
      } else {
        final registrationSnapshot = await _firestore
            .collection('courseRegistration')
            .where('userId', isEqualTo: userId)
            .get();

        if (registrationSnapshot.docs.isNotEmpty) {
          _courses = await Future.wait(
            registrationSnapshot.docs.map((doc) async {
              final courseId = doc['courseId'];
              final courseDoc =
                  await _firestore.collection('courses').doc(courseId).get();
              return {
                'id': courseId,
                'courseName': courseDoc.data()?['courseName'] as String? ??
                    'Unknown Course',
              };
            }),
          );
          if (_courses.isNotEmpty) {
            _selectedCourseId = _courses.first['id'];
            await _handleCourseSelection(_selectedCourseId!);
          } else {
            setState(() {
              _errorMessage = 'User not registered in any course.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'User not registered in any course.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data: $e';
      });
    } finally {
      setState(() {
        _isFetchingCourses = false;
      });
    }
  }

  Future<String?> getTitleById(String courseId) async {
    try {
      final doc = await _firestore.collection('courses').doc(courseId).get();
      return doc.data()?['courseName'] as String?;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching course name: $e';
      });
      return null;
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedCourseId == null) {
      setState(() {
        _errorMessage = 'Select a course first.';
      });
      return;
    }

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'mp4',
        'mkv',
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx'
      ],
    );

    if (result != null && result.files.single.path != null) {
      final File file = File(result.files.single.path!);
      setState(() {
        _errorMessage = null;
      });

      try {
        final String fileName = result.files.single.name;
        final Reference ref =
            _storage.ref('courses/${_selectedCourseId!}/$fileName');
        await ref.putFile(file);
        final String fileUrl = await ref.getDownloadURL();
        await _firestore
            .collection('courses/${_selectedCourseId!}/materials')
            .add({
          'url': fileUrl,
          'name': fileName,
          'visibility': 'public',
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Error uploading file: $e';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'File selection canceled or invalid file type.';
      });
    }
  }

  Future<void> _handleCourseSelection(String courseId) async {
    setState(() {
      _selectedCourseId = courseId;
      _errorMessage = null;
    });

    final title = await getTitleById(courseId);
    setState(() {
      _selectedCourseTitle = title ?? 'No Title';
    });

    final courseData =
        await _firestore.collection('courses').doc(courseId).get();
    setState(() {
      _selectedCourseImageUrl = courseData.data()?['imageURL'];
      _selectedInstructorName = courseData.data()?['instructor'];
    });
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
      await _deleteFile(context, courseId, fileId, fileUrl);
    }
  }

  Future<void> _deleteFile(BuildContext context, String courseId, String fileId,
      String fileUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(fileUrl);
      await ref.delete();

      await FirebaseFirestore.instance
          .collection('courses/$courseId/materials')
          .doc(fileId)
          .delete();
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Materials'),
      ),
      body: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isFetchingCourses)
                const Center(child: CircularProgressIndicator()),
              if (!_isFetchingCourses && _courses.isNotEmpty)
                DropdownButton<String>(
                  value: _selectedCourseId,
                  hint: const Text('Select a course'),
                  items: _courses.map((course) {
                    return DropdownMenuItem<String>(
                      value: course['id'],
                      child: Text(course['courseName'] ?? 'Unknown Course'),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      await _handleCourseSelection(value);
                    }
                  },
                ),
              if (_userRole == 'admin' && !_isFetchingCourses)
                Center(
                  child: Column(
                    children: [
                      UploadButton(
                        isUploading: false,
                        onPressed: _uploadFile,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16.0),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedCourseImageUrl != null
                    ? Container(
                        key: ValueKey<String>(_selectedCourseImageUrl!),
                        padding: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: isDarkMode
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF3C3C3C),
                                    Color(0xFF5A5A5A)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFFFFD59C),
                                    Color(0xFF62CFF7)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 120.0,
                              height: 160.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(_selectedCourseImageUrl!),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_selectedCourseTitle != null)
                                    Text(
                                      _selectedCourseTitle!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  if (_selectedInstructorName != null)
                                    Text(
                                      '$_selectedInstructorName',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              if (_errorMessage != null) ErrorMessage(message: _errorMessage!),
              Expanded(
                child: _selectedCourseId == null
                    ? const Center(
                        child: Text('Select a course to view materials'))
                    : StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('courses/$_selectedCourseId/materials')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return ErrorMessage(
                                message:
                                    'Error loading files: ${snapshot.error}');
                          }

                          if (!snapshot.hasData ||
                              snapshot.data?.docs.isEmpty == true) {
                            return const Center(
                                child: Text('No files available.'));
                          }

                          final fileDocs = snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return {
                              'id': doc.id,
                              'url': data['url'] as String?,
                              'name': data['name'] as String?,
                              'courseId': _selectedCourseId!,
                              'visibility':
                                  data['visibility'] as String? ?? 'public',
                            };
                          }).toList();

                          return FileListView(
                            fileDocs: fileDocs,
                            isDarkMode: isDarkMode,
                            userRole: _userRole ?? 'user',
                            onFileDeleted: (courseId, fileId, fileUrl) async {
                              await _confirmDeleteFile(
                                  context, courseId, fileId, fileUrl);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
