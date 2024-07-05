import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/donations/upload_photo.dart';

class DonationDetails extends StatefulWidget {
  final String fullName;
  final String isbn;
  final String bankName;
  final String donationType;
  final String donationValue;

  const DonationDetails({
    super.key,
    required this.fullName,
    required this.isbn,
    required this.bankName,
    required this.donationType,
    required this.donationValue,
  });

  @override
  State<DonationDetails> createState() => _DonationDetailsState();
}

class _DonationDetailsState extends State<DonationDetails> {
  String? uploadStatus;
  String? uploadedFileURL;

  void _navigateAndUploadPhoto() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoragePage(
          donationType: widget.donationType,
          donationValue: widget.donationValue,
          fullName: widget.fullName,
        ),
      ),
    );

    setState(() {
      if (result == 'error') {
        uploadStatus = result;
      } else {
        uploadedFileURL = result;
        uploadStatus = 'success';
      }
    });
  }

  Future<void> _confirmDonation() async {
    if (uploadedFileURL == null) return;

    try {
      await FirebaseFirestore.instance.collection('donations').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'fullName': widget.fullName,
        'donationType': widget.donationType,
        'donationValue': widget.donationValue,
        'photoURL': uploadedFileURL,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation successfully completed'),
          ),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete donation: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Full Name: ${widget.fullName}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              SelectableText(
                'ISBN: ${widget.isbn}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Bank Name: ${widget.bankName}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Donation Type: ${widget.donationType}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Donation Value: ${widget.donationValue}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const Text(
                  'Copy the ISBN number and pay outside of the application.'),
              const SizedBox(height: 30.0),
              if (uploadStatus == null) ...[
                ElevatedButton(
                  onPressed: _navigateAndUploadPhoto,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF5AAFf9),
                  ),
                  child: const Text('Upload Photo'),
                ),
              ] else if (uploadStatus == 'success') ...[
                const Text(
                  'Photo uploaded successfully!',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _confirmDonation,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF5AAFf9),
                  ),
                  child: const Text('Confirm Donation'),
                ),
              ] else if (uploadStatus == 'error') ...[
                const Text(
                  'Photo upload failed. Please try again.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _navigateAndUploadPhoto,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF5AAFf9),
                  ),
                  child: const Text('Retry Upload Photo'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
