import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/views/user_Profile/editProfile/user_profile_service.dart';
import 'package:churchapp/views/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

const String tEditProfile = 'Editar Perfil';
const double tDefaultSize = 16.0;
const double tFormHeight = 20.0;
const String tFullName = 'Nome completo';
const String tAddress = 'Endereço';
const String tJoined = 'Joined ';
const String tJoinedAt = '25 Jan 2022';
const String tDelete = 'Delete';

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
    _addressController = TextEditingController(text: widget.userData.address);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfileChanges() {
    String fullName = _fullNameController.text;
    String address = _addressController.text;

    UserProfileService userProfileService = UserProfileService();

    userProfileService
        .updateUserProfile(widget.userData.userId, fullName, address)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            userData: UserData(
              userId: widget.userData.userId,
              fullName: fullName,
              address: address,
              imagePath: widget.userData.imagePath,
            ),
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    });
  }

  void _clearFields() {
    setState(() {
      _fullNameController.clear();
      _addressController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor =
        theme.brightness == Brightness.light ? Colors.blue : Colors.grey;

    final Color buttonTextColor =
        theme.brightness == Brightness.light ? Colors.white : Colors.black;

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
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: tAddress,
                      prefixIcon: Icon(LineAwesomeIcons.envelope_solid),
                    ),
                  ),
                  const SizedBox(height: tFormHeight),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfileChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        tEditProfile,
                        style: TextStyle(color: buttonTextColor),
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
                        onPressed: _clearFields,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.brightness == Brightness.light
                              ? Colors.redAccent.withOpacity(0.1)
                              : Colors.grey,
                          elevation: 0,
                          foregroundColor: theme.brightness == Brightness.light
                              ? Colors.red
                              : Colors.black,
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
