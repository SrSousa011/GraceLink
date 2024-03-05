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
      body: ListView.builder(
        itemCount: coursesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CourseDetailsPage(course: coursesList[index]),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD59C), Color(0xFF62CFF7)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coursesList[index].title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'Ministrado por: ${coursesList[index].instructor}'),
                        Text('Descrição: ${coursesList[index].description}'),
                        Text('Preço: ${coursesList[index].price} €'),
                        Text(
                            'Inscrições disponíveis até: ${coursesList[index].registrationDeadline}'),
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

class CourseDetailsPage extends StatelessWidget {
  final Course course;

  const CourseDetailsPage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ministrado por: ${course.instructor}'),
            const SizedBox(height: 16.0),
            Image.asset(
              course.image,
              width: 400.0,
              height: 400.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text('Preço: ${course.price} €'),
            const SizedBox(height: 16.0),
            const Text('Descrição:'),
            Text(course.description),
            const SizedBox(height: 16.0),
            Text('Inscrições disponíveis até: ${course.registrationDeadline}'),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Inscrição realizada com sucesso!'),
                    duration: Duration(seconds: 3),
                  ),
                );
                // Aqui você pode adicionar a lógica para inscrição no curso
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  course.registrationDeadline == 'Encerrado'
                      ? Colors.red
                      : Colors.blue,
                ),
              ),
              child: Text(
                course.registrationDeadline == 'Encerrado'
                    ? 'Esgotado'
                    : 'Inscrever-se',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Course {
  final String title;
  final String instructor;
  final String description;
  final double price;
  String registrationDeadline;
  final String image;

  Course({
    required this.title,
    required this.instructor,
    required this.description,
    required this.price,
    required this.registrationDeadline,
    required this.image,
  });
}

final List<Course> coursesList = [
  Course(
    title: 'Mulher Única',
    instructor: 'Para Mulheres | ministrado por pessoa fulana',
    description: 'Elevando sua autoestima e maximizando a adição das mulheres.',
    price: 100,
    registrationDeadline: '31/12/2024',
    image: 'assets/imagens/mulher-unica.jpg',
  ),
  Course(
    title: 'Homem ao Máximo',
    instructor: 'Para Homens | ministrado por pessoa fulana',
    description:
        'Elevando o nível máximo de sua hombridade e potencializando o sucesso familiar.',
    price: 100,
    registrationDeadline: '31/12/2024',
    image: 'assets/imagens/homen-ao-maximo.jpg',
  ),
  Course(
    title: 'Casados para sempre',
    instructor: 'Para casados | ministrado por pessoa fulana',
    description:
        'Um manual de instruções bíblicas para a saúde do seu casamento promovendo a alegria familiar.',
    price: 100,
    registrationDeadline: '31/12/2024',
    image: 'assets/imagens/casados-para-sempre.jpg',
  ),
  // Adicionar mais cursos conforme necessário
];
