import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';

class MembersDashboard extends StatefulWidget {
  const MembersDashboard({super.key});

  @override
  State<MembersDashboard> createState() => _MembersDashboardState();
}

class _MembersDashboardState extends State<MembersDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _totalMembers = 0;
  int _totalMen = 0;
  int _totalWomen = 0;
  int _totalChildren = 0;
  int _newSignUps = 0;

  late Color _summaryCardColorStart;
  late Color _summaryCardColorEnd;
  late Color _buttonColor;
  late Color _textColor;
  late Color _statCardColorStart;
  late Color _statCardColorEnd;

  @override
  void initState() {
    super.initState();
    fetchMemberCounts();
  }

  Future<void> fetchMemberCounts() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final querySnapshot = await _firestore.collection('members').get();
      final members = querySnapshot.docs;

      setState(() {
        _totalMembers = members.length;

        _totalMen = members
            .where((doc) => (doc.data()['gender'] as String?) == 'Masculino')
            .length;
        _totalWomen = members
            .where((doc) => (doc.data()['gender'] as String?) == 'Feminino')
            .length;

        _totalChildren = members.where((doc) {
          final birthDateTimestamp = doc.data()['birthDate'] as Timestamp?;
          if (birthDateTimestamp == null) return false;

          final birthDate = birthDateTimestamp.toDate();
          final age = now.year - birthDate.year;
          final isBeforeBirthday = now.month < birthDate.month ||
              (now.month == birthDate.month && now.day < birthDate.day);
          return age < 12 || (age == 12 && !isBeforeBirthday);
        }).length;

        _newSignUps = members.where((doc) {
          final createdAtTimestamp = doc.data()['createdAt'] as Timestamp?;
          if (createdAtTimestamp == null) return false;

          final createdAt = createdAtTimestamp.toDate();
          return createdAt.isAfter(startOfMonth) &&
              createdAt.isBefore(endOfMonth);
        }).length;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch member counts: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    _summaryCardColorStart =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blueAccent;
    _summaryCardColorEnd = isDarkMode ? Colors.blueGrey[600]! : Colors.blue;
    _buttonColor = isDarkMode ? Colors.blueGrey[700]! : Colors.blueAccent;
    _textColor =
        isDarkMode ? Colors.white : const Color.fromARGB(255, 255, 255, 255);
    _statCardColorStart =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blueAccent;
    _statCardColorEnd = isDarkMode ? Colors.blueGrey[600]! : Colors.blue;

    return Scaffold(
      drawer: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryCard(context),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBlueCard(
    BuildContext context,
    String title,
    String value, {
    required String filter,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color summaryCardBackgroundColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blueAccent;

    final Color summaryCardBoxShadowColor =
        isDarkMode ? Colors.black54 : Colors.grey[300]!;

    const Color summaryCardTextColor = Colors.white;

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/member_list', arguments: {'filter': filter});
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 150.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [summaryCardBackgroundColor, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: summaryCardBoxShadowColor,
              blurRadius: 6.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: summaryCardTextColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: summaryCardTextColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_summaryCardColorStart, _summaryCardColorEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color:
                _textColor == Colors.white ? Colors.black54 : Colors.grey[400]!,
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Visão Geral do Painel',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          _buildStatsRows(context),
        ],
      ),
    );
  }

  Widget _buildStatsRows(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildSummaryBlueCard(
                context,
                'Total de Membros',
                _totalMembers.toString(),
                filter: 'all',
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: _buildSummaryBlueCard(
                context,
                'Novas Inscrições',
                _newSignUps.toString(),
                filter: 'new',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildSummaryBlueCard(
                context,
                'Total de Homens',
                _totalMen.toString(),
                filter: 'male',
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: _buildSummaryBlueCard(
                context,
                'Total de Mulheres',
                _totalWomen.toString(),
                filter: 'female',
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: _buildSummaryBlueCard(
                context,
                'Total de Crianças',
                _totalChildren.toString(),
                filter: 'children',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value, {
    required String filter,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/member_list', arguments: {'filter': filter});
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_statCardColorStart, _statCardColorEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: _textColor == Colors.white
                  ? Colors.black54
                  : Colors.grey[400]!,
              blurRadius: 6.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _buttonColor,
              shape: const StadiumBorder(),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.person_add),
            label: const Text('Tornar-se um Membro'),
            onPressed: () {
              Navigator.of(context).pushNamed('/become_member');
            },
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _buttonColor,
              shape: const StadiumBorder(),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.search),
            label: const Text('Ver Lista de Membros'),
            onPressed: () {
              Navigator.of(context).pushNamed('/member_list');
            },
          ),
        ),
      ],
    );
  }
}
