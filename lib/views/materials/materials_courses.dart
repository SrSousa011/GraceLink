import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/materials/file_list_widget.dart';

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
          } else {
            setState(() {
              _errorMessage = 'Usuário não registrado em nenhum curso.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Usuário não registrado em nenhum curso.';
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

  Future<void> _uploadFile() async {
    if (_selectedCourseId == null) {
      setState(() {
        _errorMessage = 'Selecione um curso primeiro.';
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
          _errorMessage = 'Erro ao carregar arquivo: $e';
        });
      }
    } else {
      setState(() {
        _errorMessage =
            'Seleção de arquivo cancelada ou tipo de arquivo inválido.';
      });
    }
  }

  Future<void> _deleteFile(
      String courseId, String fileId, String fileUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(fileUrl);
      await ref.delete();
      await _firestore
          .collection('courses/$courseId/materials')
          .doc(fileId)
          .delete();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir arquivo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Materiais do curso',
          style: TextStyle(fontSize: 18),
        ),
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
                _buildCourseDropdown(),
              if (_userRole == 'admin' && !_isFetchingCourses)
                const UploadButton(),
              const SizedBox(height: 16.0),
              if (_errorMessage != null) _buildErrorMessage(),
              Expanded(
                child: _selectedCourseId == null
                    ? const Center(
                        child: Text(
                            'Selecione um curso para visualizar os materiais'),
                      )
                    : FileListWidget(
                        selectedCourseId: _selectedCourseId!,
                        userRole: _userRole,
                        onFileDeleted: _deleteFile,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<String> _buildCourseDropdown() {
    return DropdownButton<String>(
      value: _selectedCourseId,
      hint: const Text('Selecione um curso'),
      items: _courses.map((course) {
        return DropdownMenuItem<String>(
          value: course['id'],
          child: Text(course['courseName'] ?? 'Unknown Course'),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCourseId = value;
            _errorMessage = null;
          });
        }
      },
    );
  }

  Padding _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final courseMaterialsPageState =
        context.findAncestorStateOfType<_CourseMaterialsPageState>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.upload_file),
          onPressed: courseMaterialsPageState?._uploadFile,
          tooltip: 'Upload File',
        ),
      ],
    );
  }
}
