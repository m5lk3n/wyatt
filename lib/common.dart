import 'package:flutter/material.dart';

abstract class Common {
  static late String appName;
  static late String appVersion;
  static late String packageName;
  static String keyKey = "$packageName.key";
  static const String keyUrl = String.fromEnvironment(
    'KEY_URL',
    defaultValue:
        'support@lttl.dev', // supposed to be a real URL, see launch configuration
  );
  static const String screenHome = 'Home';
  static const String screenLtds = 'Locations & To-dos';
  static const String screenSettings = 'Settings';
  static const String screenAbout = 'About';
}

const bigSpace = 50.0;
const space = 20.0;
const padding = EdgeInsets.all(space);
const seedColor = Colors.brown;
