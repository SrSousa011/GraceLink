import 'package:churchapp/provider/user_provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:churchapp/views/notifications/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  final NotificationService _notificationService = NotificationService();

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
    _notificationService.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('Device token: $value');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to get device token: $error');
      }
    });
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
      final newEvent = Event(
        id: _titleController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        time: _selectedTime!,
        location: _location,
      );

      try {
        await addEvent(newEvent);
        await _notificationService.sendNotification(
          _titleController.text,
          _descriptionController.text,
        );

        if (!context.mounted) return;
        Navigator.pop(context, true);
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro ao salvar evento'),
              content: Text(
                  'Ocorreu um erro ao tentar salvar o evento: ${e.toString()}'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro ao salvar evento'),
            content: const Text('Por favor, preencha todos os campos.'),
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
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Novo Evento'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  'Título do Evento',
                  _titleController,
                  Icons.title,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  'Descrição do Evento',
                  _descriptionController,
                  Icons.description,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 20.0),
                _buildDateField(isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                _buildTimeField(isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                _buildLocationField(isDarkMode: isDarkMode),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => _saveEvent(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        isDarkMode ? Colors.grey[800] : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Salvar Evento'),
                ),
              ],
            ),
          ),
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
        icon: Icon(
          icon,
          color: isDarkMode ? Colors.white : Colors.blue,
        ),
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
        icon: Icon(
          Icons.calendar_today,
          color: isDarkMode ? Colors.white : Colors.blue,
        ),
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
        icon: Icon(
          Icons.access_time,
          color: isDarkMode ? Colors.white : Colors.blue,
        ),
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
        labelText: 'Localização do Evento',
        icon: Icon(
          Icons.location_on,
          color: isDarkMode ? Colors.white : Colors.blue,
        ),
      ),
    );
  }
}
