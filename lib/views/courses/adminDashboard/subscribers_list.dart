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
    try {
      // Fetch all course registrations
      QuerySnapshot registrationsSnapshot =
          await _firestore.collection('courseregistration').get();
      List<Map<String, dynamic>> registrations = [];

      // Fetch course details for each registration
      for (var doc in registrationsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final courseId = data['courseId'] ?? '';

        // Fetch course title
        String courseName = 'Unknown'; // Default value
        if (courseId.isNotEmpty) {
          courseName = await _fetchCourseName(courseId);
        }

        registrations.add({
          'userId': data['userId'] ?? 'Unknown',
          'userName': data['userName'] ?? 'Unknown',
          'registrationDate': (data['registrationDate'] as Timestamp).toDate(),
          'courseName': courseName,
          'status': data['status'] ?? false,
        });
      }

      setState(() {
        _registrations = registrations;
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching registrations: $e');
      }
      setState(() {
        _loading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscribers List'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _registrations.length,
              itemBuilder: (context, index) {
                final registration = _registrations[index];
                return ListTile(
                  title: Text(registration['userName']),
                  subtitle: Text(
                      'Course: ${registration['courseName']} \nRegistered on: ${registration['registrationDate'].toLocal().toString().split(' ')[0]}'),
                  trailing: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        isDarkMode ? Colors.grey : Colors.blue,
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        isDarkMode
                            ? Colors.white
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    onPressed: () {
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
                    child: const Text('View Details'),
                  ),
                );
              },
            ),
    );
  }
}
