import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/user_Profile/inof_scree.dart';
import 'package:churchapp/views/user_Profile/user_management_scree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/user_Profile/update_profile.dart';
import 'package:churchapp/views/user_Profile/profile_menu.dart';
import 'package:churchapp/views/user_Profile/settings/settings.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'user_management_screen.dart'; // Import the new screens
import 'info_screen.dart';

const String tAvatar = 'assets/imagens/default_avatar.png';
const Color tPrimaryColor = Colors.blue;

class ProfileScreen extends StatefulWidget {
  final UserData userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  late User _user;
  late UserData _userData;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _userData = widget.userData;
    _imageUrl = _userData.imagePath;
  }

  Future<void> _updateProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      try {
        UploadTask uploadTask = _storage
            .ref()
            .child('userProfilePictures/${_user.uid}/profilePicture.jpg')
            .putFile(file);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        await _firestore
            .collection('users')
            .doc(_user.uid)
            .update({'imagePath': downloadURL});
        setState(() {
          _imageUrl = downloadURL;
        });
      } catch (e) {
        if (kDebugMode) {
          print("Error uploading image: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: _updateProfilePicture,
              child: CircleAvatar(
                radius: 72,
                backgroundColor: Colors.grey[200],
                backgroundImage: _imageUrl != null
                    ? CachedNetworkImageProvider(_imageUrl!)
                    : const AssetImage(tAvatar) as ImageProvider,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _userData.fullName,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              _userData.address,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
      ),
    );
  }
}
