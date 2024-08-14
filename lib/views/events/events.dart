import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/events/add/add_event.dart';
import 'package:churchapp/views/events/event_detail/event_details_screen.dart';
import 'package:churchapp/views/events/event_list_item.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/events/event_service.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  Future<List<Event>>? _eventsFuture;
  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _fetchEvents();
  }

  Future<List<Event>> _fetchEvents() async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    var snapshot = await events.orderBy('date', descending: true).get();
    final eventsList = snapshot.docs
        .map((doc) =>
            Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();

    setState(() {
      _allEvents = eventsList;
      _filteredEvents = _filterEvents(_searchQuery);
    });

    return eventsList;
  }

  List<Event> _filterEvents(String query) {
    if (query.isEmpty) {
      return _allEvents;
    }
    final lowercasedQuery = query.toLowerCase();
    return _allEvents.where((event) {
      return event.title.toLowerCase().contains(lowercasedQuery);
    }).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredEvents = _filterEvents(_searchQuery);
    });
  }

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
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: _updateSearchQuery,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Pesquisar eventos...',
                  ),
                )
              : const Text('Eventos'),
          actions: [
            _isSearching
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                        _updateSearchQuery('');
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
          ],
        ),
        drawer: const NavBar(),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: _eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar eventos'));
                  }
                  if (!snapshot.hasData || _filteredEvents.isEmpty) {
                    return const Center(
                        child: Text('Nenhum evento encontrado'));
                  }
                  return ListView.builder(
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _navigateToEventDetailsScreen(
                              context, _filteredEvents[index]);
                        },
                        child: EventListItem(event: _filteredEvents[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
    final result = await Navigator.push(
      context,
      _createPageRoute(const AddEventForm()),
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
      _createPageRoute(EventDetailsScreen(event: event)) as Route<Event>,
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

  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from right
        const end = Offset.zero; // End at the center
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end);
        var offsetAnimation =
            animation.drive(tween.chain(CurveTween(curve: curve)));

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
