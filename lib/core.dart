import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wyatt/providers/permissions_provider.dart';

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
/*
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
*/
    notificationGranted =
        true; // TODO: remove this line, replace with above block

    bool overallGranted =
        locationGranted && locationAlwaysGranted && notificationGranted;
    _ref.read(arePermissionsGrantedStateProvider.notifier).state =
        overallGranted;
    log('overallGranted = $overallGranted', name: '$runtimeType');

    if (!overallGranted) {
      log("permissions not granted, service can't be started",
          name: '$runtimeType');
    }

    return overallGranted;
  }
}
