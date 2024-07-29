import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase
    FirebaseApp.configure()

    // Register for remote notifications
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      print("Permission granted: \(granted)")
    }
    application.registerForRemoteNotifications()

    // Set up messaging delegate
    Messaging.messaging().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle incoming notifications
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [String: AnyObject]) {
    print("Received remote notification: \(userInfo)")
  }
}

// Handle FCM token
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken token: String?) {
    print("FCM registration token: \(String(describing: token))")
  }
}
