import 'package:churchapp/views/events/event_detail/event_image_add.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/notifications/notification_service.dart';

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _location = '';
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Event _event;
  final NotificationService _notificationService = NotificationService();
  late AuthenticationService _authenticationService;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _notificationService.initialize();
    _notificationService.requestNotificationPermission();
    _authenticationService = AuthenticationService();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final imageAdd = ImageAdd(
      storage: _storage,
      picker: _picker,
      firestore: _firestore,
      eventId: _event.id,
    );

    final downloadUrl = await imageAdd.updateImage();

    if (downloadUrl != null) {
      setState(() {
        _imageUrl = downloadUrl;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveEvent(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      final userId = await _authenticationService.getCurrentUserId();
      if (userId == null) {
        if (!context.mounted) return;
        _showErrorDialog(context, 'Erro ao salvar evento',
            'Não foi possível obter o ID do usuário.');
        return;
      }

      final eventId = DateTime.now().millisecondsSinceEpoch.toString();
      String? imageUrl = _imageUrl;

      final newEvent = {
        'id': eventId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _selectedDate!,
        'time': _selectedTime!.format(context),
        'location': _location,
        'createdBy': userId,
        'imageUrl': imageUrl,
      };

      try {
        await _firestore.collection('events').doc(eventId).set(newEvent);

        if (_notificationService.notificationsEnabled) {
          await _notificationService.sendNotification(
            _titleController.text,
            _descriptionController.text,
          );
        }

        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Events(),
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        _showErrorDialog(context, 'Erro ao salvar evento',
            'Ocorreu um erro ao tentar salvar o evento: ${e.toString()}');
      }
    } else {
      _showErrorDialog(context, 'Erro ao salvar evento',
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
        title: const Text('Novo Evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Título do Evento', _titleController, Icons.title,
                isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildTextField('Descrição do Evento', _descriptionController,
                Icons.description,
                isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildDateField(isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildTimeField(isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildLocationField(isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildImagePicker(isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildSaveButton(isDarkMode: isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, IconData icon,
      {required bool isDarkMode}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(icon, color: isDarkMode ? Colors.white : Colors.blue),
      ),
    );
  }

  Widget _buildDateField({required bool isDarkMode}) {
    return TextField(
      onTap: () => _selectDate(context),
      readOnly: true,
      decoration: InputDecoration(
        labelText: _selectedDate != null
            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
            : 'Selecionar Data',
        icon: Icon(Icons.calendar_today,
            color: isDarkMode ? Colors.white : Colors.blue),
      ),
    );
  }

  Widget _buildTimeField({required bool isDarkMode}) {
    return TextField(
      onTap: () => _selectTime(context),
      readOnly: true,
      decoration: InputDecoration(
        labelText: _selectedTime != null
            ? _selectedTime!.format(context)
            : 'Selecionar Hora',
        icon: Icon(Icons.access_time,
            color: isDarkMode ? Colors.white : Colors.blue),
      ),
    );
  }

  Widget _buildLocationField({required bool isDarkMode}) {
    return TextField(
      onChanged: (value) {
        setState(() {
          _location = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Localização',
        icon: Icon(Icons.location_on,
            color: isDarkMode ? Colors.white : Colors.blue),
      ),
    );
  }

  Widget _buildImagePicker({required bool isDarkMode}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Selecionar Imagem'),
        ),
        if (_imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.network(
              _imageUrl!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

  Widget _buildSaveButton({required bool isDarkMode}) {
    return ElevatedButton(
      onPressed: () => _saveEvent(context),
      child: const Text('Salvar Evento'),
    );
  }
}
