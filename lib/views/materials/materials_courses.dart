import 'package:churchapp/views/materials/file_list.dart';
import 'package:churchapp/views/materials/upload_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/materials/error_message.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class CourseMaterialsPage extends StatefulWidget {
  const CourseMaterialsPage({super.key});

  @override
  State<CourseMaterialsPage> createState() => _CourseMaterialsPageState();
}

class _CourseMaterialsPageState extends State<CourseMaterialsPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _fileDocs = [];
  bool _isUploading = false;
  String? _selectedCourseId;
  String? _userRole;
  String? _errorMessage;
  List<Map<String, dynamic>> _courses = [];
  String? _selectedCourseTitle;
  String? _selectedCourseImageUrl;
  String? _selectedInstructorName;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    _fetchCourses();
  }

  Future<void> _fetchUserRole() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        setState(() {
          _userRole = userDoc.data()?['role'] as String? ?? 'user';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Error fetching user role: $e';
        });
      }
    }
  }

  Future<void> _fetchCourses() async {
    try {
      final snapshot = await _firestore.collection('courses').get();
      setState(() {
        _courses = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'title': data['title'] as String? ?? 'No Title',
            'imageURL': data['imageURL'] as String?,
            'instructor': data['instructor'] as String?,
          };
        }).toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching courses: $e';
      });
    }
  }

  Future<String?> getTitleById(String courseId) async {
    try {
      final doc = await _firestore.collection('courses').doc(courseId).get();
      return doc.data()?['title'] as String?;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching course title: $e';
      });
      return null;
    }
  }

  Future<void> _loadFiles(String courseId) async {
    if (courseId.isEmpty) {
      setState(() {
        _errorMessage = 'Course ID cannot be empty.';
      });
      return;
    }

    final query = _userRole == 'admin'
        ? _firestore.collection('courses/$courseId/materials')
        : _firestore
            .collection('courses/$courseId/materials')
            .where('visibility', isEqualTo: 'public');
    try {
      final snapshot = await query.get();
      setState(() {
        _fileDocs = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'url': data['url'] as String?,
            'name': data['name'] as String?,
            'courseId': courseId,
          };
        }).toList();
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading files: $e';
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedCourseId == null) {
      setState(() {
        _errorMessage = 'Please select a course first.';
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
        _isUploading = true;
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
        await _loadFiles(_selectedCourseId!);
      } catch (e) {
        setState(() {
          _errorMessage = 'Error uploading file: $e';
        });
      } finally {
        setState(() {
          _isUploading = false;
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
        _courses.firstWhere((course) => course['id'] == courseId);
    setState(() {
      _selectedCourseImageUrl = courseData['imageURL'];
      _selectedInstructorName = courseData['instructor'];
    });

    await _loadFiles(courseId);
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
              if (_userRole == 'admin')
                Center(
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        hint: const Text('Select a Course'),
                        value: _selectedCourseId,
                        items: _courses.map((course) {
                          return DropdownMenuItem<String>(
                            value: course['id'],
                            child: Text(course['title'] ?? 'No Title'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _handleCourseSelection(value);
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      UploadButton(
                        isUploading: _isUploading,
                        onPressed: _uploadFile,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16.0),
              if (_selectedCourseImageUrl != null)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: isDarkMode
                        ? const LinearGradient(
                            colors: [Color(0xFF3C3C3C), Color(0xFF5A5A5A)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : const LinearGradient(
                            colors: [Color(0xFFFFD59C), Color(0xFF62CFF7)],
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
                                'Instructor: $_selectedInstructorName',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (_errorMessage != null) ErrorMessage(message: _errorMessage!),
              Expanded(
                child: FileListView(
                  fileDocs: _fileDocs,
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
