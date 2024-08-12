import 'package:churchapp/views/member/become_member_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';

class BecomeMember extends StatefulWidget {
  const BecomeMember({super.key});

  @override
  State<BecomeMember> createState() => _BecomeMemberState();
}

class _BecomeMemberState extends State<BecomeMember> {
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _lastVisitedChurchController;
  late TextEditingController _reasonForMembershipController;
  late TextEditingController _referenceController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String selectedCivilStatus = 'Single';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
    _lastVisitedChurchController = TextEditingController();
    _reasonForMembershipController = TextEditingController();
    _referenceController = TextEditingController();

    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userId = AuthenticationService().getCurrentUserId();
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId as String?)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          setState(() {
            _fullNameController.text = userData['fullName'] ?? '';
            _addressController.text = userData['address'] ?? '';
            _lastVisitedChurchController.text =
                userData['lastVisitedChurch'] ?? '';
            _reasonForMembershipController.text =
                userData['reasonForMembership'] ?? '';
            _referenceController.text = userData['reference'] ?? '';
            selectedCivilStatus = userData['civilStatus'] ?? 'Single';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _lastVisitedChurchController.dispose();
    _reasonForMembershipController.dispose();
    _referenceController.dispose();
    super.dispose();
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
          title: const Text('Become a Member'),
        ),
        drawer: NavBar(
          auth: AuthenticationService(),
          authService: AuthenticationService(),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFullNameSection(),
                    const SizedBox(height: 20.0),
                    _buildLastVisitedChurchSection(),
                    const SizedBox(height: 20.0),
                    _buildCivilStatusSection(),
                    const SizedBox(height: 20.0),
                    _buildAddressSection(),
                    const SizedBox(height: 20.0),
                    _buildReasonForMembershipSection(),
                    const SizedBox(height: 20.0),
                    _buildReferenceSection(),
                    const SizedBox(height: 20.0),
                    _buildSignUpButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameSection() {
    return TextFormField(
      controller: _fullNameController,
      decoration: const InputDecoration(
        labelText: 'Full Name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Full name cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildAddressSection() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Address',
      ),
    );
  }

  Widget _buildLastVisitedChurchSection() {
    return TextFormField(
      controller: _lastVisitedChurchController,
      decoration: const InputDecoration(
        labelText: 'Last Visited Church',
      ),
    );
  }

  Widget _buildReasonForMembershipSection() {
    return TextFormField(
      controller: _reasonForMembershipController,
      decoration: const InputDecoration(
        labelText: 'Reason for Membership',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Reason for membership cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildReferenceSection() {
    return TextFormField(
      controller: _referenceController,
      decoration: const InputDecoration(
        labelText: 'Reference from Current Member',
      ),
    );
  }

  Widget _buildCivilStatusSection() {
    return DropdownButtonFormField<String>(
      value: selectedCivilStatus,
      onChanged: (value) {
        setState(() {
          selectedCivilStatus = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 'Single', child: Text('Single')),
        DropdownMenuItem(value: 'Married', child: Text('Married')),
        DropdownMenuItem(value: 'Divorced', child: Text('Divorced')),
        DropdownMenuItem(value: 'Widowed', child: Text('Widowed')),
      ],
      decoration: const InputDecoration(
        labelText: 'Civil Status',
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _validateAndSubmit,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 90, 175, 249),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child:
          _isLoading ? const CircularProgressIndicator() : const Text('Submit'),
    );
  }

  Future<void> _validateAndSubmit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      setState(() {
        _isLoading = true;
      });

      final becomeMemberService = BecomeMemberService();

      try {
        await becomeMemberService.addMember(
          fullName: _fullNameController.text,
          address: _addressController.text,
          lastVisitedChurch: _lastVisitedChurchController.text,
          reasonForMembership: _reasonForMembershipController.text,
          reference: _referenceController.text,
          civilStatus: selectedCivilStatus,
          membershipDate: DateTime.now(), // Adiciona a data atual
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        // Limpar os campos do formulário
        _fullNameController.clear();
        _addressController.clear();
        _lastVisitedChurchController.clear();
        _reasonForMembershipController.clear();
        _referenceController.clear();
        setState(() {
          selectedCivilStatus = 'Single';
        });

        // Mostrar o diálogo de sucesso
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text(
                  'You have successfully submitted your information!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar o diálogo
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        if (!mounted) return; // Check if the widget is still mounted

        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to submit your information: $e'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
