import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/providers/permissions_provider.dart';

const String isolateExchangeDataKey = 'dev.lttl.wyatt.isolateExchangeData';

void updateBackgroundReminders(List<Reminder> activeReminders) async {
  log('${activeReminders.length} active reminders in shared preferences',
      name: 'updateBackgroundReminders');

  List<String> remindersAsStringList =
      activeReminders.map((r) => jsonEncode(r.toJson())).toList();
  SharedPreferencesAsync()
      .setStringList(isolateExchangeDataKey, remindersAsStringList);
}

Future<List<Reminder>> getBackgroundRemindersInRange(
    double currentLatitude, double currentLongitude) async {
  List<Reminder> remindersInRange = [];
  try {
    List<String>? remindersAsStringList =
        await SharedPreferencesAsync().getStringList(isolateExchangeDataKey);

    if (remindersAsStringList == null || remindersAsStringList.isEmpty) {
      log('no reminders, skipping', name: 'getRemindersInRange');
      return [];
    }

    List<Reminder> reminders = remindersAsStringList
        .map((jsonString) => Reminder.fromJson(jsonDecode(jsonString)))
        .toList();

    log('${reminders.length} reminders', name: 'getRemindersInRange');
    log('$reminders', name: 'getRemindersInRange');

    remindersInRange = reminders.where((reminder) {
      return reminder.isInRange(LocationData.fromMap(
          {'latitude': currentLatitude, 'longitude': currentLongitude}));
    }).toList();
    log('${remindersInRange.length} reminders in range',
        name: 'getRemindersInRange');
  } catch (e) {
    log('ERROR: $e', name: 'getRemindersInRange');
    remindersInRange = [];
  }
  return remindersInRange;
}

/*
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void initNotifications() {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  /* var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);*/
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, /*iOS: initializationSettingsIOS */
  );
  flutterLocalNotificationsPlugin!.initialize(initializationSettings);

  log('notifications initialized', name: 'WyattApp');
}

void showNotification(String text) async {
  if (flutterLocalNotificationsPlugin == null) {
    initNotifications();
  }

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'dev.lttl.wyatt', // avoids: Unhandled Exception: LateInitializationError: Field 'packageName' has not been initialized.
    'Wyatt', // avoids: Unhandled Exception: LateInitializationError: Field 'appName' has not been initialized.
    importance: Importance.high,
    priority: Priority.high,
  );
  // TODO: var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android:
        androidPlatformChannelSpecifics, /*iOS: iOSPlatformChannelSpecifics*/
  );
  await flutterLocalNotificationsPlugin!.show(
    0,
    'Howdy!',
    text,
    platformChannelSpecifics,
  );
}
*/
class CoreSystem {
  final WidgetRef _ref;

  CoreSystem(this._ref);

  Future<bool> checkPermissions() async {
    /* we'll not check the following permission callbacks here:

       - onRestrictedCallback is for "active restrictions such as parental controls" (iOS only) (https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/lib/permission_handler.dart#L138)
       - onLimitedCallback is "for limited photo library access" (iOS only) (https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/lib/permission_handler.dart#L143C44-L143C76)

       generell remarks reg.

       - onGrantedCallback is needed as permissions can be granted during app usage
       - onPermanentlyDeniedCallback: no new permission dialog will be shown, redirect user to App settings page for permissions
       - onProvisionalCallback: iOS only, "provisionally authorized to post noninterruptive user notifications" (https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/lib/permission_handler.dart#L154C29-L154C96)
    */
    log('checking permissions', name: '$runtimeType');

    bool locationGranted = false;
    bool locationAlwaysGranted = false;
    bool notificationGranted = false;

    await Permission.location.onGrantedCallback(() {
      locationGranted = true;
      log('location granted', name: '$runtimeType');
    }).onDeniedCallback(() {
      log('location denied', name: '$runtimeType');
    }).onPermanentlyDeniedCallback(() {
      log('location permanently denied', name: '$runtimeType');
    }).onProvisionalCallback(() {
      log('location provisional', name: '$runtimeType');
    }).request();

    await Permission.locationAlways.onGrantedCallback(() {
      log('locationAlways granted', name: '$runtimeType');
      locationAlwaysGranted = true;
    }).onDeniedCallback(() {
      log('locationAlways denied', name: '$runtimeType');
    }).onPermanentlyDeniedCallback(() {
      log('locationAlways permanently denied', name: '$runtimeType');
    }).onProvisionalCallback(() {
      log('locationAlways provisional', name: '$runtimeType');
    }).request();

    await Permission.notification.onGrantedCallback(() {
      log('notification granted', name: '$runtimeType');
      notificationGranted = true;
    }).onDeniedCallback(() {
      log('notification denied', name: '$runtimeType');
    }).onPermanentlyDeniedCallback(() {
      log('notification permanently denied', name: '$runtimeType');
    }).onProvisionalCallback(() {
      log('notification provisional', name: '$runtimeType');
    }).request();

    bool overallGranted =
        locationGranted && locationAlwaysGranted && notificationGranted;
    _ref.read(arePermissionsGrantedStateProvider.notifier).state =
        overallGranted;
    log('overallGranted = $overallGranted', name: '$runtimeType');

    if (!overallGranted) {
      log("permissions not granted, core functionality will not work",
          name: '$runtimeType');
    }

    return overallGranted;
  }
}
