import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final VoidCallback onAccept;

  const TermsAndConditionsScreen({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final Color primaryColor =
        isDarkMode ? Colors.blueGrey[700]! : Colors.blueAccent;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos e Condições'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle(
                'Termos e Condições de Membro da Igreja', theme, textColor),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                        '1. Compromisso da Igreja',
                        'A Igreja se compromete a proporcionar um ambiente de fé e comunhão, promovendo o crescimento espiritual e a participação ativa em atividades e eventos comunitários. Nossos líderes são dedicados ao apoio espiritual e à orientação dos membros, garantindo um espaço seguro e acolhedor para todos.',
                        theme,
                        textColor),
                    _buildSection(
                        '2. Participação Ativa',
                        'O membro deve participar ativamente das atividades da Igreja, incluindo cultos, eventos e grupos de estudo. A participação ativa é crucial para fortalecer a comunidade e contribuir para o crescimento espiritual e pessoal. Espera-se que os membros estejam engajados nas práticas da Igreja e auxiliem em suas iniciativas.',
                        theme,
                        textColor),
                    _buildSection(
                        '3. Contribuição Financeira',
                        'Os membros são incentivados a contribuir financeiramente para apoiar a manutenção das atividades da Igreja e financiar projetos comunitários. As contribuições são voluntárias, e cada membro deve doar conforme suas possibilidades. A Igreja assegura que os fundos serão utilizados de maneira transparente e em conformidade com os objetivos da instituição.',
                        theme,
                        textColor),
                    _buildSection(
                        '4. Respeito às Diretrizes e Normas',
                        'Os membros devem respeitar as diretrizes e normas estabelecidas pela Igreja, que visam garantir a convivência harmoniosa e o respeito mútuo. Qualquer comportamento que vá contra os princípios da Igreja pode resultar em medidas corretivas, que incluem advertências ou até mesmo a suspensão da associação, se necessário.',
                        theme,
                        textColor),
                    _buildSection(
                        '5. Proteção de Dados Pessoais',
                        'A Igreja compromete-se a proteger a privacidade dos seus membros e a tratar seus dados pessoais com a máxima confidencialidade e segurança. Os dados coletados serão utilizados exclusivamente para fins administrativos e de comunicação relacionados à Igreja e não serão compartilhados com terceiros sem o consentimento do membro.',
                        theme,
                        textColor),
                    _buildSection(
                        '6. Cancelamento de Associação',
                        'Os membros têm o direito de cancelar sua associação a qualquer momento, notificando a Igreja por escrito. O processo de cancelamento será realizado de forma respeitosa e eficiente. Qualquer contribuição realizada antes do cancelamento não será reembolsada, e o membro terá acesso aos serviços da Igreja até a conclusão do processo.',
                        theme,
                        textColor),
                    _buildSection(
                        '7. Alterações nos Termos e Condições',
                        'A Igreja se reserva o direito de alterar estes termos e condições a qualquer momento. As alterações serão comunicadas aos membros através de canais oficiais, e a continuidade da associação após a atualização implicará na aceitação das novas condições. É responsabilidade dos membros revisar regularmente os termos atualizados.',
                        theme,
                        textColor),
                    _buildSection(
                        '8. Responsabilidade pelo Comportamento',
                        'Os membros são responsáveis por seu comportamento dentro e fora das atividades da Igreja, especialmente em eventos e encontros organizados. Espera-se que todos os membros ajam de forma ética e respeitosa, refletindo os valores da Igreja em todas as suas interações.',
                        theme,
                        textColor),
                    _buildSection(
                        '9. Inclusão e Diversidade',
                        'A Igreja promove a inclusão e a diversidade, acolhendo pessoas de todas as origens, culturas e perspectivas. Todos os membros devem contribuir para um ambiente inclusivo, onde cada indivíduo seja tratado com dignidade e respeito, independentemente de suas diferenças.',
                        theme,
                        textColor),
                    _buildSection(
                        '10. Resolução de Conflitos',
                        'Em caso de conflitos ou desentendimentos entre membros ou entre membros e a Igreja, a resolução será buscada através do diálogo e da mediação. A Igreja está comprometida em resolver disputas de maneira justa e equilibrada, sempre buscando a reconciliação e a restauração da harmonia.',
                        theme,
                        textColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onAccept();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              child: Text(
                'Aceitar e Confirmar',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, ThemeData theme, Color textColor) {
    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildSection(
      String title, String content, ThemeData theme, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
