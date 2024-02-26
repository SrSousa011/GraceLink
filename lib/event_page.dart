import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: EventPage(),
  ));
}

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Event> events = [
    Event(
      title: 'Culto de Domingo',
      description:
          'Participe do nosso culto dominical com louvor, adoração e uma mensagem inspiradora.',
      date:
          DateTime(2024, 3, 1, 10, 0), // Domingo, 1º de março de 2024, às 10h00
      location: 'Igreja da Comunidade',
    ),
    Event(
      title: 'Grupo de Estudo Bíblico',
      description:
          'Venha participar do nosso grupo de estudo bíblico semanal para aprender mais sobre a Palavra de Deus.',
      date: DateTime(
          2024, 3, 4, 19, 0), // Quarta-feira, 4 de março de 2024, às 19h00
      location: 'Salão da Igreja',
    ),
    Event(
      title: 'Concerto de Natal',
      description:
          'Celebre a época festiva com músicas de Natal apresentadas pelo coro da igreja.',
      date: DateTime(2024, 12, 20, 18,
          30), // Sexta-feira, 20 de dezembro de 2024, às 18h30
      location: 'Igreja da Comunidade',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddEventScreen(context);
        },
        tooltip: 'Novo Evento',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddEventScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventScreen()),
    );
    if (result != null) {
      setState(() {
        events.add(result);
      });
    }
  }

  void _navigateToEventDetailsScreen(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
    );
  }
}

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título do Evento'),
            ),
            TextField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Descrição do Evento'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveEvent(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEvent(BuildContext context) {
    final newEvent = Event(
      title: _titleController.text,
      description: _descriptionController.text,
      date: DateTime.now(), // Change this to the selected date
      location: 'Local do Evento', // Change this to the selected location
    );
    Navigator.pop(context, newEvent);
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
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
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
            const SizedBox(height: 8),
            Text(
              'Data: ${_formatDate(date)}',
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

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
              'Data: ${_formatDate(event.date)}',
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
