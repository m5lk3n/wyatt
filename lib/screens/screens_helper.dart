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

    await Permission.location.onGrantedCallback(() {
      _setPermissionsGranted('location granted');
    }).onDeniedCallback(() {
      _setPermissionsDenied('location denied');
    }).onPermanentlyDeniedCallback(() {
      _setPermissionsDenied('location permanently denied');
    }).onProvisionalCallback(() {
      _setPermissionsDenied('location provisional');
    }).request();

    await Permission.locationAlways.onGrantedCallback(() {
      _setPermissionsGranted('locationAlways granted');
    }).onDeniedCallback(() {
      _setPermissionsDenied('locationAlways denied');
    }).onPermanentlyDeniedCallback(() {
      _setPermissionsDenied('locationAlways permanently denied');
    }).onProvisionalCallback(() {
      _setPermissionsDenied('locationAlways provisional');
    }).request();

    await Permission.notification.onGrantedCallback(() {
      _setPermissionsGranted('notification granted');
    }).onDeniedCallback(() {
      _setPermissionsDenied('notification denied');
    }).onPermanentlyDeniedCallback(() {
      _setPermissionsDenied('notification permanently denied');
    }).onProvisionalCallback(() {
      _setPermissionsDenied('notification provisional');
    }).request();
  }

  void _setPermissionsGranted(String debugMessage) {
    log(debugMessage, name: 'PermissionsHelper');
    ref.read(arePermissionsGrantedStateProvider.notifier).state = true;
  }

  void _setPermissionsDenied(String debugMessage) {
    log(debugMessage, name: 'PermissionsHelper');
    ref.read(arePermissionsGrantedStateProvider.notifier).state = false;
  }
}
