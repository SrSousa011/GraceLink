import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'upload_photo.dart';

class DonationDetailsScreen extends StatefulWidget {
  final String fullName;
  final String isbn;
  final String bankName;
  final String donationType;
  final String donationValue;

  const DonationDetailsScreen({
    Key? key,
    required this.fullName,
    required this.isbn,
    required this.bankName,
    required this.donationType,
    required this.donationValue,
  }) : super(key: key);

  @override
  State<DonationDetailsScreen> createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen> {
  String? uploadStatus;
  String? uploadedFileURL;

  void _navigateAndUploadPhoto() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StoragePage(),
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
        'fullName': widget.fullName,
        'donationType': widget.donationType,
        'donationValue': widget.donationValue,
        'photoURL': uploadedFileURL,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donation successfully completed'),
        ),
      );

      // Limpar o estado da imagem carregada ao navegar para trás
      setState(() {
        uploadStatus = null;
        uploadedFileURL = null;
      });

      // Opcionalmente, navegar para outra tela ou redefinir o formulário

      // Exemplo de navegação para a tela anterior
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to complete donation: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Limpar o estado da imagem carregada ao navegar para trás
        setState(() {
          uploadStatus = null;
          uploadedFileURL = null;
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Donation Details'),
        ),
        body: SingleChildScrollView(
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
                  'Copy the ISB number and pay outside of the application.'),
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
