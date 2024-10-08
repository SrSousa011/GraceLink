import 'package:churchapp/views/donations/dashboard/donnation_receipt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DonationsList extends StatefulWidget {
  const DonationsList({super.key});

  @override
  State<DonationsList> createState() => _DonationsListState();
}

class _DonationsListState extends State<DonationsList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showAllDonations = true;
  String sortOption = 'A-Z';
  bool ascendingOrder = true;

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

  Future<List<Map<String, dynamic>>> _fetchDonations() async {
    Query query = _firestore.collection('donations');

    if (!showAllDonations) {
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      query = query.where('timestamp', isGreaterThanOrEqualTo: firstDayOfMonth);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  List<Map<String, dynamic>> _sortDonations(
      List<Map<String, dynamic>> donations) {
    if (sortOption == 'A-Z') {
      donations
          .sort((a, b) => (a['fullName'] ?? '').compareTo(b['fullName'] ?? ''));
    } else if (sortOption == 'Valor') {
      donations.sort((a, b) => _parseDonationValue(a['donationValue'])
          .compareTo(_parseDonationValue(b['donationValue'])));
    } else if (sortOption == 'Data') {
      donations.sort((a, b) =>
          (a['timestamp'] as Timestamp).compareTo(b['timestamp'] as Timestamp));
    }

    if (!ascendingOrder) {
      donations = donations.reversed.toList();
    }

    return donations;
  }

  void _updateSortOption(String option) {
    setState(() {
      if (sortOption == option) {
        ascendingOrder = !ascendingOrder;
      } else {
        sortOption = option;
        ascendingOrder = true;
      }
    });
  }

  void _toggleDonationFilter() {
    setState(() {
      showAllDonations = !showAllDonations;
    });
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
        title: const Text(
          'Lista de Doações',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showAllDonations ? Icons.filter_list : Icons.filter_list_off,
              color: Colors.blueAccent,
            ),
            onPressed: _toggleDonationFilter,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.blueAccent),
            onSelected: (String value) {
              _updateSortOption(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'A-Z',
                  child: Row(
                    children: [
                      Icon(Icons.sort_by_alpha, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text(
                        'Ordenar A-Z',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Valor',
                  child: Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Ordenar por Valor',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Data',
                  child: Row(
                    children: [
                      Icon(Icons.date_range, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Ordenar por Data',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ];
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            elevation: 4,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkMode ? Colors.white : Colors.black),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar doações',
                style: TextStyle(color: primaryTextColor),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Nenhuma doação encontrada',
                style: TextStyle(color: primaryTextColor),
              ),
            );
          }

          final donations = snapshot.data!;
          final sortedDonations = _sortDonations(donations);

          return ListView.builder(
            itemCount: sortedDonations.length,
            itemBuilder: (context, index) {
              final donation = sortedDonations[index];
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

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(userId).get(),
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

                  if (!userSnapshot.hasData) {
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

                  final userData = userSnapshot.data!;
                  final creatorName = userData['fullName'] ?? fullName;
                  final creatorImageUrl = userData['imagePath'] ?? '';

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
