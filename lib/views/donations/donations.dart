import 'package:churchapp/views/donations/donnation_detail.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/donations/donation_type.dart';
import 'package:churchapp/views/donations/donation_value.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:churchapp/services/auth_service.dart';

class Donations extends StatefulWidget {
  const Donations({super.key});

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  String donationType = '';
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

  void onTypeSelected(String type) {
    setState(() {
      donationType = type;
    });
  }

  void navigateToDonationDetailsScreen(BuildContext context) {
    // Validate donation information
    if (donationType.isEmpty || donationController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Please select a donation type and enter a value.'),
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
    } else {
      // Navigate to donation details screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DonationDetailsScreen(
            donationType: donationType,
            donationValue: donationController.text,
            fullName: 'Sergio Ribas Camargo', // Example full name
            isbn: '978-3-16-148410-0', // Example ISBN
            bankName: 'Bank of Luxembourg', // Example bank name
          ),
        ),
      );
    }
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20.0),
              DonationValue(
                controller: donationController,
                donationController: donationController,
                onValueChanged: (value) {},
              ),
              DonationType(
                onTypeSelected: onTypeSelected,
                donationType: donationType,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  navigateToDonationDetailsScreen(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF5AAFf9),
                ),
                child: const Text(
                  'Next',
                  style:
                      TextStyle(fontSize: 20), // Increase font size if needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
