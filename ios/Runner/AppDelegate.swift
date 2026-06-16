import Flutter
import UIKit
import GoogleMaps
import FirebaseCore
import flutter_local_notifications
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyADu7iH2Gt4nMugFT3LW6dUYTU4YerD0bc")
    FirebaseApp.configure()
        // Initialize Flutter Local Notifications
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
        }
        if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        application.registerForRemoteNotifications()
        GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


}
