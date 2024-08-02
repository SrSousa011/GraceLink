import 'package:churchapp/views/courses/courses_date.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/courses/courses_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesDetails extends StatefulWidget {
  final Course course;
  final CoursesService coursesService;

  const CoursesDetails({
    super.key,
    required this.course,
    required this.coursesService,
  });

  @override
  State<CoursesDetails> createState() => _CoursesDetailsState();
}

class _CoursesDetailsState extends State<CoursesDetails> {
  bool isClosed = false;
  String fullName = '';
  late bool status = false;
  String uid = '';
  bool isUserSubscribed = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final authService = AuthenticationService();
      fullName = await authService.getCurrentUserName() ?? '';
      uid = await authService.getCurrentUserId() ?? '';

      bool subscribed = await widget.coursesService.isUserAlreadySubscribed(
        courseId: widget.course.id,
        userId: uid,
      );

      if (DateTime.now().isAfter(widget.course.registrationDeadline)) {
        setState(() {
          isClosed = true;
        });
      }

      if (mounted) {
        setState(() {
          isUserSubscribed = subscribed;
        });
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isUserSubscribed_${widget.course.id}_$uid', subscribed);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.course.instructor),
            const SizedBox(height: 16.0),
            Center(
              child: widget.course.imageURL.startsWith('http')
                  ? Image.network(
                      widget.course.imageURL,
                      width: 300.0,
                      height: 350.0,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      widget.course.imageURL,
                      width: 300.0,
                      height: 350.0,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16.0),
            Text('${widget.course.price} €'),
            const SizedBox(height: 16.0),
            Text(widget.course.descriptionDetails),
            const SizedBox(height: 16.0),
            Text(
              isClosed
                  ? 'Inscrições encerradas'
                  : 'Inscrições disponíveis até: ${DateFormat('dd/MM/yyyy').format(widget.course.registrationDeadline)}',
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: isClosed || isUserSubscribed
                  ? null
                  : () async {
                      try {
                        await widget.coursesService.registerUserForCourse(
                          courseId: widget.course.id,
                          userId: uid,
                          status: false,
                          userName: fullName,
                        );

                        if (mounted) {
                          setState(() {
                            isUserSubscribed = true;
                          });
                        }

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool(
                            'isUserSubscribed_${widget.course.id}_$uid', true);

                        const SnackBar(
                          content: Text('Inscrição realizada com sucesso!'),
                          duration: Duration(seconds: 3),
                        );
                      } catch (e) {
                        SnackBar(
                          content: Text('Erro ao realizar inscrição: $e'),
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  isDarkMode
                      ? Colors.grey
                      : (isClosed || isUserSubscribed
                          ? Colors.red
                          : Colors.blue),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  isDarkMode
                      ? Colors.white
                      : const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              child: Text(
                isUserSubscribed
                    ? 'Inscrito'
                    : isClosed
                        ? 'Inscrições encerradas'
                        : 'Inscrever-se',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
