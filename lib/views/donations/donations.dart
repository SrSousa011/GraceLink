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
  String selectedPayment = 'Paypal';
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DonationValue(
              donationController: donationController,
            ),
            const SizedBox(height: 20.0),
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
            // Usando o DonateButton
            DonateButton(
              onPressed: () {
                // Implemente sua lógica de doação aqui
              },
              text: 'Doar agora',
            ),
          ],
        ),
      ),
    );
  }
}
