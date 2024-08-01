import 'package:churchapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class MemberDetailsScreen extends StatelessWidget {
  final String memberId;

  const MemberDetailsScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final iconColor = isDarkMode ? Colors.white : Colors.blue;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('becomeMember')
          .doc(memberId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Member not found'));
        }

        final memberData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Member Details'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildDetailCard(
                  context,
                  icon: Icons.person,
                  title: 'Full Name',
                  value: memberData['fullName'] ?? 'N/A',
                  iconColor: iconColor,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.phone,
                  title: 'Phone Number',
                  value: memberData['phoneNumber'] ?? 'N/A',
                  iconColor: iconColor,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.home,
                  title: 'Address',
                  value: memberData['address'] ?? 'N/A',
                  iconColor: iconColor,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.church,
                  title: 'Last Visited Church',
                  value: memberData['lastVisitedChurch'] ?? 'N/A',
                  iconColor: iconColor,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.note,
                  title: 'Reason for Membership',
                  value: memberData['reasonForMembership'] ?? 'N/A',
                  iconColor: iconColor,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.person_add,
                  title: 'Reference',
                  value: memberData['reference'] ?? 'N/A',
                  iconColor: iconColor,
                ),
                _buildDetailCard(
                  context,
                  icon: Icons.info,
                  title: 'Civil Status',
                  value: memberData['civilStatus'] ?? 'N/A',
                  iconColor: iconColor,
                ),
                if (memberData.containsKey('membershipDate') &&
                    memberData['membershipDate'] != null)
                  _buildDetailCard(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Membership Date',
                    value: _formatDate(
                        (memberData['membershipDate'] as Timestamp).toDate()),
                    iconColor: iconColor,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String value,
      required Color iconColor}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
