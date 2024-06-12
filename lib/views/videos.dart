// lib/views/videos.dart

import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});
  final bool canReturn = false;

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final TextEditingController _urlController = TextEditingController();

  Future<void> _launchURL() async {
    final url = Uri.parse(_urlController.text);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar('Não foi possível abrir este link.');
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vídeos'),
        ),
        drawer: NavBar(
          auth: AuthenticationService(),
          authService: AuthenticationService(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Insira o link do YouTube',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _launchURL,
                child: const Text('Abrir no YouTube'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
