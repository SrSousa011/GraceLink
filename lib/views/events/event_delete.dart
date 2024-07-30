import 'package:flutter/material.dart';
import 'package:churchapp/views/events/event_service.dart';

class EventDelete {
  static void confirmDeleteEvent(
      BuildContext context, String eventId, String eventTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content:
              Text('Tem certeza que deseja excluir o evento "$eventTitle"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
                _deleteEventAndNotify(context, eventId);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _deleteEventAndNotify(
      BuildContext context, String eventId) async {
    await _deleteEvent(context, eventId);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento excluído com sucesso!'),
        ),
      );

      Navigator.pushReplacementNamed(context, '/event_page');
    }
  }

  static Future<void> _deleteEvent(BuildContext context, String eventId) async {
    try {
      await deleteEvent(eventId);
      if (!context.mounted) return;
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro ao excluir evento'),
            content: const Text('Ocorreu um erro ao tentar excluir o evento.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
