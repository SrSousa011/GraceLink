import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/user_Profile/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

const String tEditProfile = 'Edit Profile'; // Example button text
const double tDefaultSize = 16.0; // Define a default size
const double tFormHeight = 20.0; // Example form field height
const String tFullName = 'Full Name'; // Example label text
const String tEmail = 'Email'; // Example label text
const String tPhoneNo = 'Phone Number'; // Example label text
const String tPassword = 'Password'; // Example label text
const String tJoined = 'Joined '; // Example text for joined
const String tJoinedAt = '25 Jan 2022'; // Example date
const String tDelete = 'Delete'; // Example delete button text

const Color tPrimaryColor = Colors.blue; // Example primary color
const Color tDarkColor = Colors.white; // Example dark color

class UpdateProfileScreen extends StatefulWidget {
  final UserData userData;

  const UpdateProfileScreen({super.key, required this.userData});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.userData.fullName);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveProfileChanges() {
    String fullName = _fullNameController.text;
    String email = _emailController.text;
    String phoneNo = _phoneNoController.text;
    String password = _passwordController.text;

    // Instantiate the service class
    UserProfileService userProfileService = UserProfileService();

    // Call the method to update user profile
    userProfileService
        .updateUserProfile(fullName, email, phoneNo, password)
        .then((_) {
      // Show a SnackBar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }).catchError((error) {
      // Handle error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          tEditProfile,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Stack(
              children: [
                // Your stack content here
              ],
            ),
            const SizedBox(height: 50),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: tFullName,
                      prefixIcon: Icon(LineAwesomeIcons.user),
                    ),
                  ),
                  const SizedBox(height: tFormHeight - 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: tEmail,
                      prefixIcon: Icon(LineAwesomeIcons.envelope_solid),
                    ),
                  ),
                  const SizedBox(height: tFormHeight - 20),
                  TextFormField(
                    controller: _phoneNoController,
                    decoration: const InputDecoration(
                      labelText: tPhoneNo,
                      prefixIcon: Icon(LineAwesomeIcons.phone_alt_solid),
                    ),
                  ),
                  const SizedBox(height: tFormHeight - 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: tPassword,
                      prefixIcon: Icon(Icons.fingerprint),
                    ),
                  ),
                  const SizedBox(height: tFormHeight),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfileChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tPrimaryColor,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        tEditProfile,
                        style: TextStyle(color: tDarkColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: tFormHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text.rich(
                        TextSpan(
                          text: tJoined,
                          style: TextStyle(fontSize: 12),
                          children: [
                            TextSpan(
                              text: tJoinedAt,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement delete logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          elevation: 0,
                          foregroundColor: Colors.red,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(tDelete),
                      ),
                    ],
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
