import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/courses/courses_list.dart';
import 'package:churchapp/views/courses/courses_service.dart';
import 'package:flutter/material.dart';

class CoursesDetails extends StatefulWidget {
  final Course course;
  final CoursesService coursesService;
  final UserData userData;

  const CoursesDetails({
    super.key,
    required this.course,
    required this.coursesService,
    required this.userData,
  });

  @override
  State<CoursesDetails> createState() => _CoursesDetailsState();
}

class _CoursesDetailsState extends State<CoursesDetails> {
  bool isClosed = false;

  @override
  void initState() {
    super.initState();
    isClosed = widget.course.registrationDeadline == 'Encerrado';
  }

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset(
                widget.course.image,
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
                  : 'Inscrições disponíveis até: ${widget.course.registrationDeadline}',
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: isClosed
                  ? null
                  : () async {
                      try {
                        await widget.coursesService.subscribeCourse(
                          courseId: widget.course.id,
                          userName: widget.userData.fullName,
                          userId: widget.userData.uid,
                          status: false,
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Inscrição realizada com sucesso!'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        setState(() {
                          widget.course.registrationDeadline =
                              'Encerrado'; // Mark course as closed
                          isClosed = true;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao realizar inscrição: $e'),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  isClosed ? Colors.red : Colors.blue,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text(
                isClosed ? 'Inscrito' : 'Inscrever-se',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
