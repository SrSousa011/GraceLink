import 'package:churchapp/views/member/members_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BecomeMemberList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String filter;

  BecomeMemberList({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final Color secondaryTextColor =
        isDarkMode ? Colors.grey[300]! : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Membros'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getFilteredMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkMode ? Colors.white : Colors.black),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Nenhum membro encontrado',
                style: TextStyle(color: primaryTextColor),
              ),
            );
          }

          final members = snapshot.data!;

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              final createdById = member['createdById'] as String?;
              final memberId = member['id'] as String;

              if (createdById == null) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    'Usuário não encontrado',
                    style: TextStyle(color: primaryTextColor),
                  ),
                );
              }

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(createdById).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      title: Text(
                        'Carregando...',
                        style: TextStyle(color: primaryTextColor),
                      ),
                    );
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        'Usuário não encontrado',
                        style: TextStyle(color: primaryTextColor),
                      ),
                    );
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final creatorName =
                      userData['fullName'] as String? ?? 'Desconhecido';
                  final creatorImageUrl = userData['imagePath'] as String?;
                  final creatorAddress =
                      userData['address'] as String? ?? 'Não encontrado';

                  return ListTile(
                    leading:
                        creatorImageUrl != null && creatorImageUrl.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(creatorImageUrl),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                    title: Text(
                      creatorName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          creatorAddress,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberDetailsScreen(
                            memberId: memberId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getFilteredMembers() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final List<Map<String, dynamic>> membersList = [];

    QuerySnapshot querySnapshot;

    switch (filter) {
      case 'male':
        querySnapshot = await _firestore
            .collection('members')
            .where('gender', isEqualTo: 'Masculino')
            .get();
        break;
      case 'female':
        querySnapshot = await _firestore
            .collection('members')
            .where('gender', isEqualTo: 'Feminino')
            .get();
        break;
      case 'children':
        querySnapshot = await _firestore
            .collection('members')
            .where('dateOfBirth',
                isGreaterThanOrEqualTo:
                    now.subtract(const Duration(days: 365 * 12)))
            .get();
        break;
      case 'new':
        querySnapshot = await _firestore
            .collection('members')
            .where('membershipDate', isGreaterThanOrEqualTo: startOfMonth)
            .get();
        break;
      case 'all':
      default:
        querySnapshot = await _firestore.collection('members').get();
        break;
    }

    for (var doc in querySnapshot.docs) {
      membersList.add({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    }

    return membersList;
  }
}
