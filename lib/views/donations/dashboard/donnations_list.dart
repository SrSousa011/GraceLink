import 'package:churchapp/views/donations/dashboard/donnatio_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations List'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _donations.length,
              itemBuilder: (context, index) {
                final donation =
                    _donations[index].data() as Map<String, dynamic>;

                final fullName = donation['fullName'] ?? 'Unknown';
                final donationType = donation['donationType'] ?? 'No type';
                final donationValue = donation['donationValue'] ?? '0';
                final photoURL = donation['photoURL'] ?? '';

                return ListTile(
                  title: Text(fullName),
                  subtitle: Text(
                      'Donation Type: $donationType\nValue: $donationValue'),
                  trailing: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        isDarkMode ? Colors.grey : Colors.blue,
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        isDarkMode
                            ? Colors.white
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationViwer(
                            fullName: fullName,
                            donationType: donationType,
                            donationValue: donationValue,
                            photoURL: photoURL,
                          ),
                        ),
                      );
                    },
                    child: const Text('View Details'),
                  ),
                );
              },
            ),
    );
  }
}
