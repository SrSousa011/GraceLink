import 'package:churchapp/views/user_Profile/info/about_us.dart';
import 'package:churchapp/views/user_Profile/info/faqs_screen.dart';
import 'package:churchapp/views/user_Profile/info/privacy_policy.dart';
import 'package:churchapp/views/user_Profile/info/terms_of_service.dart';
import 'package:churchapp/views/user_Profile/info/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final authService = AuthenticationService();
    String? currentUserName = await authService.getCurrentUserName();
    setState(() {
      userName = currentUserName;
    });
  }

  String _createWhatsAppUrl(String phoneNumber) {
    final String message =
        'Olá, meu nome é $userName e estou entrando em contato através do aplicativo GraceLink. Gostaria de saber mais informações sobre [o assunto específico]. Agradeço desde já pela atenção!';
    final Uri uri = Uri.parse('https://wa.me/$phoneNumber')
        .replace(queryParameters: {'text': message});
    return uri.toString();
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    if (userName == null) return;

    final nativeUrl =
        'whatsapp://send?phone=$phoneNumber&text=Olá, meu nome é $userName e estou entrando em contato através do aplicativo GraceLink. Gostaria de saber mais informações sobre [o assunto específico]. Agradeço desde já pela atenção!';
    final webUrl = _createWhatsAppUrl(phoneNumber);

    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informações',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactScreen(),
                  ),
                );
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
                'Endereço:\nRBM Rue de Rodange 67B, 6791 Aubange, Bélgica',
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
              onTap: _launchEmail,
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
                _openWhatsApp('+352691240908');
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
}
