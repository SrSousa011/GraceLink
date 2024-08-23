import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  int _totalMen = 0;
  int _totalWomen = 0;
  int _totalChildren = 0;
  final int _newSignUps =
      0; // Este valor deve ser calculado conforme necessário

  @override
  void initState() {
    super.initState();
    fetchMemberCounts();
  }

  Future<void> fetchMemberCounts() async {
    try {
      final querySnapshot = await _firestore.collection('becomeMember').get();
      final members = querySnapshot.docs;

      // Verificar se os dados estão sendo retornados
      print('Fetched ${members.length} members from Firestore.');

      setState(() {
        _totalMembers = members.length;
        _totalMen = members.where((doc) => doc['gender'] == 'Male').length;
        _totalWomen = members.where((doc) => doc['gender'] == 'Female').length;
        _totalChildren = members.where((doc) {
          final birthDate = (doc['birthDate'] as Timestamp).toDate();
          final age = DateTime.now().year - birthDate.year;
          return age <= 12;
        }).length;

        // Print dos totais calculados para depuração
        print('Total Members: $_totalMembers');
        print('Total Men: $_totalMen');
        print('Total Women: $_totalWomen');
        print('Total Children (<12): $_totalChildren');
      });
    } catch (e) {
      print('Failed to fetch member counts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Membros'),
      ),
      drawer: const NavBar(),
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
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.5)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Visão Geral do Painel',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total de Membros',
                          _totalMembers.toString(),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Novas Inscrições',
                          _newSignUps.toString(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total de Homens',
                          _totalMen.toString(),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total de Mulheres',
                          _totalWomen.toString(),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total de Crianças (<12)',
                          _totalChildren.toString(),
                        ),
                      ),
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
              child: const Text('Tornar-se um Membro'),
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
              child: const Text('Lista de Membros'),
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
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.5)
                : Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
          ),
        ],
      ),
    );
  }
}
