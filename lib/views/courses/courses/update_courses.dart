import 'package:churchapp/views/courses/courses/course_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:churchapp/views/courses/courseLive/course_live.dart';
import 'package:intl/intl.dart';

const String tEditCourse = 'Editar Curso';
const double tDefaultSize = 16.0;
const double tFormHeight = 20.0;
const String tSave = 'Salvar';
const String tDelete = 'Excluir';

class UpdateCourseScreen extends StatefulWidget {
  final String courseId;

  const UpdateCourseScreen({super.key, required this.courseId});

  @override
  State<UpdateCourseScreen> createState() => _UpdateCourseScreenState();
}

class _UpdateCourseScreenState extends State<UpdateCourseScreen> {
  late TextEditingController _courseNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _descriptionDetailsController;
  late TextEditingController _instructorController;
  late TextEditingController _priceController;
  late TextEditingController _registrationDeadlineController;
  late TextEditingController _timeController;
  late TextEditingController _imageUrlController;

  final CourseService _courseService = CourseService();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    _courseNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _descriptionDetailsController = TextEditingController();
    _instructorController = TextEditingController();
    _priceController = TextEditingController();
    _registrationDeadlineController = TextEditingController();
    _timeController = TextEditingController();
    _imageUrlController = TextEditingController();
    _fetchCourseData();
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _descriptionController.dispose();
    _descriptionDetailsController.dispose();
    _instructorController.dispose();
    _priceController.dispose();
    _registrationDeadlineController.dispose();
    _timeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _fetchCourseData() async {
    try {
      var courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .get();

      if (courseDoc.exists) {
        var data = courseDoc.data()!;
        _courseNameController.text = data['courseName'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        _descriptionDetailsController.text = data['descriptionDetails'] ?? '';
        _instructorController.text = data['instructor'] ?? '';
        _priceController.text = (data['price'] ?? '').toString();

        Timestamp? registrationDeadlineTimestamp =
            data['registrationDeadline'] as Timestamp?;
        if (registrationDeadlineTimestamp != null) {
          _registrationDeadlineController.text =
              _dateFormat.format(registrationDeadlineTimestamp.toDate());
        } else {
          _registrationDeadlineController.clear();
        }

        Timestamp? timeTimestamp = data['time'] as Timestamp?;
        if (timeTimestamp != null) {
          _timeController.text = _timeFormat.format(timeTimestamp.toDate());
        } else {
          _timeController.clear();
        }

        _imageUrlController.text = data['imageUrl'] ?? '';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load course data: $e')),
      );
    }
  }

  void _saveCourseChanges() async {
    String courseName = _courseNameController.text;
    String description = _descriptionController.text;
    String descriptionDetails = _descriptionDetailsController.text;
    String instructor = _instructorController.text;
    double? price = double.tryParse(_priceController.text);
    DateTime? registrationDeadline =
        _registrationDeadlineController.text.isNotEmpty
            ? _dateFormat.parse(_registrationDeadlineController.text)
            : null;
    DateTime? time = _timeController.text.isNotEmpty
        ? _timeFormat.parse(_timeController.text)
        : null;

    try {
      await _courseService.update(
        courseId: widget.courseId,
        courseName: courseName,
        description: description,
        descriptionDetails: descriptionDetails,
        instructor: instructor,
        price: price,
        registrationDeadline: registrationDeadline,
        time: time,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CourseLive(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save course changes: $e')),
      );
    }
  }

  void _clearFields() {
    setState(() {
      _courseNameController.clear();
      _descriptionController.clear();
      _descriptionDetailsController.clear();
      _instructorController.clear();
      _priceController.clear();
      _registrationDeadlineController.clear();
      _timeController.clear();
      _imageUrlController.clear();
    });
  }

  Widget _courseNameField() {
    return TextFormField(
      controller: _courseNameController,
      decoration: const InputDecoration(
        labelText: 'Nome do Curso',
        prefixIcon: Icon(LineAwesomeIcons.bookmark),
      ),
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Descrição',
        prefixIcon: Icon(LineAwesomeIcons.file_alt),
      ),
    );
  }

  Widget _descriptionDetailsField() {
    return TextFormField(
      controller: _descriptionDetailsController,
      decoration: const InputDecoration(
        labelText: 'Detalhes da Descrição',
        prefixIcon: Icon(LineAwesomeIcons.file_signature_solid),
      ),
    );
  }

  Widget _instructorField() {
    return TextFormField(
      controller: _instructorController,
      decoration: const InputDecoration(
        labelText: 'Instrutor',
        prefixIcon: Icon(LineAwesomeIcons.user),
      ),
    );
  }

  Widget _priceField() {
    return TextFormField(
      controller: _priceController,
      decoration: const InputDecoration(
        labelText: 'Preço',
        prefixIcon: Icon(LineAwesomeIcons.euro_sign_solid),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _registrationDeadlineField() {
    return TextFormField(
      controller: _registrationDeadlineController,
      decoration: const InputDecoration(
        labelText: 'Data de Inscrição',
        prefixIcon: Icon(LineAwesomeIcons.calendar_alt),
      ),
      keyboardType: TextInputType.datetime,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (selectedDate != null) {
          _registrationDeadlineController.text =
              _dateFormat.format(selectedDate);
        }
      },
    );
  }

  Widget _timeField() {
    return TextFormField(
      controller: _timeController,
      decoration: const InputDecoration(
        labelText: 'Horário',
        prefixIcon: Icon(LineAwesomeIcons.clock),
      ),
      keyboardType: TextInputType.datetime,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (selectedTime != null) {
          DateTime now = DateTime.now();
          DateTime selectedDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _timeController.text = _timeFormat.format(selectedDateTime);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor =
        theme.brightness == Brightness.light ? Colors.blue : Colors.grey;
    final Color buttonTextColor =
        theme.brightness == Brightness.light ? Colors.white : Colors.black;
    final Color deleteButtonColor = theme.brightness == Brightness.light
        ? Colors.redAccent.withOpacity(0.1)
        : Colors.grey;
    final Color deleteButtonTextColor =
        theme.brightness == Brightness.light ? Colors.red : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          tEditCourse,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            Form(
              child: Column(
                children: [
                  _courseNameField(),
                  const SizedBox(height: tFormHeight),
                  _descriptionField(),
                  const SizedBox(height: tFormHeight),
                  _descriptionDetailsField(),
                  const SizedBox(height: tFormHeight),
                  _instructorField(),
                  const SizedBox(height: tFormHeight),
                  _priceField(),
                  const SizedBox(height: tFormHeight),
                  _registrationDeadlineField(),
                  const SizedBox(height: tFormHeight),
                  _timeField(),
                  const SizedBox(height: tFormHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: _saveCourseChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            tSave,
                            style: TextStyle(color: buttonTextColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: _clearFields,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: deleteButtonColor,
                            elevation: 0,
                            foregroundColor: deleteButtonTextColor,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(tDelete),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
