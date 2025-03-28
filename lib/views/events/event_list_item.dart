import 'package:churchapp/views/events/event_detail/event_details_screen.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListItem extends StatelessWidget {
  final EventService event;

  const EventListItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: buildListTile(context),
    );
  }

  Widget buildListTile(BuildContext context) {
    return ListTile(
      title: Text(
        event.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd/MM/yyyy').format(event.date),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            event.location,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(event: event),
          ),
        );
      },
    );
  }
}
