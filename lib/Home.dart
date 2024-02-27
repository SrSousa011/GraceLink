import 'package:flutter/material.dart';
import 'MenuDrawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/logo.png',
              fit: BoxFit.contain,
              height: 70,
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
      drawer: const NavBar(),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EventCard(
              title: 'Culto de Domingo',
              description:
                  'Participe do culto de domingo para um momento de louvor, adoração e ensino da palavra de Deus.',
            ),
            EventCard(
              title: 'Grupo de Estudo Bíblico',
              description:
                  'Junte-se ao nosso grupo de estudo bíblico para uma análise profunda das Escrituras.',
            ),
            EventCard(
              title: 'Festa de Boas-Vindas',
              description:
                  'Conheça novos membros da comunidade em nossa festa de boas-vindas toda quarta-feira.',
            ),
            EventCard(
              title: 'Ação Social',
              description:
                  'Participe de nossa ação social neste sábado para ajudar os necessitados em nossa comunidade.',
            ),
            EventCard(
              title: 'Noite de Louvor',
              description:
                  'Desfrute de uma noite de louvor e adoração com músicas inspiradoras e mensagens edificantes.',
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;

  const EventCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
