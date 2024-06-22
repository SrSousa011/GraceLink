import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/events/add_event.dart';
import 'package:churchapp/views/events/event_details.dart';
import 'package:churchapp/views/events/event_list_item.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final GlobalKey<_EventsState> myWidgetKey = GlobalKey();
  final bool canReturn = false;

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

void main() {
  runApp(const MaterialApp(
    title: 'Flutter Firestore Events',
    home: Events(),
  ));
}
