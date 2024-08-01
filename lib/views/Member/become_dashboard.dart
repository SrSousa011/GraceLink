import 'package:churchapp/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MembersDashboard extends StatefulWidget {
  const MembersDashboard({super.key});

  @override
  State<MembersDashboard> createState() => _MembersDashboardState();
}

class _MembersDashboardState extends State<MembersDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _totalMembers = 0;
  int _newSignUps = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final totalMembersSnapshot =
          await _firestore.collection('becomeMember').get();
      setState(() {
        _totalMembers = totalMembersSnapshot.docs.length;
      });

      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      final newSignUpsSnapshot = await _firestore
          .collection('becomeMember')
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
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
        title: const Text('Members Dashboard'),
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
                      _buildStatCard(
                          context, 'Total Members', _totalMembers.toString()),
                      _buildStatCard(
                          context, 'New Sign-ups', _newSignUps.toString()),
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
                Navigator.of(context).pushNamed('/become_member');
              },
              child: const Text('Become a Member'),
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
                Navigator.of(context).pushNamed('/member_list');
              },
              child: const Text('List of Members'),
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
