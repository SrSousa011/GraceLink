import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/user_Profile/profile_menu.dart';
import 'package:churchapp/views/user_Profile/settings.dart';
import 'package:churchapp/views/user_Profile/update_profile.dart'; // Import the UpdateProfileScreen
import 'package:churchapp/models/user_data.dart'; // Import UserData model
import 'package:churchapp/services/auth_service.dart';

const Color tAccentColor =
    Color.fromARGB(255, 251, 251, 251); // Example accent color

const double tDefaultSize = 16.0; // Define a default size
const String tProfileImage =
    'assets/imagens/default_avatar.png'; // Define a profile image path
const Color tDarkColor = Colors.black; // Example dark color
const Color tPrimaryColor = Colors.blue; // Example primary color

class ProfileScreen extends StatefulWidget {
  final UserData userData; // Required parameter

  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.userData.fullName);
    _addressController = TextEditingController(text: widget.userData.address);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(tProfileImage),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: tPrimaryColor,
                      ),
                      child: const Center(
                        child: Icon(
                          LineAwesomeIcons.pencil_alt_solid,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.userData.fullName,
                style: Theme.of(context).textTheme.headlineSmall!,
              ),
              Text(
                widget.userData.address,
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateProfileScreen(userData: widget.userData),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: tDarkColor),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: 'Settings',
                icon: LineAwesomeIcons.cog_solid,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              ProfileMenuWidget(
                title: 'User Management',
                icon: LineAwesomeIcons.user_check_solid,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateProfileScreen(userData: widget.userData),
                    ),
                  );
                },
              ),
              ProfileMenuWidget(
                title: 'Info',
                icon: LineAwesomeIcons.info_solid,
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
      ),
    );
  }
}
