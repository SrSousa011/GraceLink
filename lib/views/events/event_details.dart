import 'package:churchapp/views/events/event_delete.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:churchapp/views/events/update_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _navigateToUpdateEventScreen(context, event);
              } else if (value == 'delete') {
                EventDelete.confirmDeleteEvent(context, event.id, event.title);
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
                      color: isDarkMode ? Colors.redAccent : Colors.red),
                  title: Text(
                    'Excluir',
                    style: TextStyle(
                        color: isDarkMode ? Colors.redAccent : Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título: ${event.title}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            _buildDetailsText('Descrição: ${event.description}', isDarkMode),
            _buildDetailsText(
              'Data: ${DateFormat('dd/MM/yyyy').format(event.date)}',
              isDarkMode,
            ),
            _buildDetailsText(
                'Hora: ${event.time.format(context)}', isDarkMode),
            _buildDetailsText('Localização: ${event.location}', isDarkMode),
          ],
        ),
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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateEventForm(event: event)),
    );
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento atualizado')),
      );
    }
  }
}
