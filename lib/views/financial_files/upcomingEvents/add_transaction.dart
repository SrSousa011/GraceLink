import 'package:churchapp/views/financial_files/upcomingEvents/upcoming_event.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedType;
  String? _selectedCategory;
  File? _selectedFile;
  String? _errorMessage;
  DateTime? _selectedDate;

  final List<String> _incomeCategories = [
    'Eventos',
    'Campanhas',
    'Subsídios e Apoios',
    'Rendimentos de Ofertas Especiais',
    'Outras Receitas'
  ];

  final List<String> _expenseCategories = [
    'Salários',
    'Serviços',
    'Manutenção',
    'Despesas Gerais',
    'Ajuda e Beneficência'
  ];

  Future<void> _selectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _errorMessage = null;
      });
    } else {
      setState(() {
        _errorMessage = 'File selection canceled or invalid file type.';
      });
    }
  }

  Future<String?> _uploadFile(String transactionId) async {
    if (_selectedFile == null) {
      setState(() {
        _errorMessage = 'Select a file first.';
      });
      return null;
    }

    try {
      final String fileName = _selectedFile!.uri.pathSegments.last;
      final Reference ref =
          FirebaseStorage.instance.ref('financial_files/$fileName');
      await ref.putFile(_selectedFile!);
      final String fileUrl = await ref.getDownloadURL();
      return fileUrl;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error uploading file: $e';
      });
      return null;
    }
  }

  Future<void> _addTransaction() async {
    if (_sourceController.text.isEmpty ||
        _selectedType == null ||
        _referenceController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedDate == null) {
      _showErrorDialog(context, 'Erro ao salvar transação',
          'Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    const uuid = Uuid();
    final String transactionId = uuid.v4();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    final newTransaction = {
      'transactionId': transactionId,
      'source': _sourceController.text,
      'category': _selectedCategory,
      'internal_category': _referenceController.text,
      'type': _selectedType,
      'amount': double.tryParse(_amountController.text),
      'description': _descriptionController.text,
      'createdBy': userId,
      'transactionDate': _selectedDate,
    };

    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .set(newTransaction);

      final fileUrl = await _uploadFile(transactionId);

      if (fileUrl != null) {
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(transactionId)
            .update({'filePath': fileUrl});
      }

      if (!mounted) return;
      _showSuccessDialog(context, 'Transação adicionada com sucesso!');
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const UpcomingEventsScreen()),
          (route) => false,
        );
      });
    } catch (e) {
      _showErrorDialog(context, 'Erro ao salvar transação',
          'Ocorreu um erro ao tentar salvar a transação: ${e.toString()}');
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(message),
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

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  List<String> _getCategories() {
    if (_selectedType == 'Rendimento') {
      return _incomeCategories;
    } else if (_selectedType == 'Despesa') {
      return _expenseCategories;
    }
    return [];
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isDarkMode = false,
      TextInputType? keyboardType,
      GestureTapCallback? onTap}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      onTap: onTap,
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> options, bool isDarkMode, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style:
                  TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildFileSelector({bool isDarkMode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedFile != null)
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              _selectedFile!.uri.pathSegments.last,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ElevatedButton(
          onPressed: _selectFile,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isDarkMode ? Colors.blueGrey[700]! : Colors.blue,
          ),
          child: const Text('Arquivo'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Transação'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: isDarkMode
            ? Colors.blueGrey[900]
            : const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(
                'Título', _sourceController, Icons.account_balance_wallet,
                isDarkMode: isDarkMode),
            const SizedBox(height: 16.0),
            _buildDropdownField(
                'Tipo', _selectedType, ['Rendimento', 'Despesa'], isDarkMode,
                (value) {
              setState(() {
                _selectedType = value;
                _selectedCategory = null;
              });
            }),
            const SizedBox(height: 16.0),
            if (_selectedType != null)
              _buildDropdownField(
                  'Categoria', _selectedCategory, _getCategories(), isDarkMode,
                  (value) {
                setState(() {
                  _selectedCategory = value;
                });
              }),
            const SizedBox(height: 16.0),
            _buildTextField('Referência', _referenceController, Icons.label,
                isDarkMode: isDarkMode),
            const SizedBox(height: 16.0),
            _buildTextField('Valor', _amountController, Icons.monetization_on,
                isDarkMode: isDarkMode, keyboardType: TextInputType.number),
            const SizedBox(height: 16.0),
            _buildTextField(
                'Descrição', _descriptionController, Icons.description,
                isDarkMode: isDarkMode),
            const SizedBox(height: 16.0),
            _buildTextField('Data', _dateController, Icons.date_range,
                isDarkMode: isDarkMode, onTap: _selectDate),
            const SizedBox(height: 16.0),
            _buildFileSelector(isDarkMode: isDarkMode),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16.0),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16.0),
              ),
            ],
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addTransaction,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    isDarkMode ? Colors.blueGrey[700]! : Colors.blue,
              ),
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
