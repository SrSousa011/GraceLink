import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/donations/upload_photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String tSumupLogo = 'assets/icons/sumup.png';
const String tDigiCashLogo = 'assets/icons/digicash.jpg';

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
  bool paymentClicked = false;

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

  Future<void> _launchSumupURL() async {
    const url = 'https://pay.sumup.com/b2c/QV9E8TAZ';
    try {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
      setState(() {
        paymentClicked = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _launchDigiCashURL() async {
    const url = 'https://www.digicash.lu';
    try {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes da doação',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
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
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Doação para: ${widget.donationType}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Valor: ${widget.donationValue.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Método de pagamento',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: _launchSumupURL,
                    child: Image.asset(
                      tSumupLogo,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  GestureDetector(
                    onTap: _launchDigiCashURL,
                    child: Image.asset(
                      tDigiCashLogo,
                      width: 130,
                      height: 130,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Text('Após pagamento enviar comprovante'),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: paymentClicked ? _navigateAndUploadPhoto : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: paymentClicked
                      ? (isDarkMode ? const Color(0xFF333333) : Colors.blue)
                      : Colors.grey,
                  shape: const StadiumBorder(),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Comprovante'),
              ),
              if (uploadStatus == 'success') ...[
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
                  child: const Text('Confirmar Doação'),
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
