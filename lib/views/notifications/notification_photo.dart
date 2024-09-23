import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool notificationsEnabled = true;

  Future<void> initialize(BuildContext context) async {
    await _initializeLocalNotifications();
    await requestNotificationPermission();
    await loadNotificationPreferences();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToPhotosPage(context);
    });
  }

  Future<void> loadNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
  }

  Future<void> toggleNotifications(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    notificationsEnabled = isEnabled;
    await prefs.setBool('notificationsEnabled', isEnabled);
  }

  Future<void> requestNotificationPermission() async {
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
    } else {
      if (kDebugMode) {
        print('User denied permission');
      }
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> sendNotification({
    required String location,
    required String formattedTime,
    required String addedTime,
  }) async {
    if (!notificationsEnabled) return;

    final String body =
        'Uma nova foto foi adicionada em "$location". Clique aqui para visualizá-la.';

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'update_channel_id',
      'Update Notifications',
      channelDescription: 'Notifications for event updates',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      '',
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> _handleForegroundMessage(
      RemoteMessage message, BuildContext context) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'photo_channel_id',
      'Photo Notifications',
      channelDescription: 'Notifications for new photos',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'Nova Notificação',
      'Uma nova foto foi adicionada. Clique aqui para visualizá-la.',
      platformChannelSpecifics,
    );
  }

  void _navigateToPhotosPage(BuildContext context) {
    if (context.mounted) {
      Navigator.pushNamed(context, '/photos');
    }
  }
}
