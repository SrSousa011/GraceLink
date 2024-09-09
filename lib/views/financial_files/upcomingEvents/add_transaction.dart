import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _sourceController;
  late TextEditingController _referenceController;
  String _selectedCategory = 'income';
  String _selectedType = 'Doação';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _filePath = '';
  final Uuid uuid = const Uuid();
  final _currencyFormatter = NumberFormat.currency(locale: 'eu', symbol: '€');

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    _sourceController = TextEditingController();
    _referenceController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _sourceController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction(BuildContext context) async {
    final amountText = _amountController.text;
    final sourceText = _sourceController.text;

    if (amountText.isNotEmpty && sourceText.isNotEmpty) {
      final double? amount = double.tryParse(
        amountText.replaceAll('€', '').replaceAll('.', '').replaceAll(',', '.'),
      );

      if (amount == null || amount <= 0) {
        _showErrorDialog(context, 'Erro ao salvar transação',
            'O valor inserido não é válido.');
        return;
      }

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _showErrorDialog(context, 'Erro ao salvar transação',
            'Não foi possível obter o ID do usuário.');
        return;
      }

      final transactionId = uuid.v4();
      final createdDateTime = DateTime.now();
      final formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
      final formattedTime = _selectedTime.format(context);

      final newTransaction = {
        'transactionId': transactionId,
        'amount': amount,
        'description': _descriptionController.text,
        'source': _sourceController.text,
        'reference': _referenceController.text,
        'category': _selectedCategory,
        'type': _selectedType,
        'date': formattedDate,
        'time': formattedTime,
        'createdBy': userId,
        'createdAt': createdDateTime,
        'filePath': _filePath,
      };

      try {
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(transactionId)
            .set(newTransaction);

        _showSuccessDialog(context, 'Transação adicionada com sucesso!');
      } catch (e) {
        _showErrorDialog(context, 'Erro ao salvar transação',
            'Ocorreu um erro ao tentar salvar a transação: ${e.toString()}');
      }
    } else {
      _showErrorDialog(context, 'Erro ao salvar transação',
          'Por favor, preencha todos os campos obrigatórios.');
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

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _filePath = result.files.single.path ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Transação'),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Fonte', _sourceController, Icons.source,
                    isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                _buildDropdownField('Categoria', _selectedCategory,
                    ['income', 'expense'], isDarkMode),
                const SizedBox(height: 20.0),
                _buildTextField(
                    'Categoria Interna', _referenceController, Icons.category,
                    isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                _buildDropdownField('Tipo de Transação', _selectedType,
                    _getTransactionTypes(), isDarkMode),
                _buildTextField('Valor', _amountController, Icons.money,
                    keyboardType: TextInputType.number, isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                _buildTextField('Descrição (Opcional)', _descriptionController,
                    Icons.description,
                    isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                _buildDatePicker(context),
                const SizedBox(height: 20.0),
                _buildTimePicker(context),
                const SizedBox(height: 20.0),
                _buildFilePicker(),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
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
      inputFormatters: labelText.contains('Valor')
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                if (text.isEmpty) return newValue;
                double value = double.parse(text) / 100;
                String formattedValue = _currencyFormatter.format(value);
                return TextEditingValue(
                  text: formattedValue,
                  selection:
                      TextSelection.collapsed(offset: formattedValue.length),
                );
              }),
            ]
          : null,
    );
  }

  Widget _buildDropdownField(String labelText, String selectedValue,
      List<String> options, bool isDarkMode) {
    return DropdownButtonFormField<String>(
      value: options.contains(selectedValue) ? selectedValue : null,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(Icons.label, color: isDarkMode ? Colors.white : Colors.blue),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          if (labelText == 'Categoria') {
            _selectedCategory = newValue!;
            _updateSelectedType();
          } else {
            _selectedType = newValue!;
          }
        });
      },
    );
  }

  List<String> _getTransactionTypes() {
    if (_selectedCategory == 'income') {
      return ['Doações Especiais', 'Venda', 'Eventos de Arrecadação', 'Outro'];
    } else {
      return ['Despesas Gerais', 'Salários', 'Manutenção', 'Serviços'];
    }
  }

  void _updateSelectedType() {
    if (_selectedCategory == 'income') {
      _selectedType = 'Doações Especiais';
    } else {
      _selectedType = 'Despesas Gerais';
    }
  }

  Widget _buildDatePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:
              Text('Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null && pickedDate != _selectedDate) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('Hora: ${_selectedTime.format(context)}'),
        ),
        IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: _selectedTime,
            );
            if (pickedTime != null && pickedTime != _selectedTime) {
              setState(() {
                _selectedTime = pickedTime;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Row(
      children: [
        const Text('Anexar arquivo:'),
        const SizedBox(width: 10.0),
        ElevatedButton.icon(
          onPressed: _pickFile,
          icon: const Icon(Icons.attach_file),
          label: const Text('Escolher Arquivo'),
        ),
        const SizedBox(width: 10.0),
        if (_filePath.isNotEmpty) Text('Arquivo: ${_filePath.split('/').last}'),
      ],
    );
  }

  Widget _buildSaveButton({required bool isDarkMode}) {
    return FloatingActionButton.extended(
      onPressed: () {
        _saveTransaction(context);
      },
      label: Text(
        'Salvar',
        style: TextStyle(
          color: isDarkMode ? Colors.black : Colors.white,
          fontSize: 14,
        ),
      ),
      icon: const Icon(Icons.save),
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
    );
  }
}
