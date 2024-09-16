import 'package:churchapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class MemberDetailsScreen extends StatelessWidget {
  final String memberId;

  const MemberDetailsScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    const titleColorLight = Colors.blue;
    const titleHColorLight = Color.fromARGB(255, 255, 255, 255);
    const infoValueColorLight = Colors.black;
    const containerColorLight = Colors.white;
    final containerShadowColorLight = Colors.black.withOpacity(0.1);

    const titleColorDark = Colors.grey;
    final infoTitleColorDark = Colors.grey[300]!;
    final containerColorDark = Colors.grey[800]!;
    final containerShadowColorDark = Colors.black.withOpacity(0.3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Membro'),
        backgroundColor: isDarkMode ? titleColorDark : titleHColorLight,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('members')
            .doc(memberId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Membro não encontrado'));
          }

          final memberData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (memberData.containsKey('imagePath') &&
                    memberData['imagePath'] != null &&
                    memberData['imagePath'].isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? containerShadowColorDark
                              : containerShadowColorLight,
                          blurRadius: 8.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        memberData['imagePath'],
                        height: 200.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                _buildSectionTitle('Informações Pessoais',
                    isDarkMode ? titleColorDark : titleColorLight),
                _buildInfoContainer(
                    'Nome Completo',
                    memberData['fullName'],
                    isDarkMode ? infoTitleColorDark : infoValueColorLight,
                    isDarkMode ? containerColorDark : containerColorLight),
                _buildInfoContainer(
                    'Telefone',
                    memberData['phoneNumber'],
                    isDarkMode ? infoTitleColorDark : infoValueColorLight,
                    isDarkMode ? containerColorDark : containerColorLight),
                _buildInfoContainer(
                    'Endereço',
                    memberData['address'],
                    isDarkMode ? infoTitleColorDark : infoValueColorLight,
                    isDarkMode ? containerColorDark : containerColorLight),
                const SizedBox(height: 16.0),
                _buildSectionTitle('Informações da Igreja',
                    isDarkMode ? titleColorDark : titleColorLight),
                _buildInfoContainer(
                    'Última Igreja Visitada',
                    memberData['lastVisitedChurch'],
                    isDarkMode ? infoTitleColorDark : infoValueColorLight,
                    isDarkMode ? containerColorDark : containerColorLight),
                _buildInfoContainer(
                    'Razão para Adesão',
                    memberData['reasonForMembership'],
                    isDarkMode ? infoTitleColorDark : infoValueColorLight,
                    isDarkMode ? containerColorDark : containerColorLight),
                _buildInfoContainer(
                    'Referência',
                    memberData['reference'],
                    isDarkMode ? infoTitleColorDark : infoValueColorLight,
                    isDarkMode ? containerColorDark : containerColorLight),
                _buildInfoContainer(
                    'Estado Civil',
                    memberData['civilStatus'],
                    isDarkMode ? infoTitleColorDark : infoValueColorLight,
                    isDarkMode ? containerColorDark : containerColorLight),
                const SizedBox(height: 16.0),
                if (memberData.containsKey('membershipDate') &&
                    memberData['membershipDate'] != null)
                  _buildInfoContainer(
                    'Data de Adesão',
                    _formatDate(
                        (memberData['membershipDate'] as Timestamp).toDate()),
                    isDarkMode ? infoTitleColorDark : infoValueColorLight,
                    isDarkMode ? containerColorDark : containerColorLight,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoContainer(
      String title, String? value, Color textColor, Color containerColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: textColor,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.0,
                color: textColor.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
