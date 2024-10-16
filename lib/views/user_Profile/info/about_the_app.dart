import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String tLinkedin = 'assets/icons/whatsapp.png';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchLinkedIn() async {
    const nativeUrl = "https://www.linkedin.com/in/lucas-sousa99";
    const webUrl = "https://www.linkedin.com/in/lucas-sousa99";

    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre o Aplicativo',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'O aplicativo "Resplandecendo as Nações" foi criado para apoiar a comunidade da igreja e ajudar aqueles em situação de vulnerabilidade.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nosso objetivo é fornecer uma plataforma que facilite a comunicação e o engajamento entre os membros da igreja, permitindo que todos fiquem informados sobre eventos, atividades e notícias.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Este aplicativo foi desenvolvido com o intuito de criar um espaço onde as vozes da comunidade possam ser ouvidas, promovendo a solidariedade e a união entre os membros. Acreditamos que, juntos, podemos fazer a diferença na vida de muitas pessoas e contribuir para um futuro mais iluminado.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Criado por Lucas Sousa',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _launchLinkedIn,
                    child: Image.asset(
                      tLinkedin,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
