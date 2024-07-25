import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para links externos

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
      ),
      body: Container(
        color: Colors.black, // Fundo escuro para melhor contraste
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: const Text(
                'Update History',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navegar para o histórico de atualizações se necessário
              },
            ),
            ListTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _launchURL('https://example.com/privacy-policy');
              },
            ),
            ListTile(
              title: const Text(
                'Terms of Service',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _launchURL('https://example.com/terms-of-service');
              },
            ),
            ListTile(
              title: const Text(
                'Contact Support',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _launchEmail();
              },
            ),
            ListTile(
              title: const Text(
                'FAQs',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navegar para FAQs se necessário
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'About Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Welcome to our app. We are committed to providing you with the best experience. For more information, please visit our website or contact us.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const ListTile(
              title: Text(
                '281 Route de Thionville, Hesperange, Luxembourg',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.location_on, color: Colors.white),
            ),
            ListTile(
              title: const Text(
                'info@resplandecendonacoes.org',
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(Icons.email, color: Colors.white),
              onTap: () {
                _launchEmail();
              },
            ),
            ListTile(
              title: const Text(
                '+352 691 240 908',
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(Icons.phone, color: Colors.white),
              onTap: () {
                _launchPhone();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Last updated: July 2024',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              '© 2024 Your Company. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@resplandecendonacoes.org',
      queryParameters: {'subject': 'Support Request'},
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email client';
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+352691240908',
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch phone dialer';
    }
  }
}
