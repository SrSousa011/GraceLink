import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/donations/donnation_buttom.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/donations/donate_how.dart';
import 'package:churchapp/views/donations/donation_type.dart';
import 'package:churchapp/views/donations/donation_value.dart';
import 'package:churchapp/views/nav_bar.dart';

class Donations extends StatefulWidget {
  const Donations({super.key});

  @override
  State<Donations> createState() => _DonationPageState();
}

class _DonationPageState extends State<Donations> {
  String donationType = '';
  String selectedPayment = 'QR Code';
  late TextEditingController donationController;

  @override
  void initState() {
    super.initState();
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
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
      ),
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
              donationType: donationType,
            ),
            const SizedBox(height: 20.0),
            DonateButton(
              // Using the corrected DonationButton widget
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content:
                          const Text('You have successfully made a donation!'),
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
              text: 'Donate', // Specify the button text
            ),
          ],
        ),
      ),
    );
  }
}
