import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/events/add_event.dart';
import 'package:churchapp/views/events/event_details.dart';
import 'package:churchapp/views/events/event_list_item.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/events/event_service.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  Future<List<Event>>? _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _fetchEvents();
  }

  Future<List<Event>> _fetchEvents() async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    var snapshot = await events.orderBy('date', descending: true).get();
    return snapshot.docs
        .map((doc) =>
            Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

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
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
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
      floatingActionButton: _buildAddEventButton(),
    );
  }

  Widget _buildAddEventButton() {
    return FloatingActionButton(
      onPressed: () {
        _navigateToAddEventScreen(context);
      },
      tooltip: 'Novo Evento',
      child: const Icon(Icons.add),
    );
  }

  void _navigateToAddEventScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEventForm()),
    );

    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento adicionado com sucesso')),
      );
      setState(() {
        _eventsFuture = _fetchEvents();
      });
    }
  }

  void _navigateToEventDetailsScreen(BuildContext context, Event event) async {
    final updatedEvent = await Navigator.push<Event>(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
    );

    if (updatedEvent != null && context.mounted) {
      setState(() {
        _eventsFuture = _fetchEvents();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento atualizado')),
      );
    }
  }
}
