import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/events/add_event.dart';
import 'package:churchapp/views/events/event_details.dart';
import 'package:churchapp/views/events/event_list_item.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final GlobalKey<_EventsState> myWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
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
    // Navigate to AddEventForm and wait for a result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEventForm()),
    );

    if (result != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento adicionado com sucesso')),
        );
      }
    }
  }

void _navigateToEventDetailsScreen(BuildContext context, Event event) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
  );
  if (result != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento atualizado')),
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
