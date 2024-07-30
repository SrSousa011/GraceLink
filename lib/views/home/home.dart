import 'package:churchapp/views/events/events.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/events/event_details.dart';
import 'package:churchapp/views/events/event_list_item.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String tLogo = 'assets/icons/logo.png';
const String tInsta = 'assets/icons/insta.png';

class Home extends StatefulWidget {
  final BaseAuth auth;

  const Home({super.key, required this.auth, required String userId});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      drawer: NavBar(
        auth: widget.auth,
        authService: AuthenticationService(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildUpcomingEventsSection(isDarkMode),
            const SizedBox(height: 20),
            _buildImportantInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(tLogo),
          fit: BoxFit.contain,
        ),
      ),
      child: const Center(
        child: Text(
          'Bem-vindo à Igreja',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2))
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildUpcomingEventsSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Próximos Eventos:',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        StreamBuilder<List<Event>>(
          stream: _readEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar eventos'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum evento encontrado'));
            }
            final events = snapshot.data!.take(5).toList();
            return Column(
              children: [
                ...events.map((event) => GestureDetector(
                      onTap: () {
                        _navigateToEventDetailsScreen(context, event);
                      },
                      child: EventListItem(event: event),
                    )),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? const Color(0xFF333333) : Colors.blue,
                    shape: const StadiumBorder(),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Events()),
                    );
                  },
                  child: const Text('Ver Todos os Eventos'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildImportantInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Informações Importantes:',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          'Endereço:\n'
          'RBM Rue de Rodange 67B, 6791 Aubange, Bélgica',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          'Cultos:\n'
          'Domingos 10h da manhã\n'
          'Segundas 19h30\n'
          'Quartas 19h30',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _launchInstagram,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Igreja Resplandecendo',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
              Image.asset(
                tInsta,
                width: 40,
                height: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Stream<List<Event>> _readEvents() {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    return events.orderBy('date', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  void _navigateToEventDetailsScreen(BuildContext context, Event event) async {
    await Navigator.push<Event>(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
    );
  }

  Future<void> _launchInstagram() async {
    const nativeUrl = "instagram://user?username=igrejaresplandecendoathus";
    const webUrl = "https://www.instagram.com/igrejaresplandecendoathus/";

    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }
}
