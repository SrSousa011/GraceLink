import 'package:churchapp/views/user_Profile/manegement/about_us.dart';
import 'package:churchapp/views/user_Profile/manegement/faqs_screen.dart';
import 'package:churchapp/views/user_Profile/manegement/privacy_policy.dart';
import 'package:churchapp/views/user_Profile/manegement/terms_of_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: Text(
                'Política de Privacidade',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicy(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Termos de Serviço',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfService(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Contatar Suporte',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                _launchEmail();
              },
            ),
            ListTile(
              title: Text(
                'Perguntas Frequentes',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FAQScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Sobre Nós',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUs(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Entre em Contato',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                '281 Route de Thionville, Hesperange, Luxemburgo',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              leading: Icon(Icons.location_on,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
            ListTile(
              title: Text(
                'info@resplandecendonacoes.org',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              leading: Icon(Icons.email,
                  color: isDarkMode ? Colors.white : Colors.black),
              onTap: () {
                _launchEmail();
              },
            ),
            ListTile(
              title: Text(
                '+352 691 240 908',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              leading: Icon(Icons.phone,
                  color: isDarkMode ? Colors.white : Colors.black),
              onTap: () {
                _launchPhone();
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Última atualização: Julho de 2024',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: isDarkMode ? Colors.grey : Colors.grey[800]),
            ),
            const SizedBox(height: 10),
            Text(
              'Copyright © 2024 Resplandecendo Nações. Todos os direitos reservados.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: isDarkMode ? Colors.grey : Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@resplandecendonacoes.org',
      queryParameters: {'subject': 'Solicitação de Suporte'},
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Não foi possível abrir o cliente de e-mail';
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
      throw 'Não foi possível abrir o discador de telefone';
    }
  }
}
