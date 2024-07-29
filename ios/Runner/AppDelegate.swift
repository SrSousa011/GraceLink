import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let localNotificationPlugin = FlutterLocalNotificationsPlugin()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase
    FirebaseApp.configure()

    // Initialize local notifications
    let initializationSettings = FlutterLocalNotificationsPluginInitializationSettings()
    localNotificationPlugin.initialize(initializationSettings)

    // Register for remote notifications
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if let error = error {
        print("Error requesting notification authorization: \(error.localizedDescription)")
      } else {
        print("Notification authorization granted: \(granted)")
        DispatchQueue.main.async {
          application.registerForRemoteNotifications()
        }
      }
    }

    // Set up messaging delegate
    Messaging.messaging().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle incoming notifications
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [String: AnyObject]) {
    print("Received remote notification: \(userInfo)")
    // Optionally, handle the notification here
  }
}

// Handle FCM token
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken token: String?) {
    print("FCM registration token: \(String(describing: token))")
    // Optionally, send the token to your server
  }
}
