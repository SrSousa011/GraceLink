import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool notificationsEnabled = true;

  Future<void> initialize() async {
    await _initializeLocalNotifications();
    await requestNotificationPermission();
    await loadNotificationSettings();
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
  }

  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
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

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (!notificationsEnabled) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'update_channel_id',
      'Update Notifications',
      channelDescription: 'Notifications for event updates',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['url'],
    );
  }

  Future<void> sendNotification({
    required String title,
    required String location,
    required String formattedTime,
    required String addedTime,
  }) async {
    if (!notificationsEnabled) return;

    final String body = '$location\n $formattedTime\n';

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
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void setNotificationsEnabled(bool enabled) {
    notificationsEnabled = enabled;
    _saveNotificationSettings();
  }
}
