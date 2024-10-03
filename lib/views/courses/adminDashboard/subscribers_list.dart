import 'package:churchapp/views/courses/adminDashboard/subscriber_info.dart';
import 'package:churchapp/views/courses/adminDashboard/subscribers_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class SubscribersList extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>? enrolledDocuments;

  const SubscribersList({super.key, this.enrolledDocuments});

  @override
  State<SubscribersList> createState() => _SubscribersListState();
}

class _SubscribersListState extends State<SubscribersList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _registrations = [];
  bool _loading = true;
  String? _selectedCourseId;
  final List<String> _courses = [];
  final Map<String, String> _courseIds = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _fetchCourses();
    if (widget.enrolledDocuments != null) {
      _processEnrolledDocuments(widget.enrolledDocuments!);
    } else {
      _fetchRegistrations();
    }
  }

  Future<void> _fetchCourses() async {
    try {
      final courseSnapshot = await _firestore.collection('courses').get();
      _courses.add("Todos");
      for (var doc in courseSnapshot.docs) {
        final courseName = doc.data()['courseName'] ?? 'Unknown';
        _courses.add(courseName);
        _courseIds[courseName] = doc.id;
      }
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching courses: $e');
      }
    }
  }

  void _processEnrolledDocuments(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) async {
    setState(() => _loading = true);
    try {
      final registrations = await Future.wait(
        documents.map((doc) async {
          return await _processRegistrationData(doc);
        }).toList(),
      );

      setState(() {
        _registrations = registrations;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error processing enrolled documents: $e');
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _fetchRegistrations() async {
    setState(() => _loading = true);
    try {
      final registrationsSnapshot =
          await _firestore.collection('courseRegistration').get();
      final registrations = await Future.wait(
        registrationsSnapshot.docs.map((doc) async {
          return await _processRegistrationData(doc);
        }).toList(),
      );

      setState(() {
        _registrations = registrations;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching registrations: $e');
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<Map<String, dynamic>> _processRegistrationData(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = doc.data();
    final courseId = data['courseId'] ?? '';
    final status = data['status'] ?? false;
    final courseName =
        courseId.isNotEmpty ? await _fetchCourseName(courseId) : 'Unknown';
    final userId = data['userId'] ?? 'Unknown';
    final userData = await _fetchUserData(userId);

    return {
      'userId': userId,
      'userName': data['userName'] ?? 'Unknown',
      'registrationDate':
          (data['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      'courseName': courseName,
      'status': status,
      'imagePath': userData['imagePath'] ?? '',
    };
  }

  Future<String> _fetchCourseName(String courseId) async {
    try {
      final courseDoc =
          await _firestore.collection('courses').doc(courseId).get();
      final courseData = courseDoc.data();
      return courseData?['courseName'] ?? 'Unknown';
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching course name: $e');
      }
      return 'Unknown';
    }
  }

  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data() ?? {};
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      return {};
    }
  }

  List<Map<String, dynamic>> getFilteredRegistrations() {
    if (_selectedCourseId == null || _selectedCourseId == "Todos") {
      return _registrations;
    }
    return _registrations
        .where(
            (registration) => registration['courseName'] == _selectedCourseId)
        .toList();
  }

  void _showCourseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: _courses.map((courseName) {
              return ListTile(
                title: Text(courseName),
                onTap: () {
                  Navigator.of(context).pop(courseName);
                },
              );
            }).toList(),
          ),
        );
      },
    ).then((dynamic newValue) {
      if (newValue != null) {
        setState(() {
          _selectedCourseId = newValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Intl.defaultLocale = 'pt_BR';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Matriculados',
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, size: 17),
            onPressed: () {
              _showCourseBottomSheet(context);
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: getFilteredRegistrations().length,
              itemBuilder: (context, index) {
                final registration = getFilteredRegistrations()[index];
                return SubscriberTile(
                  registration: registration,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriberInfo(
                          userId: registration['userId'],
                          status: registration['status'],
                          userName: registration['userName'],
                          registrationDate: registration['registrationDate'],
                          courseName: registration['courseName'],
                          imagePath: registration['imagePath'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
