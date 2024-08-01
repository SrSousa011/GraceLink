import 'package:flutter/material.dart';

class DonationViwer extends StatelessWidget {
  final String fullName;
  final String donationType;
  final String donationValue;
  final String photoURL;

  const DonationViwer({
    super.key,
    required this.fullName,
    required this.donationType,
    required this.donationValue,
    required this.photoURL,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donationtior Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Full Name: $fullName',
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
              if (photoURL.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullScreenImage(imageUrl: photoURL),
                      ),
                    );
                  },
                  child: Image.network(
                    photoURL,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              if (photoURL.isEmpty) const Text('No image available.'),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Image'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
