import 'package:churchapp/views/events/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/events/event_detail/event_image.dart';
import 'package:churchapp/views/events/event_detail/event_image_add.dart';
import 'package:churchapp/views/events/event_delete.dart';
import 'package:churchapp/views/events/update_event.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:churchapp/views/events/event_detail/event_details.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventService event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late EventService _event;
  bool _isAdmin = false;
  String? _currentUserId;
  final AuthenticationService _authService = AuthenticationService();
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([_checkIfAdmin(), _fetchCurrentUserId()]);
  }

  Future<void> _checkIfAdmin() async {
    try {
      final role = await _authService.getUserRole();
      setState(() {
        _isAdmin = role == 'admin';
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error checking admin role: $e');
      }
    }
  }

  Future<void> _fetchCurrentUserId() async {
    try {
      _currentUserId = await _authService.getCurrentUserId();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching current user ID: $e');
      }
    }
  }

  bool _shouldShowPopupMenu() {
    return _isAdmin || _currentUserId == _event.createdBy;
  }

  Future<void> _pickImage() async {
    final imageAdd = ImageAdd(
      storage: _storage,
      firestore: _firestore,
      picker: _picker,
      eventId: _event.id,
    );

    imageAdd.uploadAndSaveImage(
      onSuccess: () {
        setState(() {});
      },
      onError: (errorMessage) {
        if (kDebugMode) {
          print('Error uploading image: $errorMessage');
        }
      },
    );
  }

  Stream<DocumentSnapshot> _getEventStream() {
    return _firestore.collection('events').doc(_event.id).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black),
          onPressed: _navigateToEventScreen,
        ),
        title: Text(
          _event.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (_shouldShowPopupMenu())
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _navigateToUpdateEventScreen(context, _event);
                } else if (value == 'changeImage') {
                  _pickImage();
                } else if (value == 'delete') {
                  EventDelete.confirmDeleteEvent(
                    context,
                    _event.id,
                    _event.title,
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit,
                        color: isDarkMode ? Colors.white : Colors.blue),
                    title: Text('Editar',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'changeImage',
                  child: ListTile(
                    leading: Icon(Icons.image,
                        color: isDarkMode ? Colors.white : Colors.blue),
                    title: Text('Nova foto',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete,
                        color: isDarkMode ? Colors.grey[300] : Colors.red),
                    title: Text('Deletar',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.red)),
                  ),
                ),
              ],
              icon: Icon(Icons.more_vert,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: _getEventStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('Evento não encontrado.'));
                }

                final eventData = snapshot.data!;
                final updatedEvent = EventService.fromSnapshot(eventData);

                _event = updatedEvent;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, top: 4.0),
                      child: Text(
                        updatedEvent.location,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: EventImage(
                        imageUrlStream: _getEventStream().map((snapshot) {
                          final data = snapshot.data() as Map<String, dynamic>;
                          return data['imageUrl'] as String?;
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                      child: EventDetails(
                        description: updatedEvent.description,
                        date:
                            'Data: ${DateFormat('dd/MM/yyyy').format(updatedEvent.date)}',
                        time: 'Horário: ${updatedEvent.time.format(context)}',
                        location: '',
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToUpdateEventScreen(
      BuildContext context, EventService event) async {
    final updatedEvent = await Navigator.push<EventService>(
      context,
      MaterialPageRoute(builder: (context) => UpdateEventForm(event: event)),
    );

    if (updatedEvent != null && context.mounted) {
      setState(() {
        _event = updatedEvent;
      });
    }
  }

  void _navigateToEventScreen() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const Events()),
    );

    if (result != null && context.mounted) {
      setState(() {
        _event = EventService(
          id: result['id'],
          title: result['title'],
          description: result['description'],
          date: result['date'],
          time: result['time'],
          location: result['location'],
          imageUrl: result['imageUrl'],
          createdBy: _event.createdBy,
        );
      });
    }
  }
}
