import 'package:flutter/material.dart';

class UpcomingEventsScreen extends StatelessWidget {
  const UpcomingEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700];

    final upcomingEvents = [
      {'title': 'Annual Conference', 'date': '2024-09-15'},
      {'title': 'Spiritual Retreat', 'date': '2024-10-05'},
      {'title': 'Community Service Day', 'date': '2024-11-20'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            final event = upcomingEvents[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: cardBackgroundColor,
              child: ListTile(
                title: Text(
                  event['title']!,
                  style: TextStyle(
                      color: primaryTextColor, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Date: ${event['date']}',
                  style: TextStyle(color: secondaryTextColor),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
