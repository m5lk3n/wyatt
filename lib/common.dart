import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Common {
  static late String appName;
  static late String appVersion;
  static late String packageName;

  static const int appStartYear = 2024;

  static const int magicalWaitTimeInSeconds = 2;

  // Platform.isIOS doesn't allow overriding in tests
  static bool isIOS(context) =>
      Theme.of(context).platform == TargetPlatform.iOS;
  static bool isAndroid(context) =>
      Theme.of(context).platform == TargetPlatform.android;
}

abstract class Style {
  static const bigSpace = 50.0;
  static const space = 20.0;
  static const padding = EdgeInsets.all(space);
  static const seedColor = Colors.brown;
  static const iconicBackgroundColor = Colors.white; // wow, white, yay

  static TextStyle getDialogTitleStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.outline,
          );

  static TextStyle getErrorDialogTitleStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.error,
          );

  static final colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color.fromARGB(255, 121, 85,
          72) // = fully opaque (255) "Brown [500] Roman Coffee" with #795548 = 121, 85, 72
      );

  // see https://appainter.dev/
  static final theme = ThemeData(
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.robotoSlabTextTheme().copyWith(
      headlineSmall: GoogleFonts.robotoSlab(),
      bodyMedium: GoogleFonts.robotoSlab(),
    ), // GoogleFonts.latoTextTheme(),
  );

  static final aboutTheme = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.robotoSlabTextTheme().copyWith(
      headlineSmall:
          GoogleFonts.robotoSlab(), // required to make applicationName visible
      bodyMedium: GoogleFonts
          .robotoSlab(), // required to make applicationVersion visible
      bodySmall: GoogleFonts
          .robotoSlab(), // required to make applicationLegalese visible
    ),
  );
}

abstract class Url {
  static String dev = 'https://lttl.dev';

  static const String key = String.fromEnvironment(
    'KEY_URL', // see launch configuration
    defaultValue: Default.urlKey,
  );
  static const String why = String.fromEnvironment(
    'WHY_URL', // see launch configuration
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
  static const String urlKey = 'https://wyatt.lttl.dev#key';
  static const String urlWhy = 'https://wyatt.lttl.dev#why';
  static const String urlPermissions = 'https://wyatt.lttl.dev#permissions';
}

abstract class SecureSettingsKeys {
  static String prefix = Common.packageName;
  static String key = "$prefix.key";
}

abstract class SettingsKeys {
  static const String prefix = 'cfg';
  static const String distance = '${prefix}DefaultNotificationDistance';
}
