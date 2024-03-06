import 'package:churchapp/views/courses/courses_details.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/material.dart';

class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos'),
        centerTitle: true,
      ),
      drawer: const NavBar(),
      body: ListView.builder(
        itemCount: coursesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoursesDetails(
                    course: coursesDetailsList[index],
                    onMarkAsClosed: () {
                      setState(() {
                        coursesDetailsList[index].registrationDeadline =
                            'Encerrado';
                      });
                    },
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD59C), Color(0xFF62CFF7)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha o conteúdo ao topo
                children: [
                  Container(
                    width: 150.0,
                    height: 230.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(coursesList[index].image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Alinha o conteúdo ao topo
                      children: [
                        Text(
                          coursesList[index].title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0), // Espaço entre os textos
                        Text(
                          coursesList[index].instructor,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 8.0), // Espaço entre os textos
                        Text(
                          coursesList[index].description,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 8.0), // Espaço entre os textos
                        Text(
                          '${coursesList[index].price} €',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
