import 'package:churchapp/views/notifications/notification_become_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String selectedCivilStatus = 'Solteiro(a)';
  String selectedGender = 'Masculino';
  DateTime _birthDate = DateTime.now();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _lastVisitedChurchController = TextEditingController();
    _reasonForMembershipController = TextEditingController();
    _referenceController = TextEditingController();
  }

  Future<void> _validateAndSubmit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Erro', 'Usuário não autenticado.');
        return;
      }

      try {
        // Save new member data
        await FirebaseFirestore.instance.collection('members').add({
          'fullName': _fullNameController.text,
          'address': _addressController.text,
          'phoneNumber': _phoneNumberController.text,
          'birthDate': _birthDate,
          'lastVisitedChurch': _lastVisitedChurchController.text,
          'reasonForMembership': _reasonForMembershipController.text,
          'reference': _referenceController.text,
          'civilStatus': selectedCivilStatus,
          'gender': selectedGender,
          'membershipDate': DateTime.now(),
          'createdById': userId,
        });

        // Notify admin
        await _notifyAdmin(_fullNameController.text);

        // Clear fields and show success dialog
        _clearFields();
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sucesso'),
                content: const Text('Cadastro realizado com sucesso!'),
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
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          _showErrorDialog('Erro', 'Falha ao cadastrar membro: $e');
        }
      }
    }
  }

  Future<void> _notifyAdmin(String memberName) async {
    await _notificationService.sendAdminNotification(memberName);
  }

  void _clearFields() {
    _fullNameController.clear();
    _addressController.clear();
    _phoneNumberController.clear();
    _lastVisitedChurchController.clear();
    _reasonForMembershipController.clear();
    _referenceController.clear();
    selectedCivilStatus = 'Solteiro(a)';
    selectedGender = 'Masculino';
    _birthDate = DateTime.now();
  }

  void _showErrorDialog(String title, String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _lastVisitedChurchController.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_fullNameController, 'Nome Completo'),
                const SizedBox(height: 20.0),
                _buildTextField(
                    _lastVisitedChurchController, 'Última Igreja Visitada'),
                const SizedBox(height: 20.0),
                _buildTextField(_reasonForMembershipController,
                    'Razão para Tornar-se Membro'),
                const SizedBox(height: 20.0),
                _buildTextField(
                    _referenceController, 'Referência de um Membro Atual'),
                const SizedBox(height: 20.0),
                _buildDropdownField('Estado Civil', selectedCivilStatus, [
                  'Solteiro(a)',
                  'Casado(a)',
                  'Divorciado(a)',
                  'Viúvo(a)'
                ], (value) {
                  setState(() {
                    selectedCivilStatus = value!;
                  });
                }),
                const SizedBox(height: 20.0),
                _buildDropdownField('Gênero', selectedGender,
                    ['Masculino', 'Feminino', 'Outro'], (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                }),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 90, 175, 249),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Enviar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo não pode estar vazio';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, String selectedValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
