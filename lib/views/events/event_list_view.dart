import 'package:churchapp/views/events/events.dart';
import 'package:flutter/material.dart';

class EventListView extends StatelessWidget {
  final List<Event> events;
  final void Function(Event) onTap;

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
