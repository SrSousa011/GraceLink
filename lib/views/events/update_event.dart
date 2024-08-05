import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:churchapp/views/notifications/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateEventForm extends StatefulWidget {
  final Event event;

  const UpdateEventForm({super.key, required this.event});

  @override
  State<UpdateEventForm> createState() => _UpdateEventFormState();
}

class _UpdateEventFormState extends State<UpdateEventForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String _location = '';
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _selectedDate = widget.event.date;
    _selectedTime = widget.event.time;
    _notificationService.initialize();
    _notificationService.requestNotificationPermission();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _updateEvent(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        time: _selectedTime,
        location: _location,
        createdBy: widget.event.createdBy,
      );

      try {
        // Chama a função updateEvent com o objeto Event e o ID do evento
        await updateEvent(
            updatedEvent, widget.event.id); // Corrigido: pass the ID

        if (_notificationService.notificationsEnabled) {
          await _notificationService.sendNotification(
            _titleController.text,
            _descriptionController.text,
          );
        }

        if (!context.mounted) return;
        Navigator.pop(context, true);
      } catch (e) {
        _showErrorDialog(context, 'Erro ao atualizar evento',
            'Ocorreu um erro ao tentar atualizar o evento: ${e.toString()}');
      }
    } else {
      _showErrorDialog(context, 'Erro ao atualizar evento',
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
        title: const Text('Atualizar Evento'),
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
        labelText: DateFormat('dd/MM/yyyy').format(_selectedDate),
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
        labelText: _selectedTime.format(context),
        icon: Icon(Icons.access_time,
            color: isDarkMode ? Colors.white : Colors.blue),
      ),
    );
  }

  Widget _buildLocationField({required bool isDarkMode}) {
    return TextField(
      controller: _locationController,
      onChanged: (value) {
        setState(() {
          _location = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Localização do Evento',
        icon: Icon(Icons.location_on,
            color: isDarkMode ? Colors.white : Colors.blue),
      ),
    );
  }

  Widget _buildSaveButton({required bool isDarkMode}) {
    return ElevatedButton(
      onPressed: () => _updateEvent(context),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: const Text('Atualizar Evento'),
    );
  }
}
