import 'package:flutter/material.dart';

class SubscriberInfo extends StatelessWidget {
  final String userId;
  final String userName;
  final bool status;
  final DateTime registrationDate;
  final String courseName;
  final String imagePath;

  const SubscriberInfo({
    super.key,
    required this.userId,
    required this.userName,
    required this.status,
    required this.registrationDate,
    required this.courseName,
    required this.imagePath,
  });

  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]!
        : Colors.white;
  }

  Color _getAppBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[850]!
        : Colors.blue;
  }

  Color _getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[100]!;
  }

  Color _getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  Color _getSubtitleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[300]!
        : Colors.grey[600]!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor =
        theme.brightness == Brightness.dark ? Colors.blueGrey : Colors.blue;

    String formattedDate = '${registrationDate.day.toString().padLeft(2, '0')}/'
        '${registrationDate.month.toString().padLeft(2, '0')}/'
        '${registrationDate.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriber Details'),
        backgroundColor: _getAppBarColor(context),
      ),
      backgroundColor: _getBackgroundColor(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: _getCardColor(context),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: imagePath.isNotEmpty
                              ? NetworkImage(imagePath)
                              : null,
                          radius: 30,
                          child: imagePath.isEmpty
                              ? Icon(Icons.person,
                                  color: _getTextColor(context))
                              : null,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            userName,
                            style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getTextColor(context)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Course: $courseName',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: _getSubtitleColor(context)),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Registration Date: $formattedDate',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: _getSubtitleColor(context)),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Status:',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getTextColor(context)),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: status ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        status ? 'Paid' : 'Not Paid',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Back',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
