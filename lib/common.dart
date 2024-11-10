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
  static const String screenHome = 'Home';
  static const String screenLtds = 'Reminders';
  static const String screenSetup = 'Saddle Up';
  static const String screenSettings = 'Settings';
  static const String screenAbout = 'About';
}

const bigSpace = 50.0;
const space = 20.0;
const padding = EdgeInsets.all(space);
const seedColor = Colors.brown;
