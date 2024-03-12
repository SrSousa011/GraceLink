import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> initNotifications() async {
    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');
  }
}
