import Flutter
import UIKit
import flutter_local_notifications
import workmanager
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // see 
    // https://pub.dev/packages/flutter_local_notifications#-ios-setup
    // https://github.com/fluttercommunity/flutter_workmanager/blob/main/example/ios/Runner/AppDelegate.swift

    GeneratedPluginRegistrant.register(with: self)
    UNUserNotificationCenter.current().delegate = self

    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // https://github.com/fluttercommunity/flutter_workmanager/blob/main/IOS_SETUP.md#enable-bgtaskscheduler
    // the following identifiers must match BGTaskSchedulerPermittedIdentifiers in Info.plist!
    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "dev.lttl.wyatt.taskid")
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "dev.lttl.wyatt", frequency: NSNumber(value: 15 * 60)) // initial delay is 5s by default

    // https://pub.dev/packages/flutter_local_notifications#-ios-setup
    // UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    // https://pub.dev/packages/google_maps_flutter#ios
    // do NOT provide static key here, conflicts with google_map_dynamic_key: GMSServices.provideAPIKey("WillBeReplacedAtRuntime")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // https://github.com/fluttercommunity/flutter_workmanager/blob/main/example/ios/Runner/AppDelegate.swift
/*
  override func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert) // shows banner even if app is in foreground
  }
*/
}