import 'package:flutter/material.dart';

abstract class Common {
  static late String appName;
  static late String appVersion;
  static late String packageName;

  static const bigSpace = 50.0;
  static const space = 20.0;
  static const padding = EdgeInsets.all(space);
  static const seedColor = Colors.brown;
  static const iconicBackgroundColor = Colors.white; // wow, white, yay

  static const magicalWaitTimeInSeconds = 2;

  // Platform.isIOS doesn't allow overriding in tests
  static bool isIOS(context) =>
      Theme.of(context).platform == TargetPlatform.iOS;
  static bool isAndroid(context) =>
      Theme.of(context).platform == TargetPlatform.android;
}

abstract class Url {
  static String dev = 'https://lttl.dev';

  static const String key = String.fromEnvironment(
    'KEY_URL', // see launch configuration
    defaultValue: Default.urlKey,
  );
  static const String keyWhat = String.fromEnvironment(
    'KEY_WHAT_URL', // see launch configuration
    defaultValue: Default.urlWhat,
  );
  static const String keyWhy = String.fromEnvironment(
    'KEY_WHY_URL', // see launch configuration
    defaultValue: Default.urlWhy,
  );
  static const String permissions = String.fromEnvironment(
    'PERMISSIONS_URL', // see launch configuration
    defaultValue: Default.urlPermissions,
  );
}

abstract class Screen {
  static const String home = 'Home';
  static const String reminders = 'Reminders';
  static const String setup = 'Saddle Up';
  static const String settings = 'Settings';
  static const String about = 'About';
  static const String addReminder = 'Add Reminder';
  static const String editReminder = 'Edit Reminder';
  static const String pickLocation = 'Pick a Location';
}

abstract class Default {
  static const int notificationDistance = 500;
  static const int notificationResponsivenessMs =
      60 * 1000; // 1min // TODO: make configurable
  static const String urlKey = 'https://wyatt.lttl.dev/key';
  static const String urlWhy = 'https://wyatt.lttl.dev/why';
  static const String urlWhat = 'https://wyatt.lttl.dev/what';
  static const String urlPermissions = 'https://wyatt.lttl.dev/permissions';
}

abstract class SecureSettingsKeys {
  static String prefix = Common.packageName;
  static String key = "$prefix.key";
}

abstract class SettingsKeys {
  static const String prefix = 'cfg';
  static const String distance = '${prefix}DefaultNotificationDistance';
}
