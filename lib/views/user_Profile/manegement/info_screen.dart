import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:churchapp/views/about_us.dart';
import 'package:churchapp/views/user_Profile/manegement/faqs_screen.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
      ),
      body: Container(
        color: isDarkMode
            ? Colors.grey[900]
            : Colors.white, // Set background color based on theme
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: Text(
                'Privacy Policy',
                style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black), // Text color based on theme
              ),
              onTap: () {
                _launchURL('https://example.com/privacy-policy');
              },
            ),
            ListTile(
              title: Text(
                'Terms of Service',
                style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black), // Text color based on theme
              ),
              onTap: () {
                _launchURL('https://example.com/terms-of-service');
              },
            ),
            ListTile(
              title: Text(
                'Contact Support',
                style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black), // Text color based on theme
              ),
              onTap: () {
                _launchEmail();
              },
            ),
            ListTile(
              title: Text(
                'FAQs',
                style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black), // Text color based on theme
              ),
              onTap: () {
                Get.to(() => const FAQScreen());
              },
            ),
            ListTile(
              title: Text(
                'About Us',
                style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black), // Text color based on theme
              ),
              onTap: () {
                Get.to(() => const AboutUs());
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? Colors.white
                    : Colors.black, // Text color based on theme
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                '281 Route de Thionville, Hesperange, Luxembourg',
                style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black), // Text color based on theme
              ),
              leading: Icon(Icons.location_on,
                  color: isDarkMode
                      ? Colors.white
                      : Colors.black), // Icon color based on theme
            ),
            ListTile(
              title: Text(
                'info@resplandecendonacoes.org',
                style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black), // Text color based on theme
              ),
              leading: Icon(Icons.email,
                  color: isDarkMode
                      ? Colors.white
                      : Colors.black), // Icon color based on theme
              onTap: () {
                _launchEmail();
              },
            ),
            ListTile(
              title: Text(
                '+352 691 240 908',
                style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black), // Text color based on theme
              ),
              leading: Icon(Icons.phone,
                  color: isDarkMode
                      ? Colors.white
                      : Colors.black), // Icon color based on theme
              onTap: () {
                _launchPhone();
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Last updated: July 2024',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isDarkMode
                      ? Colors.grey
                      : Colors.grey[800]), // Text color based on theme
            ),
            const SizedBox(height: 10),
            Text(
              '© 2024 Your Company. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isDarkMode
                      ? Colors.grey
                      : Colors.grey[800]), // Text color based on theme
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
