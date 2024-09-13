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
      body: StreamBuilder<QuerySnapshot>(
        stream: _getFilteredMembers(),
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['address'] as String? ?? 'Não encontrado',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: secondaryTextColor,
                          ),
                        ),
                        if (member['baptismDate'] != null &&
                            member['baptismDate'] is Timestamp)
                          Text(
                            'Data de Batismo: ${_formatDate((member['baptismDate'] as Timestamp).toDate())}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: secondaryTextColor,
                            ),
                          ),
                        if (member['conversionDate'] != null &&
                            member['conversionDate'] is Timestamp)
                          Text(
                            'Data de Conversão: ${_formatDate((member['conversionDate'] as Timestamp).toDate())}',
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

  Stream<QuerySnapshot> _getFilteredMembers() {
    final now = DateTime.now();
    final twelveYearsAgo = now.subtract(const Duration(days: 365 * 12));
    final startOfMonth = DateTime(now.year, now.month, 1);

    switch (filter) {
      case 'male':
        return _firestore
            .collection('becomeMember')
            .where('gender', isEqualTo: 'Masculino')
            .snapshots();
      case 'female':
        return _firestore
            .collection('becomeMember')
            .where('gender', isEqualTo: 'Feminino')
            .snapshots();
      case 'children':
        return _firestore
            .collection('becomeMember')
            .where('birthDate', isGreaterThanOrEqualTo: twelveYearsAgo)
            .snapshots();
      case 'new':
        return _firestore
            .collection('becomeMember')
            .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
            .snapshots();
      case 'all':
      default:
        return _firestore.collection('becomeMember').snapshots();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
