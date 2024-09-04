import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';

class AddIncomeForm extends StatefulWidget {
  const AddIncomeForm({super.key});

  @override
  State<AddIncomeForm> createState() => _AddIncomeFormState();
}

class _AddIncomeFormState extends State<AddIncomeForm> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _sourceController; // Updated
  late TextEditingController _categoryController; // Updated
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    _sourceController = TextEditingController(); // Updated
    _categoryController = TextEditingController(); // Updated
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _sourceController.dispose(); // Updated
    _categoryController.dispose(); // Updated
    super.dispose();
  }

  Future<void> _saveIncome(BuildContext context) async {
    if (_amountController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _sourceController.text.isNotEmpty && // Updated
        _categoryController.text.isNotEmpty && // Updated
        _selectedDate != null &&
        _selectedTime != null) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        if (!context.mounted) return;
        _showErrorDialog(context, 'Erro ao salvar entrada',
            'Não foi possível obter o ID do usuário.');
        return;
      }

      final incomeId = DateTime.now().millisecondsSinceEpoch.toString();
      final createdDateTime = DateTime.now();
      DateFormat('dd/MM/yyyy').format(_selectedDate!);

      final newIncome = {
        'id': incomeId,
        'amount': double.tryParse(_amountController.text) ?? 0.0,
        'description': _descriptionController.text,
        'source': _sourceController.text, // Updated
        'category': _categoryController.text, // Updated
        'time': _selectedTime!.format(context),
        'createdBy': userId,
        'createdAt': createdDateTime,
      };

      try {
        await FirebaseFirestore.instance
            .collection('incomes') // Changed to 'incomes' for church income
            .doc(incomeId)
            .set(newIncome);

        if (!context.mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!context.mounted) return;
        _showErrorDialog(context, 'Erro ao salvar entrada',
            'Ocorreu um erro ao tentar salvar a entrada: ${e.toString()}');
      }
    } else {
      _showErrorDialog(context, 'Erro ao salvar entrada',
          'Por favor, preencha todos os campos.');
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Receita'),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                    'Valor', _amountController, Icons.monetization_on,
                    keyboardType: TextInputType.number, isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                _buildTextField(
                    'Descrição', _descriptionController, Icons.description,
                    isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                _buildTextField(
                    'Fonte', _sourceController, Icons.source, // Updated
                    isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                _buildTextField(
                    'Categoria', _categoryController, Icons.category, // Updated
                    isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: _buildSaveButton(isDarkMode: isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text,
      required bool isDarkMode}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(icon, color: isDarkMode ? Colors.white : Colors.blue),
      ),
    );
  }

  Widget _buildSaveButton({required bool isDarkMode}) {
    return ElevatedButton(
      onPressed: () => _saveIncome(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
        minimumSize: const Size(100, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(
        'Adicionar',
        style: TextStyle(
          color: isDarkMode ? Colors.black : Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
