import 'package:churchapp/data/model/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
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
      _fetchUsers();
    } catch (e) {
      if (kDebugMode) {
        print('Error promoting user to admin: $e');
      }
    }
  }

  Future<void> _demoteFromAdmin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({'role': 'user'});
      _fetchUsers();
    } catch (e) {
      if (kDebugMode) {
        print('Error demoting user from admin: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final buttonDemoteColor = isDarkMode ? Colors.grey : Colors.red;
    final buttonPromoteColor = isDarkMode ? Colors.grey : Colors.blue;
    final buttonTextColor = isDarkMode ? Colors.white : const Color(0xFFFFFFFF);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Admins'),
      ),
      backgroundColor: backgroundColor,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  color: cardColor,
                  child: ListTile(
                    title: Text(
                      user.fullName,
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    subtitle: Text(
                      'Role: ${user.role ?? 'user'}',
                      style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                    trailing: user.role == 'admin'
                        ? ElevatedButton(
                            onPressed: () => _demoteFromAdmin(user.userId),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  buttonDemoteColor),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  buttonTextColor),
                            ),
                            child: const Text('Demote'),
                          )
                        : ElevatedButton(
                            onPressed: () => _promoteToAdmin(user.userId),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  buttonPromoteColor),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  buttonTextColor),
                            ),
                            child: const Text('Promote'),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
