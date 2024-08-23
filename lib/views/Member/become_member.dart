import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/views/member/become_member_service.dart';

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
  late AuthenticationService _authenticationService;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String selectedCivilStatus = 'Solteiro(a)';
  String selectedGender = 'Masculino';
  DateTime _birthDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _lastVisitedChurchController = TextEditingController();
    _reasonForMembershipController = TextEditingController();
    _referenceController = TextEditingController();
    _authenticationService = AuthenticationService();

    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userId = await _authenticationService.getCurrentUserId();

    if (userId == null) {
      if (mounted) {
        _showErrorDialog(
          context,
          'Erro ao obter ID do usuário',
          'Não foi possível obter o ID do usuário.',
        );
      }
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          if (mounted) {
            setState(() {
              _fullNameController.text = userData['fullName'] ?? '';
              _addressController.text = userData['address'] ?? '';
              _phoneNumberController.text = userData['phoneNumber'] ?? '';
              _lastVisitedChurchController.text =
                  userData['lastVisitedChurch'] ?? '';
              _reasonForMembershipController.text =
                  userData['reasonForMembership'] ?? '';
              _referenceController.text = userData['reference'] ?? '';
              selectedCivilStatus = userData['civilStatus'] ?? 'Solteiro(a)';
              selectedGender = userData['gender'] ?? 'Masculino';
              _birthDate = (userData['dateOfBirth'] as Timestamp).toDate();
            });
          }
        } else {
          if (mounted) {
            _showErrorDialog(
              context,
              'Dados não encontrados',
              'Nenhum dado encontrado para o usuário.',
            );
          }
        }
      } else {
        if (mounted) {
          _showErrorDialog(
            context,
            'Documento não encontrado',
            'O documento do usuário não foi encontrado.',
          );
        }
      }
    } catch (e) {
      if (mounted) {}
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
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

  Future<void> _validateAndSubmit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      setState(() {
        _isLoading = true;
      });

      final becomeMemberService = BecomeMemberService();
      final userId = await _authenticationService.getCurrentUserId();

      if (userId == null) {
        if (mounted) {
          _showErrorDialog(
            context,
            'Erro ao salvar evento',
            'Não foi possível obter o ID do usuário.',
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        await becomeMemberService.addMember(
          fullName: _fullNameController.text,
          address:
              _addressController.text.isEmpty ? null : _addressController.text,
          phoneNumber: _phoneNumberController.text.isEmpty
              ? null
              : _phoneNumberController.text,
          birthDate: _birthDate,
          lastVisitedChurch: _lastVisitedChurchController.text.isEmpty
              ? null
              : _lastVisitedChurchController.text,
          reasonForMembership: _reasonForMembershipController.text,
          reference: _referenceController.text.isEmpty
              ? null
              : _referenceController.text,
          civilStatus: selectedCivilStatus,
          gender: selectedGender,
          membershipDate: DateTime.now(),
          createdById: userId,
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          _fullNameController.clear();
          _addressController.clear();
          _phoneNumberController.clear();
          _lastVisitedChurchController.clear();
          _reasonForMembershipController.clear();
          _referenceController.clear();
          selectedCivilStatus = 'Solteiro(a)';
          selectedGender = 'Masculino';
          _birthDate = DateTime.now();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sucesso'),
                content: const Text(
                    'As suas informações foram enviadas com sucesso!'),
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
                  _buildReasonForMembershipSection(),
                  const SizedBox(height: 20.0),
                  _buildReferenceSection(),
                  const SizedBox(height: 20.0),
                  _buildCivilStatusSection(),
                  const SizedBox(height: 20.0),
                  _buildGenderSection(),
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

  Widget _buildAddressSection() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Endereço',
      ),
    );
  }

  Widget _buildPhoneNumberSection() {
    return TextFormField(
      controller: _phoneNumberController,
      decoration: const InputDecoration(
        labelText: 'Número de Telefone',
      ),
    );
  }

  Widget _buildLastVisitedChurchSection() {
    return TextFormField(
      controller: _lastVisitedChurchController,
      decoration: const InputDecoration(
        labelText: 'Última Igreja Visitada',
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

  Widget _buildGenderSection() {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      onChanged: (value) {
        setState(() {
          selectedGender = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
        DropdownMenuItem(value: 'Outro', child: Text('Outro')),
      ],
      decoration: const InputDecoration(
        labelText: 'Gênero',
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
}
