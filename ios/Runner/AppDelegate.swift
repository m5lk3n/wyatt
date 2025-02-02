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
    // https://github.com/fluttercommunity/flutter_workmanager/blob/main/IOS_SETUP.md#enable-bgtaskscheduler
    // the following identifiers must match BGTaskSchedulerPermittedIdentifiers in Info.plist!
    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "dev.lttl.wyatt.taskid")
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "dev.lttl.wyatt", frequency: NSNumber(value: 15 * 60)) // initial delay is 5s by default
    // https://stackoverflow.com/questions/73244206/flutterobservatorypublisher-error-on-ios-version-of-flutter-app
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(15 * 60)) // 15 minutes
    
    // https://pub.dev/packages/flutter_local_notifications#-ios-setup

    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    // https://pub.dev/packages/google_maps_flutter#ios
    GMSServices.provideAPIKey("WillBeReplacedAtRuntime")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
