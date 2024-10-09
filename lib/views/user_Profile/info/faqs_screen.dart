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
    final Color appBarColor = isDarkMode ? Colors.blueAccent : Colors.blue;
    final Color backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final Color titleColor = isDarkMode ? Colors.white : Colors.black;
    final Color bodyTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQs',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Perguntas Frequentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: Text(
                'Qual é o horário dos cultos?',
                style: TextStyle(color: titleColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Os cultos ocorrem aos domingos às 10h e às quartas-feiras às 19h.',
                    style: TextStyle(color: bodyTextColor),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Como posso me envolver com os grupos de estudo?',
                style: TextStyle(color: titleColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Você pode se inscrever nos grupos de estudo através do nosso site ou entrando em contato com o escritório da igreja.',
                    style: TextStyle(color: bodyTextColor),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Onde posso encontrar informações sobre eventos?',
                style: TextStyle(color: titleColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'As informações sobre eventos estão disponíveis no nosso site e no mural de avisos da igreja.',
                    style: TextStyle(color: bodyTextColor),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Como posso fazer uma doação?',
                style: TextStyle(color: titleColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Você pode fazer uma doação através do nosso site ou diretamente na igreja durante os horários de culto.',
                    style: TextStyle(color: bodyTextColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Como Ajudar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                'Organize uma campanha',
                style: TextStyle(color: titleColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Você pode ajudar-nos promovendo a sua própria campanha, desde um simples jantar solidário a um evento de maior escala.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Defina o seu evento:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'Um jantar, um concerto solidário, uma live nas redes sociais… Você decide qual o evento mais conveniente para si.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Nós colaboramos:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'Nós podemos disponibilizar informação oficial, conteúdos, videos, imagens e design para o seu evento.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Faça a doação:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'Após a arrecadação, escolha a forma de doar que você prefere. Com a sua campanha, poderemos certamente alcançar muitas mais crianças e famílias.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Apadrinhe uma criança ou família',
                style: TextStyle(color: titleColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apadrinhar uma criança:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'Escolha e Comprometimento: O interessado em apadrinhar escolhe uma criança da nossa lista de beneficiados. Com esse ato, assume o compromisso de fazer uma doação mensal, com o valor que definir, para apoiar diretamente o bem-estar e desenvolvimento da criança apadrinhada.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Acesso a Informações Privilegiadas:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'O padrinho ou madrinha tem acesso exclusivo a atualizações sobre os avanços e conquistas da criança. Isso inclui relatórios escolares, atividades realizadas e outros marcos importantes no seu desenvolvimento.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Conexão Direta:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'Através da nossa plataforma segura, o padrinho ou madrinha tem a oportunidade de estabelecer uma conexão mais pessoal com a criança, ou seus pais. Periodicamente, organizamos sessões de vídeo, onde é possível interagir, conhecer melhor a realidade da criança e fortalecer os laços de afeto e cuidado.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Transparência:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'Garantimos total transparência relativamente ao uso das doações. Todos os recursos destinados ao apadrinhamento são aplicados diretamente no apoio à criança e a sua comunidade, fomentando a educação, saúde e bem-estar.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Desenvolvimento Comunitário:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'Além de beneficiar a criança apadrinhada, parte das doações é destinada a projetos de desenvolvimento da comunidade, garantindo um impacto mais amplo e sustentável.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Apadrinhar uma família:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'Escolha e Comprometimento: O interessado em apadrinhar opta por uma família da nossa lista de beneficiados. Ao fazer isso, assume o compromisso de realizar uma doação mensal, com o valor que definir, para apoiar diretamente o bem-estar e desenvolvimento dessa família.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Acesso a Informações Privilegiadas:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'O padrinho ou madrinha tem acesso exclusivo a atualizações sobre os progressos e desafios enfrentados pela família. Isso inclui conquistas, projetos familiares, atividades desenvolvidas e outros aspetos relevantes da vida quotidiana.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Conexão Direta:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'Através da nossa plataforma segura, o padrinho ou madrinha tem a oportunidade de estabelecer um vínculo mais pessoal com a família apadrinhada. Periodicamente, organizamos sessões de vídeo, permitindo uma interação mais próxima, compreensão da realidade vivida e fortalecimento dos laços de solidariedade.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Transparência:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'O nosso compromisso é com a total clareza no uso das doações. Todos os recursos direcionados ao apadrinhamento são empregados diretamente no suporte à família e à comunidade, assegurando a sua saúde, educação e bem-estar.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Desenvolvimento Comunitário:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      Text(
                        'As doações também contribuem para projetos mais amplos de desenvolvimento comunitário. Isso significa que, ao apoiar uma família, também impacta positivamente a comunidade na qual ela está inserida, promovendo um ambiente mais sustentável e harmonioso.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Faça voluntariado',
                style: TextStyle(color: titleColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Impacto Direto:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'Você terá a chance de trabalhar diretamente com as crianças, famílias e comunidades que beneficiamos, sendo uma peça fundamental em sua jornada de desenvolvimento e superação.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Desenvolvimento Pessoal:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'O voluntariado proporciona uma oportunidade única de crescimento. Você aprenderá novas habilidades, enfrentará desafios e, acima de tudo, descobrirá a satisfação inigualável de servir ao próximo.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Conexões Valiosas:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'Ao se juntar à nossa equipe, você se conectará com outros voluntários de diversos backgrounds, criando laços de amizade e colaboração que podem durar a vida toda.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Experiência Enriquecedora:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'Através das atividades voluntárias, você terá uma perspectiva mais profunda sobre as realidades e culturas das comunidades que servimos, enriquecendo sua visão de mundo e compreensão sobre as diversas nuances da humanidade.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Faça uma doação única',
                style: TextStyle(color: titleColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cria Impacto Imediato:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'A sua contribuição é rapidamente direcionada para áreas de necessidade urgente, seja alimentando uma criança, apoiando a educação, ou financiando um projeto comunitário específico.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Deixa uma Marca:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'Mesmo uma única doação pode ser o catalisador para uma mudança duradoura. A sua generosidade pode ser a diferença entre esperança e desespero para uma família ou comunidade.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Desfruta de Flexibilidade:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'Com a doação única, tem a liberdade de contribuir conforme a sua capacidade e conveniência, sem o compromisso de doações futuras.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Recebe Atualizações:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'Embora a sua doação seja única, mantemos você informado sobre como a sua contribuição faz a diferença, reforçando o valor e impacto do seu gesto.',
                        style: TextStyle(color: bodyTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Não encontrou a resposta para sua pergunta?',
              style: TextStyle(
                fontSize: 18,
                color: titleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                'Entre em contato conosco',
                style: TextStyle(color: titleColor),
              ),
              leading: Icon(
                Icons.contact_mail,
                color: appBarColor,
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
      path: 'info@resplandecendonacoes.org',
      queryParameters: {'subject': 'Dúvidas sobre o aplicativo'},
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Não foi possível abrir o cliente de e-mail';
    }
  }
}
