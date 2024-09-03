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
      {
        'title': 'Annual Conference',
        'date': '2024-09-15',
        'time': '09:00',
        'location': 'Main Hall',
        'organizer': 'John Doe',
        'cost': '€ 100.00'
      },
      {
        'title': 'Spiritual Retreat',
        'date': '2024-10-05',
        'time': '08:00',
        'location': 'Mountain Lodge',
        'organizer': 'Jane Smith',
        'cost': '€ 150.00'
      },
      {
        'title': 'Community Service Day',
        'date': '2024-11-20',
        'time': '10:00',
        'location': 'Community Center',
        'organizer': 'Emily Davis',
        'cost': 'Free'
      },
      {
        'title': 'Christmas Gala',
        'date': '2024-12-24',
        'time': '18:00',
        'location': 'Grand Ballroom',
        'organizer': 'Michael Brown',
        'cost': '€ 75.00'
      },
      {
        'title': 'Fundraising Dinner',
        'date': '2024-11-10',
        'time': '19:00',
        'location': 'Luxury Hotel',
        'organizer': 'Sarah Lee',
        'cost': '€ 200.00'
      },
      {
        'title': 'Youth Retreat',
        'date': '2024-09-30',
        'time': '07:00',
        'location': 'Campground',
        'organizer': 'Daniel Martinez',
        'cost': '€ 120.00'
      },
      {
        'title': 'Thanksgiving Service',
        'date': '2024-11-25',
        'time': '11:00',
        'location': 'Main Hall',
        'organizer': 'Alice Johnson',
        'cost': 'Free'
      },
      {
        'title': 'Health Fair',
        'date': '2024-10-15',
        'time': '09:00',
        'location': 'Health Center',
        'organizer': 'David Wilson',
        'cost': '€ 30.00'
      },
      {
        'title': 'Winter Retreat',
        'date': '2024-12-05',
        'time': '08:00',
        'location': 'Winter Lodge',
        'organizer': 'Sophia Lewis',
        'cost': '€ 140.00'
      },
      {
        'title': 'Charity Walk',
        'date': '2024-09-22',
        'time': '08:30',
        'location': 'Central Park',
        'organizer': 'Benjamin Young',
        'cost': '€ 20.00'
      },
      {
        'title': 'Music Festival',
        'date': '2024-10-20',
        'time': '14:00',
        'location': 'City Square',
        'organizer': 'Olivia Harris',
        'cost': '€ 50.00'
      },
      {
        'title': 'Volunteer Appreciation',
        'date': '2024-11-05',
        'time': '17:00',
        'location': 'Event Hall',
        'organizer': 'Isabella King',
        'cost': 'Free'
      },
      {
        'title': 'Easter Service',
        'date': '2024-04-01',
        'time': '10:00',
        'location': 'Main Hall',
        'organizer': 'John Doe',
        'cost': 'Free'
      },
      {
        'title': 'Summer Picnic',
        'date': '2024-08-15',
        'time': '12:00',
        'location': 'Green Park',
        'organizer': 'Emily Davis',
        'cost': '€ 25.00'
      },
      {
        'title': 'Leadership Summit',
        'date': '2024-07-20',
        'time': '09:00',
        'location': 'Conference Center',
        'organizer': 'Michael Brown',
        'cost': '€ 85.00'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        backgroundColor: Colors.blue[700],
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
                  'Date: ${event['date']}\n'
                  'Time: ${event['time']}\n'
                  'Location: ${event['location']}\n'
                  'Organizer: ${event['organizer']}\n'
                  'Cost: ${event['cost']}',
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
