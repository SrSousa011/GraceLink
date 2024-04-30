import 'package:churchapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:churchapp/views/events/event_list_view.dart';
import 'package:churchapp/views/events/floating_action_button_widget.dart';
import 'package:churchapp/views/events/app_bar_widget.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [
    Event(
      title: 'Culto de Domingo',
      description:
          'Participe do nosso culto dominical com louvor, adoração e uma mensagem inspiradora.',
      date: DateTime(2024, 3, 1, 10, 0),
      time: const TimeOfDay(hour: 10, minute: 0), // Adding a default time
      location: 'Igreja da Comunidade',
    ),
    Event(
      title: 'Grupo de Estudo Bíblico',
      description:
          'Venha participar do nosso grupo de estudo bíblico semanal para aprender mais sobre a Palavra de Deus.',
      date: DateTime(2024, 3, 4, 19, 0),
      time: const TimeOfDay(hour: 10, minute: 0), // Adding a default time
      location: 'Salão da Igreja',
    ),
    Event(
      title: 'Concerto de Natal',
      description:
          'Celebre a época festiva com músicas de Natal apresentadas pelo coro da igreja.',
      date: DateTime(2024, 12, 20, 18, 30),
      time: const TimeOfDay(hour: 10, minute: 0), // Adding a default time
      location: 'Igreja da Comunidade',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Eventos'),
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
      ),
      body: EventListView(
        events: events,
        onTap: (event) {
          _navigateToEventDetailsScreen(context, event);
        },
      ),
      floatingActionButton: FloatingActionButtonWidget(
        onPressed: () {
          _navigateToAddEventScreen(context);
        },
        tooltip: 'Novo Evento',
        icon: Icons.add,
      ),
    );
  }

  void _navigateToAddEventScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEventForm()),
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

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  State<StatefulWidget> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _selectController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectLocation(BuildContext context) async {
    // Implementar a lógica para selecionar o local aqui
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Novo Evento'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título do Evento',
                icon: Icon(Icons.title),
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Evento',
                icon: Icon(Icons.description),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                Text(
                  _selectedDate == null
                      ? 'Selecione a data'
                      : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectTime(context);
                  },
                ),
                Text(
                  _selectedTime == null
                      ? 'Selecione o horário'
                      : _selectedTime!.format(context),
                ),
              ],
            ),
            TextField(
              controller: _selectController,
              decoration: const InputDecoration(
                labelText: 'Selecione Local',
                icon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveEvent(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEvent(BuildContext context) {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectController.text.isNotEmpty) {
      final newEvent = Event(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        time: _selectedTime!,
        location: _selectController.text,
      );
      Navigator.pop(context, newEvent);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro ao salvar evento'),
            content: const Text('Por favor, preencha todos os campos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
              'Title: ${event.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${event.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('dd/MM/yyyy').format(event.date)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: ${event.time.format(context)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${event.location}',
              style: const TextStyle(fontSize: 16),
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
  final DateTime date;
  final TimeOfDay time;
  final String location;

  const EventCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
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
              'Horário: ${time.format(context)}',
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

class Event {
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String location;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
  });
}
