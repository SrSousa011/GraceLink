import 'donate_how.dart';
import 'package:flutter/material.dart';
import 'donation_value.dart';
import 'donation_type.dart';

void main() => runApp(const Donations());

class Donations extends StatelessWidget {
  const Donations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Donations',
      home: DonationPage(),
    );
  }
}

class DonationPage extends StatefulWidget {
  const DonationPage({Key? key}) : super(key: key);

  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  String donationType = '';
  String selectedPayment = 'Paypal';
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
            const SizedBox(height: 70.0),
            if (donationType.isNotEmpty) // Display selected donation type image
              Image.asset('assets/$donationType.png'),
          ],
        ),
      ),
    );
  }
}
