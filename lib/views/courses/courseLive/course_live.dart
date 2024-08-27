import 'package:churchapp/views/courses/courseLive/update_schedule.dart';
import 'package:churchapp/views/courses/service/courses_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseLive extends StatefulWidget {
  const CourseLive({super.key});

  @override
  State<CourseLive> createState() => _CourseLiveState();
}

class _CourseLiveState extends State<CourseLive> {
  late Future<List<Course>> _coursesFuture;
  bool _showAddLinkField = false;
  bool _isSelectingCourse = false;
  String? _selectedCourseId;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
  }

  Future<List<Course>> _fetchCourses() async {
    try {
      var courseSnapshots =
          await FirebaseFirestore.instance.collection('courses').get();

      return courseSnapshots.docs.map((doc) {
        final courseData = doc.data();
        final courseId = doc.id;

        return Course(
          courseId: courseId,
          courseName: courseData['courseName'] ?? 'Unknown Course',
          instructor: courseData['instructor'] ?? '',
          imageURL: courseData['imageURL'] ?? '',
          description: courseData['description'] ?? '',
          price: (courseData['price'] as num).toDouble(),
          registrationDeadline:
              (courseData['registrationDeadline'] as Timestamp).toDate(),
          descriptionDetails: courseData['descriptionDetails'] ?? '',
          time: courseData['time'] as Timestamp?,
          videoUrl: courseData['videoUrl'],
          daysOfWeek: courseData['daysOfWeek'],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _launchURL(String url) async {
    final url0 = Uri.parse(url);
    if (!await launchUrl(url0, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url0');
    }
  }

  Future<void> _addLink() async {
    if (_selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um curso.')),
      );
      return;
    }

    final String url = _controller.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um link válido.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(_selectedCourseId)
          .set({'videoUrl': url}, SetOptions(merge: true));
      setState(() {
        _controller.clear();
        _showAddLinkField = false;
        _isSelectingCourse = false;
        _selectedCourseId = null;
      });
      _coursesFuture = _fetchCourses();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar o link.')),
      );
    }
  }

  void _toggleAddLinkField() {
    setState(() {
      _showAddLinkField = !_showAddLinkField;
    });
  }

  void _navigateToUpdateSchedule(String courseId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateScheduleScreen(courseId: courseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videoaulas ao Vivo'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: _toggleAddLinkField,
            icon: Icon(_showAddLinkField ? Icons.cancel : Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showAddLinkField) ...[
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _showAddLinkField
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (_isSelectingCourse)
                        FutureBuilder<List<Course>>(
                          future: _coursesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('Nenhum curso disponível.'));
                            }

                            final coursesList = snapshot.data!;
                            return DropdownButton<String>(
                              value: _selectedCourseId,
                              hint: const Text('Selecione um curso'),
                              items: coursesList.map((course) {
                                return DropdownMenuItem<String>(
                                  value: course.courseId,
                                  child: Text(course.courseName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCourseId = value;
                                });
                              },
                            );
                          },
                        ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Insira o link do curso',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _addLink,
                        child: const Text('Adicionar'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhum curso disponível.'));
                  }

                  final coursesList = snapshot.data!;

                  return ListView.builder(
                    itemCount: coursesList.length,
                    itemBuilder: (context, index) {
                      final course = coursesList[index];
                      final courseName = course.courseName;
                      final time = course.getFormattedTime();
                      final imageURL = course.imageURL;
                      final videoUrl = course.videoUrl;
                      final daysOfWeek = course.daysOfWeek ?? 'N/A';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: imageURL.isNotEmpty
                                  ? Image.network(
                                      imageURL,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image, size: 50),
                              title: Text(courseName),
                              subtitle:
                                  Text('Horário: $time\nDias: $daysOfWeek'),
                              trailing: videoUrl != null && videoUrl.isNotEmpty
                                  ? ElevatedButton(
                                      onPressed: () => _launchURL(videoUrl),
                                      child: const Text('Ir para a Videoaula'),
                                    )
                                  : null,
                            ),
                            if (videoUrl != null && videoUrl.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () => _launchURL(videoUrl),
                                  child: const Text('Assistir Videoaula'),
                                ),
                              ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () => _navigateToUpdateSchedule(
                                      course.courseId),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text('Atualizar Horário e Dias'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
