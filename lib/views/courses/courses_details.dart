import 'package:churchapp/views/courses/courses_list.dart';
import 'package:flutter/material.dart';

class CoursesDetails extends StatefulWidget {
  final Course course;
  const CoursesDetails(
      {super.key,
      required this.course,
      required Null Function() onMarkAsClosed});

  @override
  State<CoursesDetails> createState() => _CoursesDetailsState();
}

class _CoursesDetailsState extends State<CoursesDetails> {
  @override
  Widget build(BuildContext context) {
    bool isClosed = widget.course.registrationDeadline ==
        'Encerrado'; // Check if course is closed

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
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Inscrição realizada com sucesso!'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      setState(() {
                        widget.course.registrationDeadline =
                            'Encerrado'; // Mark course as closed
                      });
                    },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  isClosed ? Colors.red : Colors.blue,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text(
                isClosed ? 'Esgotado' : 'Inscrever-se',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
