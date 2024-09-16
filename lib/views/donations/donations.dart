import 'package:churchapp/views/donations/donnation_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/views/donations/donation_type.dart';
import 'package:churchapp/views/donations/donation_value.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';

class Donations extends StatefulWidget {
  const Donations({super.key, this.donationType});
  final String? donationType;

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  double donationValue = 0.0;
  String donationType = '';

  void onTypeSelected(String type) {
    setState(() {
      donationType = type;
    });
  }

  void showErrorDialog(BuildContext context, String title, String content) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color errorIconColor = isDarkMode ? Colors.grey : Colors.red;
    final Color dialogTextColor = isDarkMode ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.error, color: errorIconColor),
              const SizedBox(width: 8.0),
              Text(title, style: TextStyle(color: dialogTextColor)),
            ],
          ),
          content: Text(
            content,
            style: TextStyle(color: dialogTextColor),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: dialogTextColor)),
            ),
          ],
        );
      },
    );
  }

  void navigateToDonationDetailsScreen(BuildContext context) async {
    if (donationType.isEmpty || donationValue <= 0) {
      showErrorDialog(
        context,
        'Error',
        'Selecione um tipo de doação e insira um valor válido.',
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
                donationValue: donationValue,
                fullName: fullName,
              ),
            ),
          );
        } else {
          showErrorDialog(
            context,
            'Error',
            'Failed to get user full name.',
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching user full name: $e');
        }
        showErrorDialog(
          context,
          'Error',
          'Failed to get user full name.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor = theme.brightness == Brightness.light
        ? const Color(0xFF007BFF)
        : Colors.grey;
    final Color donationTypeButtonColor =
        theme.brightness == Brightness.light ? Colors.white : Colors.grey[800]!;

    final Color donationTypeTextColor = theme.brightness == Brightness.light
        ? const Color(0xFF007BFF)
        : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doações'),
      ),
      drawer: const NavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20.0),
              DonationValue(
                onValueChanged: (value) {
                  setState(() {
                    donationValue = value;
                  });
                },
                value: donationValue,
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
                  child: const Text('Próximo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
