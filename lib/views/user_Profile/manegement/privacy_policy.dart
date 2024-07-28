import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Privacy Policy',
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
              'Introduction',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Welcome to our church\'s mobile application. Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application. By using our app, you agree to the collection and use of information in accordance with this policy.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            Text(
              'Information Collection',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'We may collect personal information that you provide to us directly, such as your name, email address, and other contact details. We may also collect information about your use of the application, including your interactions and preferences.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            Text(
              'Use of Information',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'We use your information to improve our services, communicate with you, and provide you with relevant updates and offers. We do not sell or rent your personal information to third parties.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            Text(
              'Data Security',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'We implement reasonable security measures to protect your personal information from unauthorized access, use, or disclosure. However, no method of transmission over the internet or method of electronic storage is 100% secure.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            Text(
              'Changes to This Policy',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.',
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
              'If you have any questions about this Privacy Policy, please contact us at: info@churchapp.org',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
