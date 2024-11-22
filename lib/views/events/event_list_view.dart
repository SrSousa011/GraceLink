import 'package:churchapp/views/events/event_list_item.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:flutter/material.dart';

class EventListView extends StatelessWidget {
  final List<EventService> events;
  final void Function(EventService) onTap;

  const EventListView({
    super.key,
    required this.events,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTap(events[index]),
          child: EventListItem(event: events[index]),
        );
      },
    );
  }
}
