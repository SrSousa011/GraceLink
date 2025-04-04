import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/views/notifications/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/events/add/add_event.dart';
import 'package:churchapp/views/events/event_detail/event_details_screen.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/events/event_service.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  Future<List<EventService>>? _eventsFuture;
  List<EventService> _allEvents = [];
  List<EventService> _filteredEvents = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final NotificationService _notificationService = NotificationService();
  bool _isSearching = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _fetchEvents();
    _fetchCurrentUserData();
    _notificationService.initialize();
    _notificationService.requestIOSPermissions();
  }

  Future<List<EventService>> _fetchEvents() async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    var snapshot = await events.orderBy('date', descending: true).get();
    final eventsList = snapshot.docs
        .map((doc) => EventService.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>))
        .toList();

    setState(() {
      _allEvents = eventsList;
      _filteredEvents = _filterEvents(_searchQuery);
    });

    return eventsList;
  }

  List<EventService> _filterEvents(String query) {
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

  Future<void> _fetchCurrentUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final userData = UserData.fromDocument(doc);

      setState(() {
        _isAdmin = userData.role == 'admin';
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar dados do usuário: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
                : const Text(
                    'Eventos',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
            floating: true,
            pinned: false,
            snap: true,
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
          SliverPadding(
            padding: const EdgeInsets.all(0.0),
            sliver: FutureBuilder<List<EventService>>(
              future: _eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return const SliverFillRemaining(
                      child: Center(child: Text('Erro ao carregar eventos')));
                }
                if (!snapshot.hasData || _filteredEvents.isEmpty) {
                  return const SliverFillRemaining(
                      child: Center(child: Text('Nenhum evento encontrado')));
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = _filteredEvents[index];
                      return GestureDetector(
                        onTap: () {
                          _navigateToEventDetailsScreen(context, event);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4.0, left: 24.0),
                                child: Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (event.location.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24.0, top: 4.0),
                                  child: Text(
                                    event.location,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              if (event.imageUrl != null &&
                                  event.imageUrl!.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _navigateToEventDetailsScreen(
                                        context, event);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      event.imageUrl!,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _filteredEvents.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () {
                _navigateToAddEventScreen(context);
              },
              tooltip: 'Novo Evento',
              child: const Icon(Icons.add),
            )
          : null,
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

  void _navigateToEventDetailsScreen(
      BuildContext context, EventService event) async {
    final updatedEvent = await Navigator.push(
      context,
      _createPageRoute(EventDetailsScreen(event: event)),
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
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end);
        var offsetAnimation =
            animation.drive(tween.chain(CurveTween(curve: curve)));

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
