import 'dart:async';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/donations/upload_photo.dart';
import 'package:provider/provider.dart';

class DonationDetails extends StatefulWidget {
  final String fullName;
  final String donationType;
  final double donationValue;

  const DonationDetails({
    super.key,
    required this.fullName,
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
        'donationValue': widget.donationValue, // Store as double
        'photoURL': uploadedFileURL,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doação realizada com sucesso'),
          ),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha ao tentar realizar a doação: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da doação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Nome: ${widget.fullName}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              const SelectableText(
                'ISBN: 978-3-16-148410-0',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Nome do banco: Banque et Caisse d\'Épargne de l\'État',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Doação para: ${widget.donationType}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Valor: ${widget.donationValue.toStringAsFixed(2)}', // Format double
                style: const TextStyle(fontSize: 18.0),
              ),
              const Text('Copie o número ISBN e pague fora do aplicativo.'),
              const SizedBox(height: 30.0),
              if (uploadStatus == null) ...[
                ElevatedButton(
                  onPressed: _navigateAndUploadPhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? const Color(0xFF333333) : Colors.blue,
                    shape: const StadiumBorder(),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Comprovante'),
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
