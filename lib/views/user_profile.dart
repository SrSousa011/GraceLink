import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/nav_bar.dart';
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
        const SizedBox(height: 40),
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

class PhotoGrid extends StatefulWidget {
  const PhotoGrid({super.key});

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    fullName = await AuthenticationService().getCurrentUserName();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          6,
          (index) {
            return Container(
              margin: const EdgeInsets.all(5),
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Photo ${index + 1}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    fullName = await AuthenticationService().getCurrentUserName();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        drawer: NavBar(
          auth: AuthenticationService(),
          authService: AuthenticationService(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvatarSection(
                fullName: fullName,
                location: 'New York, USA',
              ),
              const SizedBox(height: 50),
              const PhotoGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UserProfile(),
  ));
}
