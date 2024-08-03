import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/events/event_delete.dart';
import 'package:churchapp/views/events/update_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/events/event_service.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event _event;
  String _creatorName = '';
  final AuthenticationService _authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _fetchCreatorName();
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(_event.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _navigateToUpdateEventScreen(context, _event);
              } else if (value == 'delete') {
                EventDelete.confirmDeleteEvent(
                    context, _event.id, _event.title);
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
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  'Criado por: $_creatorName',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Direita em Italiano',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: isDarkMode ? Colors.grey : Colors.black54,
                ),
              ),
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
