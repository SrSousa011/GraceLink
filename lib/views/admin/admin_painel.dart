import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/models/user_data.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserData> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      setState(() {
        _users =
            snapshot.docs.map((doc) => UserData.fromDocument(doc)).toList();
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _promoteToAdmin(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'role': 'admin'});
      _fetchUsers(); // Refresh the list
    } catch (e) {
      if (kDebugMode) {
        print('Error promoting user to admin: $e');
      }
    }
  }

  Future<void> _demoteFromAdmin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({'role': 'user'});
      _fetchUsers(); // Refresh the list
    } catch (e) {
      if (kDebugMode) {
        print('Error demoting user from admin: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.fullName),
                  subtitle: Text('Role: ${user.role ?? 'user'}'),
                  trailing: user.role == 'admin'
                      ? ElevatedButton(
                          onPressed: () => _demoteFromAdmin(user.id),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              isDarkMode ? Colors.grey : Colors.red,
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          child: const Text('Demote'),
                        )
                      : ElevatedButton(
                          onPressed: () => _promoteToAdmin(user.id),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              isDarkMode ? Colors.grey : Colors.blue,
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          child: const Text('Promote'),
                        ),
                );
              },
            ),
    );
  }
}
