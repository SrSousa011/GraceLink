import 'dart:io';
import 'package:churchapp/views/events/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/events/update_event.dart';
import 'package:churchapp/views/events/event_delete.dart';
import 'package:churchapp/views/events/image_picker.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event _event;
  String _creatorName = '';
  bool _isAdmin = false;
  String? _currentUserId;
  final AuthenticationService _authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchCreatorName();
    await _checkIfAdmin();
    await _fetchCurrentUserId();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchCreatorName() async {
    try {
      final name = await _authService.getUserNameById(_event.createdBy);
      if (mounted) {
        setState(() {
          _creatorName = name;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar nome do criador: $e');
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
        print('Erro ao verificar se o usuário é admin: $e');
      }
    }
  }

  Future<void> _fetchCurrentUserId() async {
    try {
      _currentUserId = await _authService.getCurrentUserId();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar o ID do usuário atual: $e');
      }
    }
  }

  bool _shouldShowPopupMenu() {
    return _isAdmin || _currentUserId == _event.createdBy;
  }

  Future<void> _updateImage() async {
    if (_shouldShowPopupMenu()) {
      final newImageUrl = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => ImagePickerScreen()),
      );

      if (newImageUrl != null) {
        setState(() {
          _event = _event.copyWith(imageUrl: newImageUrl);
        });

        // Atualize o evento no Firestore com a nova URL da imagem
        await updateEvent(_event, _event.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(_event.title),
        actions: _shouldShowPopupMenu()
            ? [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToUpdateEventScreen(context, _event);
                    } else if (value == 'delete') {
                      EventDelete.confirmDeleteEvent(
                          context, _event.id, _event.title);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit,
                            color: isDarkMode ? Colors.white : Colors.blue),
                        title: Text('Editar',
                            style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black)),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete,
                            color: isDarkMode ? Colors.grey[300] : Colors.red),
                        title: Text('Excluir',
                            style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.red)),
                      ),
                    ),
                  ],
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _updateImage,
                  child: _event.imageUrl != null
                      ? Image.file(
                          File(_event
                              .imageUrl!), // Use FileImage for local files
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          child: Center(
                            child: Icon(Icons.add_a_photo,
                                color:
                                    isDarkMode ? Colors.white : Colors.black54),
                          ),
                        ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Título: ${_event.title}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                _buildDetailsText(
                    'Descrição: ${_event.description}', isDarkMode),
                _buildDetailsText(
                    'Data: ${DateFormat('dd/MM/yyyy').format(_event.date)}',
                    isDarkMode),
                _buildDetailsText(
                    'Hora: ${_event.time.format(context)}', isDarkMode),
                _buildDetailsText(
                    'Localização: ${_event.location}', isDarkMode),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Criado por',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: isDarkMode ? Colors.grey : Colors.black54,
                  ),
                ),
                const SizedBox(width: 4.0),
                Text(
                  _creatorName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsText(String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
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
}
