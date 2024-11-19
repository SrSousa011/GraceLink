import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/views/member/terms_and_condictions.dart';
import 'package:churchapp/views/notifications/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
  final NotificationService _notificationService = NotificationService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasPreviousChurchExperience = false;
  String selectedCivilStatus = 'Solteiro';
  String selectedGender = 'Masculino';
  DateTime? _baptismDate;
  DateTime? _conversionDate;

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
    _notificationService.initialize();
    _notificationService.requestIOSPermissions();
  }

  Future<bool> _navigateToTermsAndConditions() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TermsAndConditionsScreen(
          onAccept: () {},
          onSubmit: () {
            _validateAndSubmit();
          },
        ),
      ),
    );
    return result == true;
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
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        UserData userData = UserData.fromDocument(userDoc);

        if (userData.role == 'admin') {
          final memberData = {
            'fullName': _fullNameController.text,
            'address': userData.address,
            'phoneNumber': userData.phoneNumber,
            'dateOfBirth': userData.dateOfBirth != null
                ? Timestamp.fromDate(userData.dateOfBirth!)
                : null,
            'lastVisitedChurch': _lastVisitedChurchController.text,
            'reasonForMembership': _reasonForMembershipController.text,
            'reference': _referenceController.text,
            'civilStatus': selectedCivilStatus,
            'gender': selectedGender,
            'membershipDate': Timestamp.now(),
            'createdById': userId,
            'hasPreviousChurchExperience': _hasPreviousChurchExperience,
            'previousChurch': _previousChurchController.text.isNotEmpty
                ? _previousChurchController.text
                : null,
            'baptismDate':
                _baptismDate != null ? Timestamp.fromDate(_baptismDate!) : null,
            'conversionDate': _conversionDate != null
                ? Timestamp.fromDate(_conversionDate!)
                : null,
          };

          await FirebaseFirestore.instance
              .collection('members')
              .add(memberData);

          String memberName = _fullNameController.text;

          await NotificationService().showNotification(
              title: 'Novo Membro Se Cadastrou!',
              body:
                  '$memberName agora é um membro da nossa comunidade! Clique aqui para ver mais detalhes',
              payload: 'become_member');

          _clearFields();

          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            _showSuccessDialog();
          }
        } else {
          final memberData = {
            'fullName': _fullNameController.text,
            'address': userData.address,
            'phoneNumber': userData.phoneNumber,
            'dateOfBirth': userData.dateOfBirth != null
                ? Timestamp.fromDate(userData.dateOfBirth!)
                : null,
            'lastVisitedChurch': _lastVisitedChurchController.text,
            'reasonForMembership': _reasonForMembershipController.text,
            'reference': _referenceController.text,
            'civilStatus': selectedCivilStatus,
            'gender': selectedGender,
            'membershipDate': Timestamp.now(),
            'createdById': userId,
            'hasPreviousChurchExperience': _hasPreviousChurchExperience,
            'previousChurch': _previousChurchController.text.isNotEmpty
                ? _previousChurchController.text
                : null,
            'baptismDate':
                _baptismDate != null ? Timestamp.fromDate(_baptismDate!) : null,
            'conversionDate': _conversionDate != null
                ? Timestamp.fromDate(_conversionDate!)
                : null,
          };

          await FirebaseFirestore.instance
              .collection('members')
              .add(memberData);

          _clearFields();

          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            _showSuccessDialog();
          }
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

  void _clearFields() {
    _fullNameController.clear();
    _addressController.clear();
    _phoneNumberController.clear();
    _lastVisitedChurchController.clear();
    _reasonForMembershipController.clear();
    _referenceController.clear();
    _previousChurchController.clear();
    _baptismDate = null;
    _conversionDate = null;
    selectedCivilStatus = 'Solteiro';
    selectedGender = 'Masculino';
    _hasPreviousChurchExperience = false;
  }

  void _updateCivilStatus(String gender) {
    setState(() {
      if (gender == 'Feminino') {
        if (!['Casada', 'Solteira', 'Divorciada', 'Viúva']
            .contains(selectedCivilStatus)) {
          selectedCivilStatus = 'Solteira';
        }
      } else {
        if (!['Casado', 'Solteiro', 'Divorciado', 'Viúvo']
            .contains(selectedCivilStatus)) {
          selectedCivilStatus = 'Solteiro';
        }
      }
    });
  }

  void _showErrorDialog(String title, String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: const TextStyle(fontSize: 15)),
            content: Text(message, style: const TextStyle(fontSize: 15)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(fontSize: 15)),
              ),
            ],
          );
        },
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso', style: TextStyle(fontSize: 17)),
          content: const Text('Cadastro realizado com sucesso!',
              style: TextStyle(fontSize: 17)),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(fontSize: 17)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tornar-se Membro',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
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
                      _updateCivilStatus(selectedGender);
                    });
                  }
                }),
                const SizedBox(height: 20.0),
                CheckboxListTile(
                  title: const Text('Tem experiência anterior em outra igreja?',
                      style: TextStyle(fontSize: 15)),
                  value: _hasPreviousChurchExperience,
                  onChanged: (bool? value) {
                    setState(() {
                      _hasPreviousChurchExperience = value ?? false;
                    });
                  },
                ),
                if (_hasPreviousChurchExperience) ...[
                  _buildTextField(_previousChurchController, 'Igreja Anterior'),
                  const SizedBox(height: 20.0),
                  _buildDateField('Data do Batismo', _baptismDate, (date) {
                    setState(() {
                      _baptismDate = date;
                    });
                  }),
                  const SizedBox(height: 20.0),
                  _buildDateField('Data da Conversão', _conversionDate, (date) {
                    setState(() {
                      _conversionDate = date;
                    });
                  }),
                ],
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await _navigateToTermsAndConditions();
                        },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 90, 175, 249),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Enviar', style: TextStyle(fontSize: 15)),
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
        labelStyle: const TextStyle(fontSize: 15),
      ),
      style: const TextStyle(fontSize: 15),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo não pode estar vazio';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(String label, DateTime? selectedDate,
      ValueChanged<DateTime?> onDateSelected) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: selectedDate != null
                ? DateFormat('dd/MM/yyyy').format(selectedDate)
                : label,
            labelStyle: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String selectedValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 15))))
          .toList(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 15),
      ),
    );
  }

  List<String> _getCivilStatusOptions() {
    return selectedGender == 'Feminino'
        ? ['Casada', 'Solteira', 'Divorciada', 'Viúva']
        : ['Casado', 'Solteiro', 'Divorciado', 'Viúvo'];
  }
}
