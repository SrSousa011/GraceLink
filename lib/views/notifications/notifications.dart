import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/notifications/chat_arguments.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Notifications> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
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
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  bool _notificationsEnabled = true;
  final bool canReturn = false;

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
          backgroundColor: theme.brightness == Brightness.light
              ? Colors.blue
              : Colors.grey, // Change AppBar color based on theme
        ),
        drawer: NavBar(
          auth: AuthenticationService(),
          authService: AuthenticationService(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text('Ativar Notificações'),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: switchActiveColor,
                secondary: Icon(
                  Icons.notifications,
                  color: switchActiveColor,
                ),
              ),
              if (_notificationsEnabled)
                const Text('Notificações estão ativadas.')
              else
                const Text('Notificações estão desativadas.'),
            ],
          ),
        ),
      ),
    );
  }
}
