import 'package:flutter/material.dart';

abstract class Common {
  static late String appName;
  static late String appVersion;
  static late String packageName;

  static String devUrl = 'https://lttl.dev';
  static String keyKey = "$packageName.key";
  static const String keyUrl = String.fromEnvironment(
    'KEY_URL', // see launch configuration
    defaultValue: 'https://wyatt.lttl.dev/key', // TODO
  );
  static const String keyWhatUrl = String.fromEnvironment(
    'KEY_WHAT_URL', // see launch configuration
    defaultValue: 'https://wyatt.lttl.dev/what', // TODO
  );
  static const String keyWhyUrl = String.fromEnvironment(
    'KEY_WHY_URL', // see launch configuration
    defaultValue: 'https://wyatt.lttl.dev/why', // TODO
  );

  static const bigSpace = 50.0;
  static const space = 20.0;
  static const padding = EdgeInsets.all(space);
  static const seedColor = Colors.brown;

  static const magicalWaitTimeInSeconds = 2;

  static const isKeyValid = true; // TODO: set/align
}

abstract class Screen {
  static const String home = 'Home';
  static const String reminders = 'Reminders';
  static const String setup = 'Saddle Up';
  static const String settings = 'Settings';
  static const String about = 'About';
}
