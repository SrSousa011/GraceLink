import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPhotos {
  static final NotificationPhotos _instance = NotificationPhotos._internal();
  factory NotificationPhotos() => _instance;

  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  NotificationPhotos._internal();

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
        if (response.payload != null) {
          print("Notification tapped with payload: ${response.payload}");
        }
        if (navigatorKey.currentState != null) {
          print("Navigator Key is ready, navigating to /photos");
          navigatorKey.currentState!.pushNamed('/photos');
        } else {
          print("Navigator Key is null, unable to navigate");
        }
      },
    );
  }

  Future<void> showNotification(
      String title, String body, String payload) async {
    if (_flutterLocalNotificationsPlugin == null) {
      throw Exception("Notification plugin not initialized");
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
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

    await _flutterLocalNotificationsPlugin?.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
