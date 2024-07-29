import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/notifications/chat_arguments.dart';
import 'package:churchapp/views/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Notifications> {
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.initialize();
    setupInteractedMessage();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(
        context,
        '/chat',
        arguments: ChatArguments(message),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color switchActiveColor =
        theme.brightness == Brightness.light ? Colors.blue : Colors.grey;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notificações'),
        ),
        drawer: NavBar(
          auth: AuthenticationService(),
          authService: AuthenticationService(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: _notificationService.loadNotificationSettings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('Ativar Notificações'),
                    value: _notificationService.notificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _notificationService.setNotificationsEnabled(value);
                      });
                    },
                    activeColor: switchActiveColor,
                    secondary: Icon(
                      Icons.notifications,
                      color: switchActiveColor,
                    ),
                  ),
                  if (_notificationService.notificationsEnabled)
                    const Text('Notificações estão ativadas.')
                  else
                    const Text('Notificações estão desativadas.'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
