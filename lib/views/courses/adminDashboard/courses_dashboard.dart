import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/courses/adminDashboard/subscribers_list.dart';
import 'package:churchapp/views/courses/courses.dart';

class CoursesDashboard extends StatefulWidget {
  final int courseId;

  const CoursesDashboard({
    super.key,
    required this.courseId,
  });

  @override
  State<CoursesDashboard> createState() => _CoursesDashboardState();
}

class _CoursesDashboardState extends State<CoursesDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _totalSubscribers = 0;
  int _newSignUps = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final totalSubscribersSnapshot = await _firestore
          .collection('courseregistration')
          .where('courseId', isEqualTo: widget.courseId)
          .get();
      setState(() {
        _totalSubscribers = totalSubscribersSnapshot.docs.length;
      });

      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final newSignUpsSnapshot = await _firestore
          .collection('courseregistration')
          .where('courseId', isEqualTo: widget.courseId)
          .where('registrationDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyDaysAgo))
          .get();
      setState(() {
        _newSignUps = newSignUpsSnapshot.docs.length;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching dashboard data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to the Courses Dashboard!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Choose an option below to manage course information.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                  context,
                  title: 'Total Subscribers',
                  value: _totalSubscribers.toString(),
                  icon: Icons.people,
                ),
                _buildStatCard(
                  context,
                  title: 'New Sign Ups',
                  value: _newSignUps.toString(),
                  icon: Icons.person_add,
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  isDarkMode ? Colors.grey[700]! : Colors.blueAccent,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 16.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubscribersList(courseId: widget.courseId),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.group, size: 28.0),
                  SizedBox(height: 8.0),
                  Text('View Subscribers List'),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  isDarkMode ? Colors.grey[700]! : Colors.blueAccent,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 16.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Courses(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school, size: 28.0),
                  SizedBox(height: 8.0),
                  Text('View Courses List'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required String title, required String value, required IconData icon}) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 40.0, color: isDarkMode ? Colors.white : Colors.black54),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
