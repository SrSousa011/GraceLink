import 'package:churchapp/views/member/members_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BecomeMemberList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BecomeMemberList({super.key});

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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('becomeMember').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkMode ? Colors.white : Colors.black),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Nenhum membro encontrado',
                style: TextStyle(color: primaryTextColor),
              ),
            );
          }

          final members = snapshot.data!.docs;

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final memberDoc = members[index];
              final member = memberDoc.data() as Map<String, dynamic>;
              final createdById = member['createdById'] as String?;
              final memberId = memberDoc.id;
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

              return StreamBuilder<DocumentSnapshot>(
                stream:
                    _firestore.collection('users').doc(createdById).snapshots(),
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
                    subtitle: Text(
                      member['address'] as String? ?? 'Notfound',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: secondaryTextColor,
                      ),
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
}
