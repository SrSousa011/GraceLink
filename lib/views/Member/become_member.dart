import 'package:churchapp/views/member/become_member_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/auth/auth_service.dart';

class BecomeMember extends StatefulWidget {
  const BecomeMember({super.key});

  @override
  State<BecomeMember> createState() => _BecomeMemberState();
}

class _BecomeMemberState extends State<BecomeMember> {
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _lastVisitedChurchController;
  late TextEditingController _reasonForMembershipController;
  late TextEditingController _referenceController;
  String? _imagePath;
  String? _dateOfBirth;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String selectedCivilStatus = 'Solteiro(a)';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = TextEditingController();
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
            _phoneNumberController.text = userData['phoneNumber'] ?? '';
            _imagePath = userData['imagePath'];
            _dateOfBirth = userData['dateOfBirth'];
            selectedCivilStatus = userData['civilStatus'] ?? 'Solteiro(a)';
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar dados do usuário: $e');
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _reasonForMembershipController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tornar-se Membro'),
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
                  if (_imagePath != null) _buildProfileImageSection(),
                  const SizedBox(height: 20.0),
                  _buildFullNameSection(),
                  const SizedBox(height: 20.0),
                  if (_dateOfBirth != null) _buildDateOfBirthSection(),
                  const SizedBox(height: 20.0),
                  _buildCivilStatusSection(),
                  const SizedBox(height: 20.0),
                  _buildLastVisitedChurchSection(),
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
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(_imagePath!),
      ),
    );
  }

  Widget _buildFullNameSection() {
    return TextFormField(
      controller: _fullNameController,
      decoration: const InputDecoration(
        labelText: 'Nome Completo',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'O nome completo não pode estar vazio';
        }
        return null;
      },
    );
  }

  Widget _buildDateOfBirthSection() {
    return Text(
      'Data de Nascimento: $_dateOfBirth',
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildLastVisitedChurchSection() {
    return TextFormField(
      controller: _lastVisitedChurchController,
      decoration: const InputDecoration(
        labelText: 'Última igreja visitada',
      ),
    );
  }

  Widget _buildReasonForMembershipSection() {
    return TextFormField(
      controller: _reasonForMembershipController,
      decoration: const InputDecoration(
        labelText: 'Razão para Tornar-se Membro',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'A razão para tornar-se membro não pode estar vazia';
        }
        return null;
      },
    );
  }

  Widget _buildReferenceSection() {
    return TextFormField(
      controller: _referenceController,
      decoration: const InputDecoration(
        labelText: 'Referência de um Membro Atual',
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
        DropdownMenuItem(value: 'Solteiro(a)', child: Text('Solteiro(a)')),
        DropdownMenuItem(value: 'Casado(a)', child: Text('Casado(a)')),
        DropdownMenuItem(value: 'Divorciado(a)', child: Text('Divorciado(a)')),
        DropdownMenuItem(value: 'Viúvo(a)', child: Text('Viúvo(a)')),
      ],
      decoration: const InputDecoration(
        labelText: 'Estado Civil',
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
          _isLoading ? const CircularProgressIndicator() : const Text('Enviar'),
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
          address: _addressController.text.isNotEmpty
              ? _addressController.text
              : null,
          phoneNumber: _phoneNumberController.text.isNotEmpty
              ? _phoneNumberController.text
              : null,
          reasonForMembership: _reasonForMembershipController.text,
          reference: _referenceController.text.isNotEmpty
              ? _referenceController.text
              : null,
          civilStatus: selectedCivilStatus,
          membershipDate: DateTime.now(),
          lastVisitedChurch: _lastVisitedChurchController.text,
          dateOfBirth: _dateOfBirth,
          imagePath: _imagePath,
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        _fullNameController.clear();
        _addressController.clear();
        _phoneNumberController.clear();
        _reasonForMembershipController.clear();
        _referenceController.clear();
        setState(() {
          selectedCivilStatus = 'Solteiro(a)';
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sucesso'),
              content:
                  const Text('As suas informações foram enviadas com sucesso!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: Text('Falha ao enviar as suas informações: $e'),
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
