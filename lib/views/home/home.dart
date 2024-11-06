import 'package:churchapp/views/events/event_service.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/events/event_detail/event_details_screen.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/theme/chart_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String tLogo = 'assets/icons/logo.png';
const String tInsta = 'assets/icons/insta.png';
const String tFace = 'assets/icons/face.png';
const String tYoutube = 'assets/icons/youtube.png';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Event>>? _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _fetchEvents();
  }

  Future<List<Event>> _fetchEvents() async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
    Timestamp startTimestamp = Timestamp.fromDate(startOfMonth);
    Timestamp endTimestamp = Timestamp.fromDate(endOfMonth);
    var snapshot = await events
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map((doc) =>
            Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> _launchInstagram() async {
    const nativeUrl = "instagram://user?username=igrejaresplandecendoathus";
    const webUrl = "https://www.instagram.com/igrejaresplandecendoathus/";
    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }

  Future<void> _launchFacebook() async {
    const nativeUrl = "fb://profile/10008d8490063123";
    const webUrl = "https://www.facebook.com/profile.php?id=100088490063123";
    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print(
            "Não foi possível abrir o aplicativo do Facebook, abrindo no navegador: $e");
      }
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }

  Future<void> _launchChurchPage() async {
    const donationUrl =
        "https://linktr.ee/igrejaresplandecendoasnacoes?utm_source=linktree_profile_share";
    try {
      await launchUrlString(donationUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _launchYouTube() async {
    const youtubeUrl = "https://www.youtube.com/@igrejaresplandecendo";
    try {
      await launchUrlString(youtubeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print("Não foi possível abrir o aplicativo do YouTube: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      drawer: const NavBar(),
      backgroundColor:
          isDarkMode ? ChartColors.backgroundDark : ChartColors.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                floating: true,
                pinned: false,
                snap: true,
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
              SliverPadding(
                padding: EdgeInsets.zero,
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildHeader(isDarkMode),
                      const SizedBox(height: 20),
                      _buildUpcomingEventsSection(isDarkMode),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFooter(isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color:
            isDarkMode ? ChartColors.backgroundDark : ChartColors.whiteToDark,
        image: const DecorationImage(
          image: AssetImage(tLogo),
          fit: BoxFit.contain,
        ),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Bem-vindo à Igreja',
              style: TextStyle(
                color: ChartColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                      blurRadius: 10, color: Colors.black, offset: Offset(2, 2))
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSection(bool isDarkMode) {
    return FutureBuilder<List<Event>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar eventos'));
        }
        final events = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            if (events.isNotEmpty)
              ...events.map((event) {
                return GestureDetector(
                  onTap: () {
                    _navigateToEventDetailsScreen(context, event);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 4.0),
                          child: Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? ChartColors.eventTextColorDark
                                  : ChartColors.eventTextColorLight,
                            ),
                          ),
                        ),
                        if (event.location.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              event.location,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: isDarkMode
                                    ? ChartColors.eventTextColorDark
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8.0),
                        if (event.imageUrl != null &&
                            event.imageUrl!.isNotEmpty)
                          Container(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            width: double.infinity,
                            child: Image.network(
                              event.imageUrl!,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              })
            else
              const Center(
                  child: Text('Não há eventos agendados para este mês.')),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? ChartColors.eventButtonColorDark
                      : ChartColors.eventButtonColorLight,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  _navigateToEventsScreen(context);
                },
                child: const Text(
                  'Todos os Eventos',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: isDarkMode ? ChartColors.backgroundDark : ChartColors.whiteToDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Informações Importantes',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Endereço:\nRue de Rodange 67B, 6791 Aubange, Bélgica',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Cultos:\nDomingos 10h da manhã\nSegundas 19h30',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset(tInsta, width: 40),
                color: isDarkMode ? Colors.white : Colors.black,
                onPressed: _launchInstagram,
              ),
              IconButton(
                icon: Image.asset(tFace, width: 40),
                color: isDarkMode ? Colors.white : Colors.black,
                onPressed: _launchFacebook,
              ),
              IconButton(
                icon: Image.asset(tLogo, width: 50),
                color: isDarkMode ? Colors.white : Colors.black,
                onPressed: _launchChurchPage,
              ),
              IconButton(
                icon: Image.asset(tYoutube, width: 50),
                color: isDarkMode ? Colors.white : Colors.black,
                onPressed: _launchYouTube,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToEventsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Events()),
    );
  }

  void _navigateToEventDetailsScreen(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(event: event),
      ),
    );
  }
}
