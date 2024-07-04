import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.auth,
    required this.userId,
    required this.onSignedOut,
  });

  final BaseAuth auth;
  final String userId;
  final VoidCallback onSignedOut;
  final bool canReturn = false;

  void sigUerOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Event> events = [
    Event(
      title: 'Culto de Domingo',
      description:
          'Participe do nosso culto dominical com louvor, adoração e uma mensagem inspiradora.',
      date: DateTime(2024, 3, 1, 10, 0),
      location: 'Igreja da Comunidade',
    ),
    Event(
      title: 'Grupo de Estudo Bíblico',
      description:
          'Venha participar do nosso grupo de estudo bíblico semanal para aprender mais sobre a Palavra de Deus.',
      date: DateTime(2024, 3, 4, 19, 0),
      location: 'Salão da Igreja',
    ),
    Event(
      title: 'Concerto de Natal',
      description:
          'Celebre a época festiva com músicas de Natal apresentadas pelo coro da igreja.',
      date: DateTime(2024, 12, 20, 18, 30),
      location: 'Igreja da Comunidade',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        drawer: NavBar(
          auth: AuthenticationService(),
          authService: AuthenticationService(),
        ),
        body: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _navigateToEventDetailsScreen(context, events[index]);
              },
              child: EventCard(
                title: events[index].title,
                description: events[index].description,
                date: events[index].date,
                location: events[index].location,
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToEventDetailsScreen(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
    );
  }
}

class Event {
  final String title;
  final String description;
  final DateTime date;
  final String location;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
  });
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime date;
  final String location;

  const EventCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
  });

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
            const SizedBox(height: 8),
            Text(
              'Data: ${DateFormat('dd/MM/yyyy').format(date)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Horário: ${DateFormat('HH:mm').format(date)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Local: $location',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrição: ${event.description}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Data: ${DateFormat('dd/MM/yyyy').format(event.date)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Horário: ${DateFormat('HH:mm').format(event.date)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Local: ${event.location}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
