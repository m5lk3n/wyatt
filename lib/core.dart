import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wyatt/log.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/providers/permissions_provider.dart';

const String isolateExchangeDataKey = 'dev.lttl.wyatt.isolateExchangeData';

void setBackgroundReminders(List<Reminder> activeReminders) async {
  log.debug(
      'setting ${activeReminders.length} active reminders in shared preferences');

  List<String> remindersAsStringList =
      activeReminders.map((r) => jsonEncode(r.toJson())).toList();
  SharedPreferencesAsync()
      .setStringList(isolateExchangeDataKey, remindersAsStringList);
}

Future<List<Reminder>> getBackgroundRemindersInRangeAndTime(
    double currentLatitude, double currentLongitude) async {
  List<Reminder> remindersInRangeAndTime = [];
  try {
    List<String>? remindersAsStringList =
        await SharedPreferencesAsync().getStringList(isolateExchangeDataKey);

    if (remindersAsStringList == null || remindersAsStringList.isEmpty) {
      log.debug(
          'no reminders in shared preferences, skipping range and time check');
      return [];
    }

    List<Reminder> reminders = remindersAsStringList
        .map((jsonString) => Reminder.fromJson(jsonDecode(jsonString)))
        .toList();

    log.debug(
        '${reminders.length} reminders in shared preferences: $reminders');

    remindersInRangeAndTime = reminders.where((reminder) {
      return reminder.hasBegun() &&
          reminder.isNotExpired() &&
          reminder.isInRange(LocationData.fromMap(
              {'latitude': currentLatitude, 'longitude': currentLongitude}));
    }).toList();
    log.debug(
        '${remindersInRangeAndTime.length} reminders in range and in time');
  } catch (e) {
    log.error('error getting reminders in range and time', error: e);
    remindersInRangeAndTime = [];
  }

  return remindersInRangeAndTime;
}

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
    log.debug('checking permissions', name: '$runtimeType');

    bool locationGranted = false;
    bool locationAlwaysGranted = false;
    bool notificationGranted = false;

    await Permission.location.onGrantedCallback(() {
      locationGranted = true;
      log.debug('location granted', name: '$runtimeType');
    }).onDeniedCallback(() {
      log.debug('location denied', name: '$runtimeType');
    }).onPermanentlyDeniedCallback(() {
      log.debug('location permanently denied', name: '$runtimeType');
    }).onProvisionalCallback(() {
      log.debug('location provisional', name: '$runtimeType');
    }).request();

    await Permission.locationAlways.onGrantedCallback(() {
      log.debug('locationAlways granted', name: '$runtimeType');
      locationAlwaysGranted = true;
    }).onDeniedCallback(() {
      log.debug('locationAlways denied', name: '$runtimeType');
    }).onPermanentlyDeniedCallback(() {
      log.debug('locationAlways permanently denied', name: '$runtimeType');
    }).onProvisionalCallback(() {
      log.debug('locationAlways provisional', name: '$runtimeType');
    }).request();

    await Permission.notification.onGrantedCallback(() {
      log.debug('notification granted', name: '$runtimeType');
      notificationGranted = true;
    }).onDeniedCallback(() {
      log.debug('notification denied', name: '$runtimeType');
    }).onPermanentlyDeniedCallback(() {
      log.debug('notification permanently denied', name: '$runtimeType');
    }).onProvisionalCallback(() {
      log.debug('notification provisional', name: '$runtimeType');
    }).request();

    bool overallGranted =
        locationGranted && locationAlwaysGranted && notificationGranted;
    _ref.read(arePermissionsGrantedStateProvider.notifier).state =
        overallGranted;
    log.debug('overallGranted = $overallGranted', name: '$runtimeType');

    if (!overallGranted) {
      log.release('permissions not granted, core functionality will not work',
          name: '$runtimeType');
    }

    return overallGranted;
  }
}
