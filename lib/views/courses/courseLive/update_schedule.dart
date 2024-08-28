import 'package:churchapp/views/courses/courseLive/course_live.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

const String tEditSchedule = 'Editar agenda';
const double tDefaultSize = 16.0;
const double tFormHeight = 20.0;
const String tSave = 'Salvar';
const String tDelete = 'Excluir';

class UpdateScheduleScreen extends StatefulWidget {
  final String courseId;

  const UpdateScheduleScreen({super.key, required this.courseId});

  @override
  State<UpdateScheduleScreen> createState() => _UpdateScheduleScreenState();
}

class _UpdateScheduleScreenState extends State<UpdateScheduleScreen> {
  late TextEditingController _timeController;
  late TextEditingController _daysOfWeekController;
  late TextEditingController _videoUrlController;

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController();
    _daysOfWeekController = TextEditingController();
    _videoUrlController = TextEditingController();
    _fetchCourseData();
  }

  @override
  void dispose() {
    _timeController.dispose();
    _daysOfWeekController.dispose();
    _videoUrlController.dispose();
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
        _timeController.text =
            (data['time'] as Timestamp?)?.toDate().toString() ?? '';
        _daysOfWeekController.text = data['daysOfWeek'] ?? '';
        _videoUrlController.text = data['videoUrl'] ?? '';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load course data: $e')),
      );
    }
  }

  void _saveScheduleChanges() {
    String time = _timeController.text;
    String daysOfWeek = _daysOfWeekController.text;
    String videoUrl = _videoUrlController.text;

    try {
      FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .update({
        'time': Timestamp.fromDate(DateTime.parse(time)),
        'daysOfWeek': daysOfWeek,
        'videoUrl': videoUrl,
      }).then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CourseLive(),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao atualizar a programação: $error')),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao salvar a programação: $e')),
      );
    }
  }

  void _clearFields() {
    setState(() {
      _timeController.clear();
      _daysOfWeekController.clear();
      _videoUrlController.clear();
    });
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
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          _timeController.text = DateTime(
            time.hour,
            time.minute,
          ).toIso8601String();
        }
      },
    );
  }

  Widget _daysOfWeekField() {
    return TextFormField(
      controller: _daysOfWeekController,
      decoration: const InputDecoration(
        labelText: 'Dias da Semana',
        prefixIcon: Icon(LineAwesomeIcons.calendar),
      ),
    );
  }

  Widget _videoUrlField() {
    return TextFormField(
      controller: _videoUrlController,
      decoration: const InputDecoration(
        labelText: 'Link da Aula (Google Meet)',
        prefixIcon: Icon(LineAwesomeIcons.external_link_alt_solid),
      ),
      keyboardType: TextInputType.url,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor =
        theme.brightness == Brightness.light ? Colors.blue : Colors.grey;

    final Color buttonTextColor =
        theme.brightness == Brightness.light ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          tEditSchedule,
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
                  _timeField(),
                  const SizedBox(height: tFormHeight - 20),
                  _daysOfWeekField(),
                  const SizedBox(height: tFormHeight - 10),
                  _videoUrlField(),
                  const SizedBox(height: tFormHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: _saveScheduleChanges,
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
                            backgroundColor:
                                theme.brightness == Brightness.light
                                    ? Colors.redAccent.withOpacity(0.1)
                                    : Colors.grey,
                            elevation: 0,
                            foregroundColor:
                                theme.brightness == Brightness.light
                                    ? Colors.red
                                    : Colors.black,
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
