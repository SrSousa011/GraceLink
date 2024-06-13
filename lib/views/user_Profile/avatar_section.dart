import 'package:flutter/material.dart';

class AvatarSection extends StatefulWidget {
  const AvatarSection({
    super.key,
    required this.fullName,
    required this.location,
  });

  final String? fullName;
  final String location;

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection> {
  bool isAvatarTapped = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            setState(() {
              isAvatarTapped = !isAvatarTapped;
            });
          },
          child: CircleAvatar(
            radius: isAvatarTapped ? 150 : 100, // Larger radius when tapped
            backgroundImage:
                const AssetImage('assets/imagens/profile_picture.jpg'),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.fullName ?? 'Loading...',
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
              widget.location,
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
