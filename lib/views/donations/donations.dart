import 'package:churchapp/views/donations/donate_how.dart';
import 'package:churchapp/views/donations/donation_type.dart';
import 'package:churchapp/views/donations/donation_value.dart';
import 'package:churchapp/views/donations/donnation_buttom.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/material.dart';

class Donations extends StatefulWidget {
  const Donations({Key? key}) : super(key: key);

  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<Donations> {
  String donationType = '';
  String selectedPayment = 'QR Code';
  late TextEditingController donationController;

  _DonationPageState() {
    donationController = TextEditingController();
  }

  @override
  void dispose() {
    donationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations'),
      ),
      drawer: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DonationValue(
              donationController: donationController,
            ),
            DonationHow(
              selectedPayment: selectedPayment,
              onPaymentSelected: (payment) {
                setState(() {
                  selectedPayment = payment ?? selectedPayment;
                });
              },
              onTypeSelected: (type) {
                setState(() {
                  donationType = type ?? donationType;
                });
              },
            ),
            DonationType(
              onTypeSelected: (type) {
                setState(() {
                  donationType = type;
                });
              },
              donationType: '',
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity, // Para ocupar toda a largura disponível
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text(
                            'You have successfully made a donation!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Donation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
