import 'package:churchapp/views/materials/error_message.dart';
import 'package:churchapp/views/materials/file_list.dart';
import 'package:churchapp/views/materials/upload_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

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
  List<String> _courses = [];
  String? _selectedCourseTitle; // Store the title of the selected course

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
        _courses = snapshot.docs.map((doc) => doc.id).toList();
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
        _fileDocs = snapshot.docs.map((doc) => doc.data()).toList();
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

    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
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
        _errorMessage = 'File selection canceled.';
      });
    }
  }

  Future<void> _handleCourseSelection(String courseId) async {
    setState(() {
      _selectedCourseId = courseId;
      _errorMessage = null;
    });

    // Fetch the course title
    final title = await getTitleById(courseId);
    setState(() {
      _selectedCourseTitle = title;
    });

    await _loadFiles(courseId);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Materials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_userRole == 'admin')
              DropdownButton<String>(
                hint: const Text('Select a Course'),
                value: _selectedCourseId,
                items: _courses.map((courseId) {
                  return DropdownMenuItem<String>(
                    value: courseId,
                    child: Text(courseId),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _handleCourseSelection(value);
                  }
                },
              ),
            const SizedBox(height: 16),
            if (_userRole == 'admin')
              UploadButton(
                isUploading: _isUploading,
                onPressed: _uploadFile,
              ),
            const SizedBox(height: 16),
            if (_errorMessage != null) ErrorMessage(message: _errorMessage!),
            if (_selectedCourseTitle != null)
              Text('Selected Course: $_selectedCourseTitle'),
            Expanded(
              child: _selectedCourseId == null
                  ? const Center(
                      child: Text('Please select a course to view materials.'))
                  : FileListView(
                      fileDocs: _fileDocs,
                      isDarkMode: isDarkMode,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
