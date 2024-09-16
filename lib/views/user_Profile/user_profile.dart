import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/util/imagepicker.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/user_Profile/editProfile/manegement/user_management_screen.dart';
import 'package:churchapp/views/user_Profile/editProfile/update_profile.dart';
import 'package:churchapp/views/user_Profile/info/info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:churchapp/views/user_Profile/profile_menu.dart';
import 'package:churchapp/views/user_Profile/settings/settings.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';

const String tAvatar = 'assets/imagens/default_avatar.png';

class ProfileScreen extends StatefulWidget {
  final UserData userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ImagePickerr _imagePicker;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;

    _imagePicker = ImagePickerr(
      storage: FirebaseStorage.instance,
      firestore: FirebaseFirestore.instance,
      picker: ImagePicker(),
      userId: _user.uid,
    );
  }

  void _updateProfilePicture() async {
    await _imagePicker.updateProfilePicture(
      () {
        setState(() {});
      },
      (error) {
        if (kDebugMode) {
          print('Error: $error');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final iconColor = isDarkMode ? Colors.white : Colors.blue;
    final userNameColor = isDarkMode ? Colors.white : Colors.blue;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('User data not found'));
            }

            UserData userData = UserData.fromDocument(snapshot.data!);

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _updateProfilePicture,
                          child: CircleAvatar(
                            radius: 72,
                            backgroundColor: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200],
                            backgroundImage: userData.photoUrl.isNotEmpty
                                ? CachedNetworkImageProvider(userData.photoUrl)
                                : const AssetImage(tAvatar) as ImageProvider,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isDarkMode ? Colors.grey[600] : Colors.blue,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _updateProfilePicture,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      userData.fullName,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: userNameColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      userData.address,
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              isDarkMode ? Colors.white70 : Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? const Color(0xFF333333)
                              : Colors.blue,
                          shape: const StadiumBorder(),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateProfileScreen(userData: userData),
                            ),
                          );
                        },
                        child: const Text(
                          'Editar Perfil',
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(
                      title: 'Configurações',
                      icon: LineAwesomeIcons.cog_solid,
                      iconColor: iconColor,
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
                      title: 'Gerenciamento de usuários',
                      icon: LineAwesomeIcons.user_check_solid,
                      iconColor: iconColor,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserManagementScreen(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuWidget(
                      title: 'Info',
                      icon: LineAwesomeIcons.info_solid,
                      iconColor: iconColor,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InfoScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        drawer: const NavBar(),
      ),
    );
  }
}
