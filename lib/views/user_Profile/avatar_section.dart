import 'package:flutter/material.dart';

class AvatarSection extends StatelessWidget {
  const AvatarSection({
    super.key,
    required this.fullName,
    required this.location,
  });

  final String? fullName;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 100,
          backgroundImage: AssetImage('assets/imagens/profile_picture.jpg'),
        ),
        const SizedBox(height: 10),
        Text(
          fullName ?? 'Loading...',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.blue),
            const SizedBox(width: 5),
            Text(
              location,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
