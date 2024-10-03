import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriberTile extends StatelessWidget {
  final Map<String, dynamic> registration;
  final bool isDarkMode;
  final VoidCallback onTap;

  const SubscriberTile({
    super.key,
    required this.registration,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final registrationDate = registration['registrationDate'] as DateTime;
    final formattedDate =
        DateFormat('d MMMM yyyy', 'pt_BR').format(registrationDate);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: registration['imagePath'] != ''
            ? NetworkImage(registration['imagePath'])
            : null,
        backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
        child: registration['imagePath'] == ''
            ? Icon(
                Icons.person,
                color: isDarkMode ? Colors.white : Colors.black,
              )
            : null,
      ),
      title: Text(
        registration['userName'],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        'Curso: ${registration['courseName']} \nData de inscrição: $formattedDate',
        style: TextStyle(
          color: isDarkMode ? Colors.grey[300] : Colors.black54,
        ),
      ),
      tileColor: isDarkMode ? Colors.grey[800] : Colors.white,
      onTap: onTap,
    );
  }
}
