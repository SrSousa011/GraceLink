import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/views/member/terms_and_condictions.dart';
import 'package:churchapp/views/notifications/notification_become_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _baptismDate;
  DateTime? _conversionDate;
  DateTime? _birthDate;

  bool _isLoading = false;
  String selectedCivilStatus = 'Solteiro';
  String selectedGender = 'Masculino';
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
    _loadUserData();
  }

  Future<UserData?> _fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return null;
    }
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (docSnapshot.exists) {
        return UserData.fromDocument(docSnapshot);
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _fetchUserData();

      if (userData != null) {
        setState(() {
          _birthDate = userData.birthDate;
          _addressController.text = userData.address;
          _phoneNumberController.text = userData.phoneNumber ?? '';
        });
      } else {
        if (kDebugMode) {
          print('No user data found.');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  List<String> _getCivilStatusOptions() {
    if (selectedGender == 'Feminino') {
      return ['Solteira', 'Casada', 'Divorciada', 'Viúva'];
    } else {
      return ['Solteiro', 'Casado', 'Divorciado', 'Viúvo'];
    }
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
    if (form!.validate()) {
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
        final memberData = {
          'fullName': _fullNameController.text,
          'address': _addressController.text,
          'phoneNumber': _phoneNumberController.text,
          'birthDate': _birthDate != null
              ? Timestamp.fromDate(_birthDate!)
              : null, // Convert DateTime to Timestamp
          'lastVisitedChurch': _lastVisitedChurchController.text,
          'reasonForMembership': _reasonForMembershipController.text,
          'reference': _referenceController.text,
          'civilStatus': selectedCivilStatus,
          'gender': selectedGender,
          'membershipDate': Timestamp.now(),
          'createdById': userId,
          'hasPreviousChurchExperience': _hasPreviousChurchExperience,
          'previousChurch': _previousChurchController.text,
          'baptismDate': _baptismDate != null
              ? Timestamp.fromDate(_baptismDate!)
              : null, // Convert DateTime to Timestamp
          'conversionDate': _conversionDate != null
              ? Timestamp.fromDate(_conversionDate!)
              : null, // Convert DateTime to Timestamp
        };

        await FirebaseFirestore.instance.collection('members').add(memberData);

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
    _baptismDate = null;
    _conversionDate = null;
    selectedCivilStatus = 'Solteiro';
    selectedGender = 'Masculino';
    _birthDate = null;
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
    super.dispose();
  }

  String _formatDate(DateTime? dateTime) {
    // Update to use DateTime
    if (dateTime == null) {
      return '';
    }
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tornar-se Membro'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Form(
            key: _formKey,
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
                _buildDateField('Data de Batismo', _baptismDate, (newDate) {
                  setState(() {
                    _baptismDate = newDate;
                  });
                }),
                const SizedBox(height: 20.0),
                _buildDateField('Data de Conversão', _conversionDate,
                    (newDate) {
                  setState(() {
                    _conversionDate = newDate;
                  });
                }),
                const SizedBox(height: 20.0),
                _buildDateField('Data de Nascimento', _birthDate, (newDate) {
                  setState(() {
                    _birthDate = newDate;
                  });
                }),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _navigateToTermsAndConditions,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Cadastrar'),
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
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo.';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(
    String label,
    String currentValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(String label, DateTime? dateTime,
      ValueChanged<DateTime?> onDateSelected) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: dateTime ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          _formatDate(dateTime),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
