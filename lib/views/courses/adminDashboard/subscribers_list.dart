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
      QuerySnapshot snapshot =
          await _firestore.collection('courseregistration').get();

      setState(() {
        _registrations = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'userId': data['userId'] ?? 'Unknown',
            'userName': data['userName'] ?? 'Unknown',
            'registrationDate':
                (data['registrationDate'] as Timestamp).toDate(),
            'courseName': data['courseName'] ??
                'Unknown', // Adjust field name if necessary
            'status': data['status'] ?? false, // Adjust field name if necessary
          };
        }).toList();
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
                      'Registered on: ${registration['registrationDate'].toLocal().toString().split(' ')[0]}'),
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
