import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationBecomeMember {
  static final NotificationBecomeMember _instance =
      NotificationBecomeMember._internal();
  factory NotificationBecomeMember() => _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  NotificationBecomeMember._internal();

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
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin?.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null && navigatorKey.currentState != null) {
          try {
            final Map<String, dynamic> payloadData =
                json.decode(response.payload!) as Map<String, dynamic>;
            String filter = payloadData['filter'] ?? 'all';
            navigatorKey.currentState!.pushNamed(
              '/member_list',
              arguments: filter,
            );
          } catch (e) {
            if (kDebugMode) {
              print('Error decoding payload: $e');
            }
            navigatorKey.currentState!.pushNamed('/member_list',
                arguments: {'payload': response.payload});
          }
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String memberName = message.data['fullName'] ?? 'um novo membro';

        showNotification(
          message.notification!.title ?? "Novo Membro",
          "$memberName se tornou um novo membro.",
          message.data['url'] ?? '',
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
    }
  }

  Future<void> requestNotificationPermission() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
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

  Future<void> showNotification(
    String title,
    String body,
    String payload,
  ) async {
    if (_flutterLocalNotificationsPlugin == null) {
      throw Exception("Notification plugin not initialized");
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'admin_member_channel_id',
      'Admin Member Notifications',
      channelDescription: 'Notifications for new member sign-ups',
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
