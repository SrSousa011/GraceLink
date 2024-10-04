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
  List<UserData> _allUsers = [];
  List<UserData> _filteredUsers = [];
  bool _isSearching = false;
  String _searchQuery = '';
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedRoleFilter = 'all';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      CollectionReference usersCollection = _firestore.collection('users');
      var snapshot = await usersCollection.orderBy('fullName').get();
      final usersList =
          snapshot.docs.map((doc) => UserData.fromDocument(doc)).toList();

      setState(() {
        _allUsers = usersList;
        _filteredUsers = _filterUsers(_searchQuery, _selectedRoleFilter);
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

  List<UserData> _filterUsers(String query, String roleFilter) {
    List<UserData> filteredUsers = _allUsers;

    if (query.isNotEmpty) {
      final lowercasedQuery = query.toLowerCase();
      filteredUsers = filteredUsers.where((user) {
        return user.fullName.toLowerCase().contains(lowercasedQuery);
      }).toList();
    }

    if (roleFilter == 'admin') {
      filteredUsers =
          filteredUsers.where((user) => user.role == 'admin').toList();
    } else if (roleFilter == 'user') {
      filteredUsers =
          filteredUsers.where((user) => user.role == 'user').toList();
    }

    filteredUsers.sort((a, b) => a.fullName.compareTo(b.fullName));

    return filteredUsers;
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredUsers = _filterUsers(_searchQuery, _selectedRoleFilter);
    });
  }

  void _updateRoleFilter(String? selectedRole) {
    setState(() {
      _selectedRoleFilter = selectedRole ?? 'all';
      _filteredUsers = _filterUsers(_searchQuery, _selectedRoleFilter);
    });
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
    final backgroundColor =
        isDarkMode ? const Color.fromARGB(255, 0, 0, 0) : Colors.white;
    final buttonDemoteColor = isDarkMode ? Colors.grey : Colors.red;
    final buttonPromoteColor = isDarkMode ? Colors.grey : Colors.blue;
    final buttonTextColor = isDarkMode ? Colors.white : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _updateSearchQuery,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Pesquisar por nomes...',
                      ),
                    )
                  : const Text(
                      'Painel de Admins',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
            ),
            IconButton(
              icon: Icon(_isSearching ? Icons.cancel : Icons.search),
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _searchController.clear();
                    _updateSearchQuery('');
                  }
                  _isSearching = !_isSearching;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 100, 100, 100),
                  items: [
                    const PopupMenuItem<String>(
                      value: 'all',
                      child: Text('Todos'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'admin',
                      child: Text('Administradores'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'user',
                      child: Text('Usuários'),
                    ),
                  ],
                ).then((selectedRole) {
                  if (selectedRole != null) {
                    _updateRoleFilter(selectedRole);
                  }
                });
              },
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  title: Text(
                    user.fullName,
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  subtitle: Text(
                    'Função: ${user.role ?? 'usuário'}',
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
                          child: const Text('Rebaixar'),
                        )
                      : ElevatedButton(
                          onPressed: () => _promoteToAdmin(user.userId),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                buttonPromoteColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                buttonTextColor),
                          ),
                          child: const Text('Promover'),
                        ),
                );
              },
            ),
    );
  }
}
