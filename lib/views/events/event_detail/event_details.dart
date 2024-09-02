import 'package:flutter/material.dart';

class EventDetails extends StatelessWidget {
  final String? title;
  final String description;
  final String date;
  final String time;
  final String location;
  final bool isDarkMode;

  const EventDetails({
    super.key,
    this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && title!.isNotEmpty)
          Text(
            title!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        _buildDetailsText(description),
        _buildDetailsText(date),
        _buildDetailsText(time),
        _buildDetailsText(location),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildDetailsText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
