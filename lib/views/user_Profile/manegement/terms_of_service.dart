import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Terms of Service',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Effective Date: July 2024',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 20),
            Text(
              'Acceptance of Terms',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'By accessing or using our application, you agree to comply with and be bound by these Terms of Service. If you do not agree to these terms, please do not use the application.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            Text(
              'User Responsibilities',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'You agree to use the application only for lawful purposes and in accordance with these Terms of Service. You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            Text(
              'Prohibited Activities',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'You may not use the application to engage in any unlawful activity or to transmit any content that is harmful, offensive, or otherwise objectionable. You may not attempt to gain unauthorized access to any part of the application or its systems.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            Text(
              'Limitation of Liability',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'To the extent permitted by law, we shall not be liable for any indirect, incidental, special, or consequential damages arising out of or in connection with your use of the application.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            Text(
              'Changes to Terms',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'We may update these Terms of Service from time to time. We will notify you of any changes by posting the new Terms of Service on this page. You are advised to review these Terms periodically for any changes.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'If you have any questions about these Terms of Service, please contact us at: info@churchapp.org',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
