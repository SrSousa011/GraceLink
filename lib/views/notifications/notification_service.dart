import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("@drawable/app_icon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsDarwin,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required String payload, // Adicionado para identificar o destino
  }) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload, // Passa o payload para a notificação
    );
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    debugPrint(
        'Notification received with payload: ${notificationResponse.payload}');

    final String? payload = notificationResponse.payload;

    switch (payload) {
      case 'photos':
        debugPrint('Navigating to Photos');
        Get.toNamed('/photos');
        break;
      case 'event_page':
        debugPrint('Navigating to Event Page');
        Get.toNamed('/event_page');
        break;
      case 'become_member':
        debugPrint('Navigating to Become Member Page');
        Get.toNamed('/become_member');
        break;
      default:
        debugPrint('Payload not handled: $payload');
        Get.snackbar(
          'Notification',
          'Unhandled payload: $payload',
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }

  Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    Get.dialog(CupertinoAlertDialog(
      title: Text(title ?? "title"),
      content: Text(body ?? "body"),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Abrir'),
          onPressed: () {
            Get.back();
            if (payload == 'photos') {
              Get.toNamed('/photos');
            } else if (payload == 'event_page') {
              Get.toNamed('/event_page');
            } else if (payload == 'become_member') {
              Get.toNamed('/become_member');
            } else {
              Get.snackbar(
                'Notification',
                'Unhandled payload: $payload',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
        ),
      ],
    ));
  }
}
