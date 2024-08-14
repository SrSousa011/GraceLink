import 'dart:async';
import 'package:churchapp/views/events/event_delete.dart';
import 'package:churchapp/views/events/event_detail/event_details.dart';
import 'package:churchapp/views/events/event_detail/event_image.dart';
import 'package:churchapp/views/events/event_detail/event_image_add.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/events/update_event.dart';
import 'package:churchapp/views/events/event_service.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event _event;
  bool _isAdmin = false;
  String? _currentUserId;
  final AuthenticationService _authService = AuthenticationService();
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _checkIfAdmin(),
      _fetchCurrentUserId(),
    ]);
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
        title: const Text('Evento'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(_event.createdBy)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return _buildCreatorInfo('', '');
                    }

                    final userData = snapshot.data!;
                    final creatorName = userData['fullName'] ?? '';
                    final creatorImageUrl = userData['imagePath'] ?? '';

                    return _buildCreatorInfo(creatorName, creatorImageUrl);
                  },
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: EventImage(
                    imageUrl: _event.imageUrl,
                    localImagePath: _localImagePath,
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: EventDetails(
                    title: _event.title,
                    description: _event.description,
                    date: DateFormat('dd/MM/yyyy').format(_event.date),
                    time: _event.time.format(context),
                    location: _event.location,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _shouldShowPopupMenu()
          ? FloatingActionButton(
              onPressed: _pickImage,
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
              child: Icon(Icons.add_a_photo,
                  color: isDarkMode ? Colors.white : Colors.black),
            )
          : null,
    );
  }

  Widget _buildCreatorInfo(String name, String imageUrl) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            radius: 20,
            child: imageUrl.isEmpty
                ? Icon(Icons.person, color: Colors.grey[600])
                : null,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          if (_shouldShowPopupMenu())
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _navigateToUpdateEventScreen(context, _event);
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
                    title: Text('Edit',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete,
                        color: isDarkMode ? Colors.grey[300] : Colors.red),
                    title: Text('Delete',
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
    );
  }

  void _navigateToUpdateEventScreen(BuildContext context, Event event) async {
    final updatedEvent = await Navigator.push<Event>(
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
      MaterialPageRoute(
        builder: (context) => const Events(),
      ),
    );

    if (result != null && context.mounted) {
      setState(() {
        _event = Event(
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
