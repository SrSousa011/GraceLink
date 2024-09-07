import 'package:churchapp/views/donations/dashboard/donnation_receipt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DonationsList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DonationsList({super.key});

  String _formatTotal(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '€');
    return formatter.format(value);
  }

  double _parseDonationValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    } else if (value is String) {
      final sanitizedValue = value
          .replaceAll('€', '')
          .replaceAll(' ', '')
          .replaceAll(',', '.')
          .trim();

      return double.tryParse(sanitizedValue) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final Color secondaryTextColor =
        isDarkMode ? Colors.grey[300]! : Colors.grey;
    final Color donationValueColor =
        isDarkMode ? Colors.greenAccent : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Doações'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('donations').snapshots(),
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
                'Nenhuma doação encontrada',
                style: TextStyle(color: primaryTextColor),
              ),
            );
          }

          final donations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index].data() as Map<String, dynamic>;
              final fullName = donation['fullName'] ?? 'Desconhecido';

              final donationValue =
                  _parseDonationValue(donation['donationValue']);

              final donationType = donation['donationType'] ?? 'Sem tipo';
              final userId = donation['userId'];
              final paymentProofURL = donation['photoURL'] ?? '';

              final timestamp = donation['timestamp'] as Timestamp?;
              final date = timestamp != null
                  ? DateFormat('dd/MM/yyyy').format(timestamp.toDate())
                  : 'Desconhecida';

              return StreamBuilder<DocumentSnapshot>(
                stream: _firestore.collection('users').doc(userId).snapshots(),
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

                  final userData = userSnapshot.data;
                  final creatorName = userData?['fullName'] ?? fullName;
                  final creatorImageUrl = userData?['imagePath'] ?? '';

                  return ListTile(
                    leading: creatorImageUrl.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(creatorImageUrl),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          creatorName,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          donationType,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      _formatTotal(donationValue),
                      style: TextStyle(
                        color: donationValueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationReceipt(
                            title: 'Detalhes da Doação',
                            from: creatorName,
                            date: date,
                            total: donationValue,
                            paymentProofURL: paymentProofURL,
                            donorPhotoURL: creatorImageUrl,
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
