import 'package:churchapp/views/donations/dashboard/donnation_receipt.dart';
import 'package:churchapp/views/donations/dashboard/donnations_list.dart';
import 'package:churchapp/views/donations/donnation_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DonationReportScreen extends StatefulWidget {
  const DonationReportScreen({super.key});

  @override
  State<DonationReportScreen> createState() => _DonationReportScreenState();
}

class _DonationReportScreenState extends State<DonationReportScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Donation>> _fetchDonations() async {
    CollectionReference donations = _firestore.collection('donations');
    var snapshot = await donations.orderBy('timestamp', descending: true).get();
    final donationsList =
        snapshot.docs.map((doc) => Donation.fromFirestore(doc)).toList();
    return donationsList;
  }

  String _formatTotal(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '€');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('User not authenticated.'));
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final layoutTextColor = isDarkMode ? Colors.white : Colors.white;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final cardTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardShadowColor = isDarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.2);
    final accentColor = isDarkMode ? Colors.blueGrey : Colors.blue;
    final incomeColor = isDarkMode ? Colors.greenAccent : Colors.green;
    final donationValueColor = isDarkMode ? Colors.greenAccent : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final userName = data['fullName'] ?? 'User';

          return FutureBuilder<List<Donation>>(
            future: _fetchDonations(),
            builder: (context, donationsSnapshot) {
              if (donationsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (donationsSnapshot.hasError) {
                return Center(
                    child: Text(
                        'Error fetching donations: ${donationsSnapshot.error}'));
              }

              final donations = donationsSnapshot.data ?? [];
              final donationStats =
                  DonationStats.fromDonations(donations.cast<Donation>());
              final totalBalance = donationStats.totalDonation;
              final monthlyIncome =
                  donationStats.monthlyDonations.reduce((a, b) => a + b);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(60)),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60.0, left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bom Dia',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: layoutTextColor)),
                            const SizedBox(height: 8),
                            Text(userName,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: layoutTextColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0.0, -100.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: cardBackgroundColor,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(40),
                                    bottom: Radius.circular(40)),
                                boxShadow: [
                                  BoxShadow(
                                      color: cardShadowColor,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _buildFinancialCard(
                                    icon: Icons.account_balance_wallet,
                                    title: 'Saldo total',
                                    value: _formatTotal(totalBalance),
                                    valueStyle: TextStyle(
                                        fontSize: 18, color: cardTextColor),
                                    withShadow: false,
                                    backgroundColor: cardBackgroundColor,
                                    titleStyle: TextStyle(
                                        fontSize: 18, color: cardTextColor),
                                  ),
                                  _buildFinancialCard(
                                    icon: Icons.trending_up,
                                    title: 'Renda mensal',
                                    value: _formatTotal(monthlyIncome),
                                    valueStyle: TextStyle(
                                        fontSize: 14, color: incomeColor),
                                    withShadow: false,
                                    backgroundColor: Colors.transparent,
                                    titleStyle: TextStyle(
                                        fontSize: 15, color: cardTextColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[850]! : Colors.blue[50]!,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20), bottom: Radius.circular(0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance,
                                size: 22, color: accentColor),
                            const SizedBox(width: 8),
                            Text('Doações Recentes',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DonationsList()),
                                );
                              },
                              child: Text('Ver Todos',
                                  style: TextStyle(
                                      fontSize: 14, color: accentColor)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
// Modificação na parte de ListView.builder onde as doações são listadas
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 16.0),
                      child: donations.isEmpty
                          ? const Center(child: Text('No donations found.'))
                          : ListView.builder(
                              itemCount: donations.length,
                              itemBuilder: (context, index) {
                                final donation = donations[index];
                                final fullName = donation.fullName.isNotEmpty
                                    ? donation.fullName
                                    : 'Anonymous';

                                return StreamBuilder<DocumentSnapshot>(
                                  stream: _firestore
                                      .collection('users')
                                      .doc(user.uid)
                                      .snapshots(),
                                  builder: (context, userSnapshot) {
                                    if (userSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    isDarkMode
                                                        ? Colors.white
                                                        : Colors.black),
                                          ),
                                        ),
                                        title: Text(
                                          'Carregando...',
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                      );
                                    }

                                    if (userSnapshot.hasError) {
                                      return ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.grey,
                                        ),
                                        title: Text(
                                          'Erro ao carregar imagem do usuário',
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                      );
                                    }

                                    if (!userSnapshot.hasData ||
                                        !userSnapshot.data!.exists) {
                                      return ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.grey,
                                        ),
                                        title: Text(
                                          'Usuário não encontrado',
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                      );
                                    }

                                    final userData = userSnapshot.data!.data()
                                        as Map<String, dynamic>;
                                    final userImagePath =
                                        userData['imagePath'] ?? '';

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(userImagePath),
                                          backgroundColor: Colors.grey,
                                        ),
                                        title: Text(fullName),
                                        subtitle: Text(donation.donationType),
                                        trailing: Text(
                                          _formatTotal(donation.donationValue
                                              .toDouble()),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: donationValueColor),
                                        ),
                                        onTap: () {
                                          final date = DateFormat('dd/MM/yyyy')
                                              .format(
                                                  donation.timestamp.toDate());
                                          final paymentProofURL =
                                              donation.photoURL;

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DonationReceipt(
                                                title: 'Detalhes da Doação',
                                                from: fullName,
                                                date: date,
                                                total: donation.donationValue
                                                    .toDouble(),
                                                paymentProofURL:
                                                    paymentProofURL,
                                                donorPhotoURL: userImagePath,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFinancialCard({
    required IconData icon,
    required String title,
    required String value,
    required TextStyle valueStyle,
    required bool withShadow,
    required Color backgroundColor,
    required TextStyle titleStyle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle),
                const SizedBox(height: 4),
                Text(value, style: valueStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DonationStats {
  final double totalDonation;
  final List<double> monthlyDonations;

  DonationStats({required this.totalDonation, required this.monthlyDonations});

  static DonationStats fromDonations(List<Donation> donations) {
    double totalDonation = 0;
    List<double> monthlyDonations = List.filled(12, 0);

    for (var donation in donations) {
      totalDonation += donation.donationValue.toDouble();

      final date = (donation.timestamp.toDate());
      final month = date.month - 1; // Adjust for 0-indexing
      monthlyDonations[month] += donation.donationValue.toDouble();
    }

    return DonationStats(
      totalDonation: totalDonation,
      monthlyDonations: monthlyDonations,
    );
  }
}
