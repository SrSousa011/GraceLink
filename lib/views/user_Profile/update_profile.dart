import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/user_Profile/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

const String tEditProfile = 'Edit Profile';
const double tDefaultSize = 16.0;
const double tFormHeight = 20.0;
const String tFullName = 'Full Name';
const String tAddress = 'Address'; // Atualizado de 'Bio' para 'Address'
const String tJoined = 'Joined ';
const String tJoinedAt = '25 Jan 2022';
const String tDelete = 'Delete';

const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Colors.white;

class UpdateProfileScreen extends StatefulWidget {
  final UserData userData;

  const UpdateProfileScreen({super.key, required this.userData});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.userData.fullName);
    _addressController = TextEditingController(
        text: widget.userData.address); // Inicialize o controlador de endereço
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose(); // Dispose do controlador de endereço
    super.dispose();
  }

  void _saveProfileChanges() {
    String fullName = _fullNameController.text;
    String address = _addressController.text; // Use address em vez de bio

    // Instantiate the service class
    UserProfileService userProfileService = UserProfileService();

    // Call the method to update user profile
    userProfileService
        .updateUserProfile(widget.userData.id, fullName, address)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }).catchError((error) {
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
                    controller:
                        _addressController, // Use o controlador para endereço
                    decoration: const InputDecoration(
                      labelText: tAddress, // Atualizado para endereço
                      prefixIcon: Icon(LineAwesomeIcons.envelope_solid),
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
