import 'package:flutter/material.dart';

class SubscriberViewer extends StatelessWidget {
  final String userId;
  final String userName;
  final bool status;
  final DateTime registrationDate;
  final String courseName; // Adicione esta variável

  const SubscriberViewer({
    Key? key,
    required this.userId,
    required this.userName,
    required this.status,
    required this.registrationDate,
    required this.courseName, // Adicione esta variável
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriber Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: $userId',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              'User Name: $userName',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Course Name: $courseName', // Exiba o nome do curso
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Status: ${status ? 'Payed' : 'Not Payed'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Registration Date: ${registrationDate.toLocal()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
