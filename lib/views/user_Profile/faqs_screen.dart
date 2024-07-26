import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFAQTile(
            'What is this app about?',
            'This app provides users with the ability to manage their profiles, update their information, and more.',
          ),
          _buildFAQTile(
            'How do I reset my password?',
            'You can reset your password by going to the settings page and selecting "Change Password". Follow the prompts to reset it.',
          ),
          _buildFAQTile(
            'Who can I contact for support?',
            'For support, you can email us at info@resplandecendonacoes.org or call +352 691 240 908.',
          ),
          _buildFAQTile(
            'Where can I find the privacy policy?',
            'You can find our privacy policy on our website at https://example.com/privacy-policy.',
          ),
          _buildFAQTile(
            'How can I update my phone number?',
            'To update your phone number, go to the settings page, select "Change Phone", and follow the instructions.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(color: Colors.white),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            answer,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}
