import 'package:churchapp/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String tWhatsApp = 'assets/icons/WhatsApp.jpg';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  String? userName;

  final List<Map<String, String>> contacts = [
    {'name': 'Antonio Sousa', 'phoneNumber': '+352691240908'},
  ];

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

    final String message =
        'Olá, meu nome é $userName e estou entrando em contato através do aplicativo GraceLink. Gostaria de saber mais informações sobre [o assunto específico]. Agradeço desde já pela atenção!';
    final String nativeUrl =
        'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';
    final String webUrl = _createWhatsAppUrl(phoneNumber);

    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appBarColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'Entrar em Contato',
          style: TextStyle(
            color: iconColor,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: userName == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: contacts.map((contact) {
                  return ListTile(
                    leading: Image.asset(
                      tWhatsApp,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(
                      contact['name']!,
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () => _openWhatsApp(contact['phoneNumber']!),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
