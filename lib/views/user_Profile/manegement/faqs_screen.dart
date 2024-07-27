import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        backgroundColor: isDarkMode ? Colors.blueGrey[900] : Colors.blue,
      ),
      body: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Perguntas Frequentes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: Text(
                'Qual é o horário dos cultos?',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Os cultos ocorrem aos domingos às 10h e às quartas-feiras às 19h.',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Como posso me envolver com os grupos de estudo?',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Você pode se inscrever nos grupos de estudo através do nosso site ou entrando em contato com o escritório da igreja.',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Onde posso encontrar informações sobre eventos?',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'As informações sobre eventos estão disponíveis no nosso site e no mural de avisos da igreja.',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Como posso fazer uma doação?',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Você pode fazer uma doação através do nosso site ou diretamente na igreja durante os horários de culto.',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Não encontrou a resposta para sua pergunta?',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                'Entre em contato conosco',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              leading: Icon(
                Icons.contact_mail,
                color: isDarkMode ? Colors.blueAccent : Colors.blue,
              ),
              onTap: () {
                _launchEmail();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@churchapp.org',
      queryParameters: {'subject': 'Dúvidas sobre o aplicativo'},
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Não foi possível abrir o cliente de e-mail';
    }
  }
}
