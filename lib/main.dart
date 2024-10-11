import 'package:churchapp/route/root.dart';
import 'package:churchapp/views/notifications/notification_event.dart';
import 'package:churchapp/views/notifications/notification_photo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/route/routes.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/splash_screen.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    NotificationPhotos().init(navigatorKey);
    NotificationEvents().init(navigatorKey);

    return MaterialApp(
      title: 'Grace Link',
      navigatorKey: navigatorKey,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(
        root: Root(auth: AuthenticationService()),
        drawer: const NavBar(),
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
