import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Main EventsPage Widget
class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: StreamBuilder<List<Event>>(
        stream: readEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar eventos'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum evento encontrado'));
          }
          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _navigateToEventDetailsScreen(context, events[index]);
                },
                child: EventListItem(event: events[index]),
              );
            },
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
      MaterialPageRoute(builder: (context) => const AddEventForm()),
    );
    if (result != null && result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento adicionado com sucesso')),
      );
    }
  }

  void _navigateToEventDetailsScreen(BuildContext context, Event event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
    );
    if (result != null && result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento atualizado')),
      );
    }
  }
}

class EventListItem extends StatelessWidget {
  final Event event;

  const EventListItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(event.title),
        subtitle: Text(DateFormat('dd/MM/yyyy').format(event.date)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetailsScreen(event: event)),
          );
        },
      ),
    );
  }
}

Stream<List<Event>> readEvents() {
  CollectionReference events = FirebaseFirestore.instance.collection('events');
  return events.snapshots().map((snapshot) => snapshot.docs
      .map((doc) =>
          Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
      .toList());
}

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _navigateToUpdateEventScreen(context, event);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteEvent(context, event);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título: ${event.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildDetailsText('Descrição: ${event.description}'),
            _buildDetailsText(
              'Data: ${DateFormat('dd/MM/yyyy').format(event.date)}',
            ),
            _buildDetailsText('Hora: ${event.time.format(context)}'),
            _buildDetailsText('Localização: ${event.location}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  void _navigateToUpdateEventScreen(BuildContext context, Event event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateEventForm(event: event)),
    );
    if (result != null && result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento atualizado')),
      );
    }
  }

  void _deleteEvent(BuildContext context, Event event) async {
    try {
      await deleteEvent(event.id);
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro ao excluir evento'),
            content: const Text('Ocorreu um erro ao tentar excluir o evento.'),
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

class UpdateEventForm extends StatefulWidget {
  final Event event;

  const UpdateEventForm({super.key, required this.event});

  @override
  State<StatefulWidget> createState() => _UpdateEventFormState();
}

class _UpdateEventFormState extends State<UpdateEventForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _location = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _selectedDate = widget.event.date;
    _selectedTime = widget.event.time;
    _location = widget.event.location;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _updateEvent(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        time: _selectedTime!,
        location: _location,
      );
      try {
        await updateEvent(updatedEvent, widget.event.id);
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro ao atualizar evento'),
              content:
                  const Text('Ocorreu um erro ao tentar atualizar o evento.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro ao atualizar evento'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar Evento'),
      ),
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
      ),
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
            const SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Evento',
                icon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                if (_selectedDate != null)
                  Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    style: const TextStyle(fontSize: 18.0),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
                if (_selectedTime != null)
                  Text(
                    _selectedTime!.format(context),
                    style: const TextStyle(fontSize: 18.0),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (value) => _location = value,
              decoration: const InputDecoration(
                labelText: 'Localização',
                icon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _updateEvent(context),
              child: const Text('Atualizar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}

// AddEventForm Widget
class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  late TextEditingController _idController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _location = '';

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveEvent(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      final newEvent = Event(
        id: _idController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        time: _selectedTime!,
        location: _location,
      );
      try {
        await addEvent(newEvent);
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro ao salvar evento'),
              content: const Text('Ocorreu um erro ao tentar salvar o evento.'),
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
              decoration: const InputDecoration(
                labelText: 'Título do Evento',
                icon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Evento',
                icon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                if (_selectedDate != null)
                  Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    style: const TextStyle(fontSize: 18.0),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
                if (_selectedTime != null)
                  Text(
                    _selectedTime!.format(context),
                    style: const TextStyle(fontSize: 18.0),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (value) => _location = value,
              decoration: const InputDecoration(
                labelText: 'Localização',
                icon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _saveEvent(context),
              child: const Text('Salvar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String id; // Unique ID of the event
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
  });

  factory Event.fromFirestore(String id, Map<String, dynamic> data) {
    return Event(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: TimeOfDay(
        hour: int.parse(data['time'].split(':')[0]),
        minute: int.parse(data['time'].split(':')[1]),
      ),
      location: data['location'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': '${time.hour}:${time.minute}',
      'location': location,
    };
  }
}

Future<void> addEvent(Event event) async {
  try {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    await events.add({
      'title': event.title,
      'description': event.description,
      'date': Timestamp.fromDate(event.date), // Convert DateTime to Timestamp
      'time': '${event.time.hour}:${event.time.minute}',
      'location': event.location,
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error adding event: $e');
    }
    rethrow; // Propagate error to the caller if necessary
  }
}

Future<void> updateEvent(Event event, String eventId) async {
  try {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    await events.doc(eventId).update({
      'title': event.title,
      'description': event.description,
      'date': Timestamp.fromDate(event.date), // Convert DateTime to Timestamp
      'time': '${event.time.hour}:${event.time.minute}',
      'location': event.location,
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error updating event: $e');
    }
    rethrow; // Propagate error to the caller if necessary
  }
}

Future<void> deleteEvent(String eventId) async {
  try {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    await events.doc(eventId).delete();
  } catch (e) {
    if (kDebugMode) {
      print('Error deleting event: $e');
    }
    rethrow; // Propagate error to the caller if necessary
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Flutter Firestore Events',
    home: Events(),
  ));
}
