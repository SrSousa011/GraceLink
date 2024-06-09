import 'package:flutter/material.dart';
import 'package:churchapp/views/donations/upload_photo.dart';

class DonationDetailsScreen extends StatelessWidget {
  final String fullName;
  final String isbn;
  final String bankName;
  final String donationType;
  final String donationValue;

  const DonationDetailsScreen({
    super.key,
    required this.fullName,
    required this.isbn,
    required this.bankName,
    required this.donationType,
    required this.donationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Full Name: $fullName',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            SelectableText(
              'ISBN: $isbn',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Bank Name: $bankName',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Donation Type: $donationType',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Donation Value: $donationValue',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to upload photo screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPhotoScreen(),
                  ),
                );
              },
              child: const Text('Upload Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
