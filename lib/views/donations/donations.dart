import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/donations/donation_type.dart';
import 'package:churchapp/views/donations/donation_value.dart';
import 'package:churchapp/views/donations/donnation_detail.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Donations extends StatefulWidget {
  const Donations({super.key, this.donationType});
  final String? donationType;

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  late TextEditingController donationController;
  String donationType = '';

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

  void navigateToDonationDetailsScreen(BuildContext context) async {
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
      try {
        String? fullName = await AuthenticationService().getCurrentUserName();

        if (fullName != null && fullName.isNotEmpty) {
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonationDetails(
                donationType: donationType,
                donationValue: donationController.text,
                fullName: fullName,
                isbn: '978-3-16-148410-0',
                bankName: 'Bank of Luxembourg',
              ),
            ),
          );
        } else {
          if (!context.mounted) return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Failed to get user full name.'),
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
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching user full name: $e');
        }
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to get user full name.'),
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor = theme.brightness == Brightness.light
        ? const Color(0xFF007BFF) // Azul no modo claro
        : Colors.grey; // Cinza no modo escuro

    final Color donationTypeButtonColor =
        theme.brightness == Brightness.light ? Colors.white : Colors.grey[800]!;

    final Color donationTypeTextColor = theme.brightness == Brightness.light
        ? const Color(0xFF007BFF) // Azul no modo claro
        : Colors.white; // Branco no modo escuro

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
                onValueChanged: (value) {},
              ),
              DonationType(
                onTypeSelected: onTypeSelected,
                donationType: donationType,
                donationTypeButtonColor: donationTypeButtonColor,
                donationTypeTextColor: donationTypeTextColor,
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    navigateToDonationDetailsScreen(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: buttonColor,
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
