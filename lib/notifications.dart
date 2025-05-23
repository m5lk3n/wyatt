import 'dart:math';
import 'dart:ui';
import 'dart:developer'
    as dev; // don't use 'package:wyatt/log.dart' here, as it's not available in the background isolate where this code runs

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// https://amandevblogs.hashnode.dev/flutter-local-notifications-with-workmanager
class NotificationService {
  NotificationService();

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse);
  }

  void onDidReceiveLocalNotification(NotificationResponse? response) {
    var data = response?.payload.toString();

    dev.log('$data', name: 'onDidReceiveLocalNotification');
  }

  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse? response) {
    var data = response?.payload.toString();

    dev.log('$data', name: 'onDidReceiveBackgroundNotificationResponse');
  }

  Future<NotificationDetails> _notificationDetails() async {
    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {}
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: _createAndroidNotificationDetails(),
      iOS: _createDarwinNotificationDetails(),
    );

    return platformChannelSpecifics;
  }

  AndroidNotificationDetails _createAndroidNotificationDetails() {
    return AndroidNotificationDetails(
      'dev.lttl.wyatt', // avoids: Unhandled Exception: LateInitializationError: Field 'packageName' has not been initialized.
      'Wyatt', // avoids: Unhandled Exception: LateInitializationError: Field 'appName' has not been initialized.
      groupKey: 'dev.lttl.wyatt', // groups alerts in the notification tray
      channelDescription: 'Wyatt reminders',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([
        0,
        1000,
        500,
        1000
      ]), // no initial delay, vibrate for 1s, wait for 0.5, vibrate for 1s
      playSound: false,
      color: Color((Random().nextDouble() * 0xFFFFFF)
          .toInt()), // let's make each notification a different color to make them easier to distinguish
    );
  }

  DarwinNotificationDetails _createDarwinNotificationDetails() {
    return DarwinNotificationDetails(
      threadIdentifier: 'dev.lttl.wyatt', // group notifications together
      categoryIdentifier:
          'plainCategory', // see https://github.com/MaikuB/flutter_local_notifications/blob/master/flutter_local_notifications/example/lib/main.dart#L62
    );
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    dev.log('id: $id, title: $title, body: $body, payload: $payload',
        name: 'showLocalNotification');

    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
