import 'package:churchapp/views/events/event_service.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/events/event_detail/event_details_screen.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String tLogo = 'assets/icons/logo.png';
const String trLogo = 'assets/icons/rlogo.png';
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

  Future<void> _launchDonationPage() async {
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Home'),
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
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildUpcomingEventsSection(isDarkMode),
                  const SizedBox(height: 20),
                  _buildImportantInfoSection(),
                ],
              ),
            ),
          ),
        ],
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
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Bem-vindo à Igreja',
              style: TextStyle(
                color: Colors.white,
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
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum evento encontrado'));
        }
        final events = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Próximos Eventos:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
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
                        padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                        child: Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
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
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8.0),
                      if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
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
            }),
            const SizedBox(height: 20),
            Center(
              // Centraliza o botão
              child: ElevatedButton(
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
                child: const Text('Todos os Eventos'),
              ),
            ),
          ],
        );
      },
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
          'Segundas 19h30',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _buildSocialMediaIcons(),
      ],
    );
  }

  Widget _buildSocialMediaIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _launchInstagram,
          child: Image.asset(
            tInsta,
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _launchFacebook,
          child: Image.asset(
            tFace,
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _launchDonationPage,
          child: Image.asset(
            trLogo,
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _launchYouTube,
          child: Image.asset(
            tYoutube,
            width: 50,
            height: 50,
          ),
        ),
      ],
    );
  }

  void _navigateToEventDetailsScreen(BuildContext context, Event event) async {
    await Navigator.push(
      context,
      _createPageRoute(EventDetailsScreen(event: event)),
    );
  }

  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end);
        var offsetAnimation =
            animation.drive(tween.chain(CurveTween(curve: curve)));

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
