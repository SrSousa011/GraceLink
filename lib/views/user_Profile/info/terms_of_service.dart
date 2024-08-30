import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Serviço'),
      ),
      body: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Termos de Serviço',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Data de Vigência: Julho de 2024',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Aceitação dos Termos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ao acessar ou usar nosso aplicativo, você concorda em cumprir e estar vinculado a estes Termos de Serviço. Se você não concordar com estes termos, por favor, não use o aplicativo.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Responsabilidades do Usuário',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Você concorda em usar o aplicativo apenas para fins legais e de acordo com estes Termos de Serviço. Você é responsável por manter a confidencialidade da sua conta e por todas as atividades que ocorram sob sua conta.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Atividades Proibidas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Você não pode usar o aplicativo para se envolver em qualquer atividade ilegal ou para transmitir qualquer conteúdo que seja prejudicial, ofensivo ou de alguma forma questionável. Você não pode tentar obter acesso não autorizado a qualquer parte do aplicativo ou de seus sistemas.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Limitação de Responsabilidade',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Na medida permitida por lei, não seremos responsáveis por quaisquer danos indiretos, incidentais, especiais ou consequenciais que surjam de ou em conexão com o uso do aplicativo.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Alterações aos Termos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Podemos atualizar estes Termos de Serviço de tempos em tempos. Notificaremos você sobre quaisquer alterações publicando os novos Termos de Serviço nesta página. Recomendamos que você revise estes Termos periodicamente para verificar quaisquer mudanças.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Entre em Contato Conosco',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Se você tiver alguma dúvida sobre estes Termos de Serviço, por favor, entre em contato conosco pelo e-mail: info@churchapp.org',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
