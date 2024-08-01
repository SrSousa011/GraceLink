import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:churchapp/models/user_data.dart';

class SubscribersList extends StatefulWidget {
  final int courseId;

  const SubscribersList({super.key, required this.courseId});

  @override
  State<SubscribersList> createState() => _SubscribersListState();
}

class _SubscribersListState extends State<SubscribersList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _subscribers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubscribers();
  }

  Future<void> _fetchSubscribers() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('courseregistration')
          .where('courseId', isEqualTo: widget.courseId)
          .get();
      setState(() {
        _subscribers = snapshot.docs;
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching subscribers: $e');
      }
      setState(() {
        _loading = false;
      });
    }
  }

  Future<UserData> _fetchUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return UserData.fromDocument(userDoc);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      return UserData(
        id: userId,
        fullName: 'Unknown',
        address: '',
        imagePath: '',
        role: 'user',
      );
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
              itemCount: _subscribers.length,
              itemBuilder: (context, index) {
                final subscriber =
                    _subscribers[index].data() as Map<String, dynamic>;

                final userId = subscriber['userId'] ?? '';
                final status = subscriber['status'] ?? false;
                final registrationDate =
                    (subscriber['registrationDate'] as Timestamp?)?.toDate() ??
                        DateTime.now();

                return FutureBuilder<UserData>(
                  future: _fetchUserData(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        title: Text('Loading...'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return ListTile(
                        title: const Text('Error fetching user data'),
                      );
                    }

                    final userData = snapshot.data!;

                    return ListTile(
                      title: Text(userData.fullName),
                      subtitle: Text(
                          'Status: ${status ? 'Payed' : 'Not Payed'}\nRegistration Date: ${registrationDate.toLocal()}'),
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
                          Navigator.pushNamed(
                            context,
                            '/subscriber_viewer',
                            arguments: {
                              'userId': userData.id,
                              'userName': userData.fullName,
                              'status': status,
                              'registrationDate': registrationDate,
                            },
                          );
                        },
                        child: const Text('View Details'),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
