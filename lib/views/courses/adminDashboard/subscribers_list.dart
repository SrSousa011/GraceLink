import 'package:churchapp/views/courses/adminDashboard/subscriber_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubscribersList extends StatefulWidget {
  const SubscribersList({super.key});

  @override
  State<SubscribersList> createState() => _SubscribersListState();
}

class _SubscribersListState extends State<SubscribersList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _registrations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRegistrations();
  }

  Future<void> _fetchRegistrations() async {
    setState(() => _loading = true);

    try {
      final registrationsSnapshot =
          await _firestore.collection('courseregistration').get();
      final registrations = await Future.wait(
        registrationsSnapshot.docs.map((doc) async {
          final data = doc.data();
          final courseId = data['courseId'] ?? '';
          final courseName = courseId.isNotEmpty
              ? await _fetchCourseName(courseId)
              : 'Unknown';

          final userId = data['userId'] ?? 'Unknown';
          final userData = await _fetchUserData(userId);

          return {
            'userId': userId,
            'userName': data['userName'] ?? 'Unknown',
            'registrationDate':
                (data['registrationDate'] as Timestamp).toDate(),
            'courseName': courseName,
            'status': data['status'] ?? false,
            'imagePath': userData['imagePath'] ?? '',
          };
        }),
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

  Future<String> _fetchCourseName(String courseId) async {
    try {
      final courseDoc =
          await _firestore.collection('courses').doc(courseId).get();
      final courseData = courseDoc.data();
      return courseData?['title'] ?? 'Unknown';
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de incritos'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _registrations.length,
              itemBuilder: (context, index) {
                final registration = _registrations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(registration['imagePath'] ?? ''),
                    backgroundColor:
                        isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    child: registration['imagePath'] == ''
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(registration['userName']),
                  subtitle: Text(
                    'Course: ${registration['courseName']} \nRegistered on: ${registration['registrationDate'].toLocal().toString().split(' ')[0]}',
                  ),
                  tileColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriberViewer(
                          userId: registration['userId'],
                          userName: registration['userName'],
                          status: registration['status'],
                          registrationDate: registration['registrationDate'],
                          courseName: registration['courseName'],
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
