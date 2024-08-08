import 'dart:async';
import 'dart:io';
import 'package:churchapp/views/events/event_delete.dart';
import 'package:churchapp/views/events/event_detail/event_details.dart';
import 'package:churchapp/views/events/event_detail/event_image.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/events/update_event.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:path/path.dart' as path;

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event _event;
  String _creatorName = '';
  String _creatorImageUrl = '';
  bool _isAdmin = false;
  String? _currentUserId;
  final AuthenticationService _authService = AuthenticationService();
  final ImagePicker _picker = ImagePicker();
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
      _fetchCreatorDetails(),
      _checkIfAdmin(),
      _fetchCurrentUserId(),
      _checkLocalImage(),
    ]);
  }

  Future<void> _fetchCreatorDetails() async {
    try {
      final name = await _authService.getUserNameById(_event.createdBy);
      final imageUrl = await _authService.getUserImageById(_event.createdBy);

      if (mounted) {
        setState(() {
          _creatorName = name;
          _creatorImageUrl = imageUrl ?? '';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching creator details: $e');
      }
    }
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

  Future<void> _checkLocalImage() async {
    if (_event.imageUrl != null && _event.imageUrl!.isNotEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = _getFileNameFromUrl(_event.imageUrl!);
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      if (await file.exists()) {
        setState(() {
          _localImagePath = filePath;
        });
      } else {
        await _downloadAndSaveImage(filePath);
      }
    }
  }

  Future<void> _downloadAndSaveImage(String filePath) async {
    try {
      final directory = path.dirname(filePath);
      final dir = Directory(directory);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final response = await http.get(Uri.parse(_event.imageUrl!));
      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;

        final file = File(filePath);
        await file.writeAsBytes(imageBytes);

        if (mounted) {
          setState(() {
            _localImagePath = filePath;
          });
        }
      } else {
        if (kDebugMode) {
          print('Failed to download image: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading or saving image: $e');
      }
    }
  }

  String _getFileNameFromUrl(String url) {
    final Uri uri = Uri.parse(url);
    return uri.pathSegments.last;
  }

  bool _shouldShowPopupMenu() {
    return _isAdmin || _currentUserId == _event.createdBy;
  }

  Future<void> _updateImage() async {
    if (_shouldShowPopupMenu()) {
      try {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          File file = File(pickedFile.path);
          final imageBytes = await file.readAsBytes();

          String fileName = path.basename(file.path);
          String uniqueFileName =
              '${DateTime.now().millisecondsSinceEpoch}_$fileName';

          final uploadTask = _storage
              .ref()
              .child('eventImages/$uniqueFileName')
              .putData(imageBytes);
          final taskSnapshot = await uploadTask;

          final downloadUrl = await taskSnapshot.ref.getDownloadURL();
          if (kDebugMode) {
            print('Image uploaded successfully: $downloadUrl');
          }

          setState(() {
            _event = _event.copyWith(imageUrl: downloadUrl);
            _localImagePath = null;
          });

          await updateEvent(_event, _event.id);

          await _checkLocalImage();
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error selecting or uploading image: $e");
        }
      }
    }
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: _creatorImageUrl.isNotEmpty
                            ? NetworkImage(_creatorImageUrl)
                            : null,
                        radius: 20,
                        child: _creatorImageUrl.isEmpty
                            ? Icon(Icons.person, color: Colors.grey[600])
                            : null,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          _creatorName,
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
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.blue),
                                title: Text('Edit',
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete,
                                    color: isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.red),
                                title: Text('Delete',
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.red)),
                              ),
                            ),
                          ],
                          icon: Icon(Icons.more_vert,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                    ],
                  ),
                ),
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
              onPressed: _updateImage,
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
              child: Icon(Icons.add_a_photo,
                  color: isDarkMode ? Colors.white : Colors.black),
            )
          : null,
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
