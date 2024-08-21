import 'package:churchapp/views/donations/dashboard/donnatio_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Importa o pacote intl para formatação de datas

class DonationsList extends StatefulWidget {
  const DonationsList({super.key});

  @override
  State<DonationsList> createState() => _DonationsListState();
}

class _DonationsListState extends State<DonationsList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _donations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('donations').get();
      setState(() {
        _donations = snapshot.docs;
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching donations: $e');
      }
      setState(() {
        _loading = false;
      });
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
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkMode ? Colors.white : Colors.black),
              ),
            )
          : ListView.builder(
              itemCount: _donations.length,
              itemBuilder: (context, index) {
                final donation =
                    _donations[index].data() as Map<String, dynamic>;
                final fullName = donation['fullName'] ?? 'Unknown';
                final donationValue = donation['donationValue'] ?? '0.00';
                final donationType = donation['donationType'] ?? 'No type';
                final userId = donation['userId'];
                final paymentProofURL = donation['photoURL'] ?? '';

                // Formatação da data e hora
                final timestamp = donation['timestamp'] as Timestamp?;
                final date = timestamp != null
                    ? DateFormat('dd/MM/yyyy').format(timestamp.toDate())
                    : 'Unknown';
                final time = timestamp != null
                    ? DateFormat('HH:mm').format(timestamp.toDate())
                    : 'Unknown';

                return StreamBuilder<DocumentSnapshot>(
                  stream:
                      _firestore.collection('users').doc(userId).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                          donationType,
                          style: TextStyle(color: primaryTextColor),
                        ),
                        subtitle: Text(
                          fullName,
                          style: TextStyle(color: secondaryTextColor),
                        ),
                        trailing: Text(
                          '+ $donationValue',
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
                              builder: (context) => DonationViewer(
                                title: 'Donation Details',
                                from: fullName,
                                amount: donationValue,
                                time: time,
                                date: date,
                                total: donationValue,
                                paymentProofURL: paymentProofURL,
                              ),
                            ),
                          );
                        },
                      );
                    }

                    final userData = snapshot.data!;
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
                            donationType,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            creatorName,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '+ $donationValue',
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
                            builder: (context) => DonationViewer(
                              title: 'Donation Details',
                              from: creatorName,
                              amount: donationValue,
                              time: time,
                              date: date,
                              total: donationValue,
                              paymentProofURL: paymentProofURL,
                            ),
                          ),
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
