import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/provider/user_provider.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/courses/courses_details.dart';
import 'package:churchapp/views/courses/courses_list.dart';
import 'package:churchapp/views/courses/courses_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final CoursesService _coursesService = CoursesService();
  UserData _userData = UserData(
    uid: '',
    fullName: '',
    email: '',
    password: '',
    phoneNumber: '',
    address: '',
  );

  updateData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
    setState(() {
      _userData = userProvider.getUser!;
    });
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos'),
        centerTitle: true,
      ),
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
      ),
      body: ListView.builder(
        itemCount: coursesList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoursesDetails(
                      course: coursesList[index],
                      coursesService: _coursesService,
                      userData: _userData,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            coursesList[index].instructor,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            coursesList[index].description,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 8.0),
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
            ),
          );
        },
      ),
    );
  }
}
