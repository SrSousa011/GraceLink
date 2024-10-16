import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Política de Privacidade',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              'Data de Vigência: Julho de 2024',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Introdução',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Bem-vindo ao aplicativo móvel da nossa igreja. Sua privacidade é importante para nós. Esta Política de Privacidade explica como coletamos, usamos, divulgamos e protegemos suas informações quando você usa nosso aplicativo. Ao usar nosso aplicativo, você concorda com a coleta e uso de informações de acordo com esta política.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Coleta de Informações',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Podemos coletar informações pessoais que você nos fornece diretamente, como seu nome, endereço de e-mail e outros dados de contato. Também podemos coletar informações sobre o uso do aplicativo, incluindo suas interações e preferências.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Uso das Informações',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Usamos suas informações para melhorar nossos serviços, comunicar-nos com você e fornecer atualizações e ofertas relevantes. Não vendemos ou alugamos suas informações pessoais a terceiros.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Segurança dos Dados',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Implementamos medidas de segurança razoáveis para proteger suas informações pessoais contra acesso, uso ou divulgação não autorizados. No entanto, nenhum método de transmissão pela internet ou método de armazenamento eletrônico é 100% seguro.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Alterações a Esta Política',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Podemos atualizar nossa Política de Privacidade de tempos em tempos. Notificaremos você sobre quaisquer alterações publicando a nova Política de Privacidade nesta página. Recomendamos que você revise esta Política de Privacidade periodicamente para verificar quaisquer mudanças.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Entre em Contato Conosco',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Se você tiver alguma dúvida sobre esta Política de Privacidade, entre em contato conosco pelo e-mail: info@churchapp.org',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
