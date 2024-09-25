import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DonationIncomes extends StatefulWidget {
  const DonationIncomes({super.key});

  @override
  State<DonationIncomes> createState() => _DonationIncomesState();
}

class _DonationIncomesState extends State<DonationIncomes> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double totalIncome = 0.0;
  List<Map<String, dynamic>> donationsList = [];

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    CollectionReference donations = _firestore.collection('donations');
    var snapshot = await donations.get();

    setState(() {
      donationsList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'fullName': data['fullName'] ?? 'Desconhecido',
          'donationValue': (data['donationValue'] as num).toDouble(),
          'donationType': data['donationType'] ?? 'Sem tipo',
          'timestamp': data['timestamp'] as Timestamp,
          'photoURL': data['photoURL'] ?? '',
        };
      }).toList();

      // Calculate total income
      totalIncome = donationsList.fold(
          0, (sum, donation) => sum + donation['donationValue']);
    });
  }

  String _formatTotal(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '€');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Renda das Doações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total de Renda',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTotal(totalIncome),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.greenAccent : Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: donationsList.isEmpty
                  ? const Center(child: Text('Nenhuma doação encontrada.'))
                  : ListView.builder(
                      itemCount: donationsList.length,
                      itemBuilder: (context, index) {
                        final donation = donationsList[index];
                        final fullName = donation['fullName'];
                        final donationValue = donation['donationValue'];
                        final donationType = donation['donationType'];
                        final timestamp = donation['timestamp'];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(donation['photoURL']),
                              backgroundColor: Colors.grey,
                            ),
                            title: Text(fullName),
                            subtitle: Text(donationType),
                            trailing: Text(
                              _formatTotal(donationValue),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              // Optionally navigate to a detailed donation view
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
