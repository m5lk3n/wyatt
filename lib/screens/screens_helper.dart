import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wyatt/providers/permissions_provider.dart';
import 'package:wyatt/providers/settings_provider.dart';

Future<void> readDefaultNotificationDistance(
  WidgetRef ref,
  TextEditingController controller,
) async {
  final settings = ref.read(settingsNotifierProvider.notifier);
  int distance = await settings.getDefaultNotificationDistance();

  controller.text = distance.toString();
}

class PermissionsHelper {
  final WidgetRef ref;

  PermissionsHelper(this.ref);

  Future<void> checkPermissions() async {
    /* we'll not check the following permission callbacks here:

       - onRestrictedCallback is for "active restrictions such as parental controls" (iOS only) (https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/lib/permission_handler.dart#L138)
       - onLimitedCallback is "for limited photo library access" (iOS only) (https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/lib/permission_handler.dart#L143C44-L143C76)

       generell remarks reg.

       - onGrantedCallback is needed as permissions can be granted during app usage
       - onPermanentlyDeniedCallback: no new permission dialog will be shown, redirect user to App settings page for permissions
       - onProvisionalCallback: iOS only, "provisionally authorized to post noninterruptive user notifications" (https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/lib/permission_handler.dart#L154C29-L154C96)
    */
    log('checking permissions', name: 'PermissionsHelper');

    bool locationGranted = false;
    bool locationAlwaysGranted = false;
    bool notificationGranted = false;

    await Permission.location.onGrantedCallback(() {
      locationGranted = true;
      log('location granted', name: 'PermissionsHelper');
    }).onDeniedCallback(() {
      log('location denied', name: 'PermissionsHelper');
    }).onPermanentlyDeniedCallback(() {
      log('location permanently denied', name: 'PermissionsHelper');
    }).onProvisionalCallback(() {
      log('location provisional', name: 'PermissionsHelper');
    }).request();

    await Permission.locationAlways.onGrantedCallback(() {
      log('locationAlways granted', name: 'PermissionsHelper');
      locationAlwaysGranted = true;
    }).onDeniedCallback(() {
      log('locationAlways denied', name: 'PermissionsHelper');
    }).onPermanentlyDeniedCallback(() {
      log('locationAlways permanently denied', name: 'PermissionsHelper');
    }).onProvisionalCallback(() {
      log('locationAlways provisional', name: 'PermissionsHelper');
    }).request();

    await Permission.notification.onGrantedCallback(() {
      log('notification granted', name: 'PermissionsHelper');
      notificationGranted = true;
    }).onDeniedCallback(() {
      log('notification denied', name: 'PermissionsHelper');
    }).onPermanentlyDeniedCallback(() {
      log('notification permanently denied', name: 'PermissionsHelper');
    }).onProvisionalCallback(() {
      log('notification provisional', name: 'PermissionsHelper');
    }).request();

    bool overallGranted =
        locationGranted && locationAlwaysGranted && notificationGranted;
    ref.read(arePermissionsGrantedStateProvider.notifier).state =
        overallGranted;
    log('overallGranted = $overallGranted', name: 'PermissionsHelper');
  }
}
