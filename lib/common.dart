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
  static const String dev = 'https://lttl.dev';
  static const String wyatt = 'https://wyatt.lttl.dev';

  static const String key = String.fromEnvironment(
    'URL_KEY', // see launch configuration, overwrite public URL with private dev server to copy & paste a key from
    defaultValue: Default.urlKey,
  );
  static const String why = String.fromEnvironment(
    'URL_WHY',
    defaultValue: Default.urlWhy,
  );
  static const String permissions = String.fromEnvironment(
    'URL_PERMISSIONS',
    defaultValue: Default.urlPermissions,
  );
  static const String disclaimer = String.fromEnvironment(
    'URL_DISCLAIMER',
    defaultValue: Default.urlDisclaimer,
  );
  static const String privacy = String.fromEnvironment(
    'URL_PRIVACY',
    defaultValue: Default.urlPrivacy,
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
  static const int notificationFrequencyInMins = 15; // min. 15min as per OS
  static const String urlKey = '${Url.wyatt}#key';
  static const String urlWhy = '${Url.wyatt}#why';
  static const String urlPermissions = '${Url.wyatt}#permissions';
  static const String urlDisclaimer = '${Url.wyatt}#disclaimer';
  static const String urlPrivacy = '${Url.wyatt}#privacy';
}

abstract class SecureSettingsKeys {
  static String prefix = Common.packageName;
  static String key = "$prefix.key";
}

abstract class SettingsKeys {
  static const String prefix = 'cfg';
  static const String distance = '${prefix}DefaultNotificationDistance';
}
