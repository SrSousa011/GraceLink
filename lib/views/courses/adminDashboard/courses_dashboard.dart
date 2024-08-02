import 'package:churchapp/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesDashboard extends StatefulWidget {
  const CoursesDashboard({super.key});

  @override
  State<CoursesDashboard> createState() => _CoursesDashboardState();
}

class _CoursesDashboardState extends State<CoursesDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _newEnrollments = 0;
  int _newSignUps = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      // Fetch new enrollments in the last 30 days
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final newEnrollmentsSnapshot = await _firestore
          .collection('courseregistration')
          .where('registrationDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyDaysAgo))
          .get();
      setState(() {
        _newEnrollments = newEnrollmentsSnapshot.docs.length;
      });

      // Fetch new sign-ups in the last 30 days
      final newSignUpsSnapshot = await _firestore
          .collection(
              'signups') // Replace with the actual collection for sign-ups
          .where('signUpDate',
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Dashboard Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(context, 'New Enrollments',
                          _newEnrollments.toString()),
                      _buildStatCard(
                          context, 'New Sign Ups', _newSignUps.toString()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? const Color(0xFF333333) : Colors.blue,
                shape: const StadiumBorder(),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/courses');
              },
              child: const Text('View Courses'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? const Color(0xFF333333) : Colors.blue,
                shape: const StadiumBorder(),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/subscribers_list');
              },
              child: const Text('View Subscribers'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
