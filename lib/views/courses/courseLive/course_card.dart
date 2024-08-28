import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String courseName;
  final String time;
  final String imageURL;
  final String? videoUrl;
  final String daysOfWeek;
  final VoidCallback? onPlay;
  final VoidCallback onUpdate;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.time,
    required this.imageURL,
    this.videoUrl,
    required this.daysOfWeek,
    this.onPlay,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDarkMode ? Colors.blueGrey[800] : Colors.blue;
    final iconColor = isDarkMode ? buttonColor : Colors.black;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF3C3C3C), Color(0xFF5A5A5A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFFFD59C), Color(0xFF62CFF7)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 100,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageURL),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
                color: isDarkMode ? Colors.blueGrey[900] : Colors.white,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      courseName,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      'Horário: $time\nDias: $daysOfWeek',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    trailing: videoUrl != null && videoUrl!.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.play_arrow, color: iconColor),
                            iconSize: 36.0,
                            onPressed: onPlay,
                          )
                        : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: onUpdate,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: buttonColor,
                        ),
                        child: const Text('Atualizar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
