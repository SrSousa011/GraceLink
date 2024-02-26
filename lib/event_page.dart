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
      title: 'Evento 1',
      description: 'Descrição do evento 1',
    ),
    Event(
      title: 'Evento 2',
      description: 'Descrição do evento 2',
    ),
    Event(
      title: 'Evento 3',
      description: 'Descrição do evento 3',
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
          return EventCard(
            title: events[index].title,
            description: events[index].description,
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
              decoration: InputDecoration(labelText: 'Título do Evento'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição do Evento'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveEvent(context);
              },
              child: Text('Salvar'),
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
    );
    Navigator.pop(context, newEvent);
  }
}

class Event {
  final String title;
  final String description;

  Event({
    required this.title,
    required this.description,
  });
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
