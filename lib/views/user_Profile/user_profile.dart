import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/user_Profile/profile_menu.dart';
import 'package:churchapp/views/user_Profile/settings/settings.dart';
import 'package:churchapp/views/user_Profile/update_profile.dart';
import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/views/user_Profile/store_data.dart';

const Color tAccentColor = Color.fromARGB(255, 0, 0, 0);
const double tDefaultSize = 16.0;
const String tProfileImage = 'assets/imagens/default_avatar.png';
const Color tDarkColor = Color.fromARGB(255, 255, 255, 255);
const Color tPrimaryColor = Colors.blue;

class ProfileScreen extends StatefulWidget {
  final UserData userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _fullNameController;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.userData.fullName);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List img = await image.readAsBytes();
      setState(() {
        _image = img;
      });
      saveImage();
    }
  }

  Future<void> saveImage() async {
    try {
      if (_image != null) {
        String resp = await StoreData().saveData(file: _image!);
        if (resp == 'Success') {
          setState(() {
            // Image saved successfully
          });
        } else {
          // Handle error
        }
      }
    } catch (err) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: Theme.of(context).textTheme.titleLarge,
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
                      child: _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.userData.imagePath,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                radius: 64,
                                backgroundImage: AssetImage(tProfileImage),
                              ),
                              fit: BoxFit.cover,
                            ),
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
                      child: IconButton(
                        icon: const Icon(
                          LineAwesomeIcons.camera_retro_solid,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: selectImage,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.userData.fullName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: tPrimaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.userData.address,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
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
                    style: TextStyle(color: Colors.black),
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
                onPress: () {},
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
