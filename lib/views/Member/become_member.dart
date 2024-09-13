import 'package:churchapp/views/member/terms_and_condictions.dart';
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
  late TextEditingController _previousChurchController;
  late TextEditingController _baptismDateController;
  late TextEditingController _conversionDateController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String selectedCivilStatus = 'Solteiro';
  String selectedGender = 'Masculino';
  DateTime _birthDate = DateTime.now();
  bool _hasPreviousChurchExperience = false;
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
    _previousChurchController = TextEditingController();
    _baptismDateController = TextEditingController();
    _conversionDateController = TextEditingController();
  }

  List<String> _getCivilStatusOptions() {
    if (selectedGender == 'Feminino') {
      return ['Solteira', 'Casada', 'Divorciada', 'Viúva'];
    } else {
      return ['Solteiro', 'Casado', 'Divorciado', 'Viúvo'];
    }
  }

  Future<void> _navigateToTermsAndConditions() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TermsAndConditionsScreen(
          onAccept: () {
            _validateAndSubmit();
          },
          onSubmit: () {},
        ),
      ),
    );

    if (result == true) {
      ();
    }
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
          'hasPreviousChurchExperience': _hasPreviousChurchExperience,
          'previousChurch': _previousChurchController.text,
          'baptismDate': _formatDateForFirestore(_baptismDateController.text),
          'conversionDate':
              _formatDateForFirestore(_conversionDateController.text),
        });

        await _notifyAdmin(_fullNameController.text);

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
    _previousChurchController.clear();
    _baptismDateController.clear();
    _conversionDateController.clear();
    selectedCivilStatus = 'Solteiro';
    selectedGender = 'Masculino';
    _birthDate = DateTime.now();
    _hasPreviousChurchExperience = false;
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
    _previousChurchController.dispose();
    _baptismDateController.dispose();
    _conversionDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        controller.text =
            "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";
      });
    }
  }

  String _formatDateForFirestore(String date) {
    final parts = date.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day).toIso8601String();
    }
    return '';
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
                _buildDropdownField('Estado Civil', selectedCivilStatus,
                    _getCivilStatusOptions(), (value) {
                  setState(() {
                    selectedCivilStatus = value!;
                  });
                }),
                const SizedBox(height: 20.0),
                _buildDropdownField(
                    'Gênero', selectedGender, ['Masculino', 'Feminino'],
                    (value) {
                  if (value != null) {
                    setState(() {
                      selectedGender = value;
                      _updateCivilStatus(selectedGender, selectedCivilStatus);
                    });
                  }
                }),
                const SizedBox(height: 20.0),
                _buildYesNoField('Já participou de alguma igreja antes? ',
                    _hasPreviousChurchExperience, (value) {
                  setState(() {
                    _hasPreviousChurchExperience = value;
                  });
                }),
                if (_hasPreviousChurchExperience) ...[
                  const SizedBox(height: 20.0),
                  _buildTextField(_previousChurchController, 'Qual Igreja?'),
                  const SizedBox(height: 20.0),
                  _buildDateField(_baptismDateController, 'Data de Batismo'),
                  const SizedBox(height: 20.0),
                  _buildDateField(
                      _conversionDateController, 'Data de Conversão'),
                ],
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _navigateToTermsAndConditions,
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

  Widget _buildYesNoField(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(label),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _updateCivilStatus(String gender, String maritalStatus) {
    setState(() {
      if (gender == 'Feminino') {
        if (maritalStatus == 'Casado') {
          selectedCivilStatus = 'Casada';
        } else if (maritalStatus == 'Viúvo') {
          selectedCivilStatus = 'Viúva';
        } else {
          selectedCivilStatus = 'Solteira';
        }
      } else if (gender == 'Masculino') {
        if (maritalStatus == 'Casado') {
          selectedCivilStatus = 'Casado';
        } else if (maritalStatus == 'Viúvo') {
          selectedCivilStatus = 'Viúvo';
        } else {
          selectedCivilStatus = 'Solteiro';
        }
      }
    });
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

  Widget _buildDateField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(controller),
        ),
      ),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo não pode estar vazio';
        }
        return null;
      },
    );
  }
}
