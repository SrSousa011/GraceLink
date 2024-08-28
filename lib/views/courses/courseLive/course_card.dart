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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageURL.isNotEmpty
              ? Container(
                  width: 80,
                  height: 100,
                  margin: const EdgeInsets.all(8.0),
                  child: Image.network(
                    imageURL,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 80,
                  height: 100,
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 80),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(courseName),
                  subtitle: Text('Horário: $time\nDias: $daysOfWeek'),
                  trailing: videoUrl != null && videoUrl!.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.play_arrow),
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
                        backgroundColor: Theme.of(context).primaryColor,
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
    );
  }
}
