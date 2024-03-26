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
          child: EventCard(
            title: events[index].title,
            description: events[index].description,
            date: events[index].date,
            time: events[index].time,
            location: events[index].location,
          ),
        );
      },
    );
  }
}
