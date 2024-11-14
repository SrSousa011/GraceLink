import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationEvents {
  static final NotificationEvents _instance = NotificationEvents._internal();
  factory NotificationEvents() => _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  NotificationEvents._internal();

  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin?.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null && navigatorKey.currentState != null) {
          navigatorKey.currentState!
              .pushNamed('/event_page', arguments: response.payload);
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String eventId = message.data['eventId'] ?? '';
        showNotification(
          message.notification!.title ?? "Novo Evento",
          message.notification!.body ?? "Você tem um novo evento.",
          message.data['url'] ?? '',
          eventId: eventId,
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  Future<void> requestNotificationPermission() async {
    if (Theme.of(navigatorKey.currentContext!).platform == TargetPlatform.iOS) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('User granted permission');
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        if (kDebugMode) {
          print('User granted provisional permission');
        }
      } else {
        if (kDebugMode) {
          print('User denied permission');
        }
      }
    }
  }

  Future<void> showNotification(String title, String body, String payload,
      {required String eventId}) async {
    if (_flutterLocalNotificationsPlugin == null) {
      throw Exception("Notification plugin not initialized");
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'event_channel_id',
      'Event Notifications',
      channelDescription: 'Notifications for event updates',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: '@drawable/app_icon',
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);

    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await _flutterLocalNotificationsPlugin?.show(
      notificationId,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
