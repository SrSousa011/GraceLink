import 'package:churchapp/views/courses/adminDashboard/subscriber_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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
    initializeDateFormatting();
  }

  Future<void> _fetchRegistrations() async {
    setState(() => _loading = true);

    try {
      final registrationsSnapshot =
          await _firestore.collection('courseRegistration').get();
      final registrations = await Future.wait(
        registrationsSnapshot.docs.map((doc) async {
          final data = doc.data();
          final courseId = data['courseId'] ?? '';
          final status = data['status'] ?? false;
          final courseName = courseId.isNotEmpty
              ? await _fetchCourseName(courseId)
              : 'Unknown';

          final userId = data['userId'] ?? 'Unknown';
          final userData = await _fetchUserData(userId);

          return {
            'userId': userId,
            'userName': data['userName'] ?? 'Unknown',
            'registrationDate':
                (data['registrationDate'] as Timestamp?)?.toDate() ??
                    DateTime.now(),
            'courseName': courseName,
            'status': status,
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Intl.defaultLocale = 'pt_BR';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Cadastrados'),
        backgroundColor: isDarkMode
            ? Colors.grey[850]
            : const Color.fromARGB(255, 255, 255, 255),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _registrations.length,
              itemBuilder: (context, index) {
                final registration = _registrations[index];
                final registrationDate =
                    registration['registrationDate'] as DateTime;
                final formattedDate =
                    DateFormat('d MMMM yyyy', 'pt_BR').format(registrationDate);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: registration['imagePath'] != ''
                        ? NetworkImage(registration['imagePath'])
                        : null,
                    backgroundColor:
                        isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    child: registration['imagePath'] == ''
                        ? Icon(
                            Icons.person,
                            color: isDarkMode ? Colors.white : Colors.black,
                          )
                        : null,
                  ),
                  title: Text(
                    registration['userName'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Curso: ${registration['courseName']} \nData de inscrição: $formattedDate',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Colors.black54,
                    ),
                  ),
                  tileColor: isDarkMode ? Colors.grey[800] : Colors.white,
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
