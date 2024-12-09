import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofence_foreground_service/constants/geofence_event_type.dart';
import 'package:geofence_foreground_service/geofence_foreground_service.dart';
import 'package:geofence_foreground_service/models/notification_icon_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/providers/permissions_provider.dart';

bool isCoreServiceStarted = false;

@pragma('vm:entry-point')
void callbackDispatcher() async {
  GeofenceForegroundService().handleTrigger(
    backgroundTriggerHandler: (zoneId, triggerType) {
      log('trigger ID: $zoneId', name: 'callbackDispatcher');

      if (triggerType == GeofenceEventType.enter) {
        log('triggerType: enter', name: 'callbackDispatcher');
      } else if (triggerType == GeofenceEventType.exit) {
        log('triggerType: exit', name: 'callbackDispatcher');
      } else if (triggerType == GeofenceEventType.dwell) {
        log('triggerType: dwell', name: 'callbackDispatcher');
      } else {
        log('triggerType: unknown', name: 'callbackDispatcher');
      }

      return Future.value(true);
    },
  );
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

    if (overallGranted) {
      _startService();
    } else {
      isCoreServiceStarted = false; // reset if previously started
      log("permissions not granted, service can't be started",
          name: '$runtimeType');
    }

    return overallGranted;
  }

  Future<void> _startService() async {
    if (isCoreServiceStarted) {
      return;
    }

    isCoreServiceStarted =
        await GeofenceForegroundService().startGeofencingService(
      contentTitle: '${Common.appName} is riding in the back',
      contentText:
          "${Common.appName} will be running in the background to ensure you're not missing a reminder.",
      notificationChannelId:
          'com.app.geofencing_notifications_channel', // TODO: change?
      serviceId: 525600, // TODO: change?
      isInDebugMode: kDebugMode,
      notificationIconData: const NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
      ),
      callbackDispatcher: callbackDispatcher,
    );

    log('service start status: $isCoreServiceStarted', name: '$runtimeType');
  }

  // TODO: handle result
  void registerReminder(Reminder reminder) async {
    if (!isCoreServiceStarted) {
      log('service not started, skipping registration for reminder ${reminder.id}',
          name: '$runtimeType');
      return;
    }

    if (!reminder.enabled) {
      log('reminder ${reminder.id} is disabled, skipping registration',
          name: '$runtimeType');
      return;
    }

    await GeofenceForegroundService()
        .addGeofenceZone(
      zone: reminder.asZone(),
    )
        .then((result) {
      log('result registering reminder ${reminder.id}: $result',
          name: '$runtimeType');
    }).onError((error, stackTrace) {
      log('error registering reminder ${reminder.id}: $error',
          name: '$runtimeType');
    });
  }

  // TODO: handle result
  void cancelReminder(Reminder reminder) async {
    if (!isCoreServiceStarted) {
      log('service not started, skipping cancelation of reminder ${reminder.id}',
          name: '$runtimeType');
      return;
    }

    await GeofenceForegroundService()
        .removeGeofenceZone(
      zoneId: reminder.id!,
    )
        .then((result) {
      log('result canceling reminder ${reminder.id}: $result',
          name: '$runtimeType');
    }).onError((error, stackTrace) {
      log('error canceling reminder ${reminder.id}: $error',
          name: '$runtimeType');
    });
  }
}
