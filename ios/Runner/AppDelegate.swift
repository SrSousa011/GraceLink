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
    let initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/app_icon'), // Adjust this based on your assets
      iOS: IOSInitializationSettings()
    )
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

    // Handle notification when app is launched from a terminated state
    if let remoteNotification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
      handleNotification(userInfo: remoteNotification)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle incoming notifications
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [String: AnyObject]) {
    print("Received remote notification: \(userInfo)")
    handleNotification(userInfo: userInfo)
  }

  // Handle notification taps
  private func handleNotification(userInfo: [String: AnyObject]) {
    guard let screen = userInfo["screen"] as? String else { return }

    let controller = window?.rootViewController as? FlutterViewController
    let methodChannel = FlutterMethodChannel(name: "com.example.notifications", binaryMessenger: controller!.binaryMessenger)
    methodChannel.invokeMethod("navigate", arguments: screen)
  }

  // Handle URL schemes
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print("Open URL: \(url.absoluteString)")

    let methodChannel = (window?.rootViewController as? FlutterViewController)?.methodChannel
    methodChannel?.invokeMethod("handleUrl", arguments: url.absoluteString)

    return true
  }
}

// Handle FCM token
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken token: String?) {
    print("FCM registration token: \(String(describing: token))")
    // Optionally, send the token to your server
  }
}
