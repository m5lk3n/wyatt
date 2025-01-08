import 'dart:math';
import 'dart:ui';
import 'dart:developer'
    as dev; // don't use 'package:wyatt/log.dart' here, as it's not available in the background isolate where this code runs

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// https://amandevblogs.hashnode.dev/flutter-local-notifications-with-workmanager
class NotificationService {
  NotificationService();

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // TODO: iOS: initializationSettingsIOS
    );

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse);
  }

  void onDidReceiveLocalNotification(NotificationResponse? response) {
    var data = response?.payload.toString();

    // if (response!.id == 0) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => SecondScreen(data: response.payload!),
    //       ));
    // } else {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => ThirdScreen(),
    //       ));
    // }

    dev.log('$data', name: 'onDidReceiveLocalNotification');
  }

  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse? response) {
    var data = response?.payload.toString();

    dev.log('$data', name: 'onDidReceiveBackgroundNotificationResponse');
  }

  // void selectNotification(String? payload) {
  //   if (payload != null && payload.isNotEmpty) {}
  // }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'dev.lttl.wyatt', // avoids: Unhandled Exception: LateInitializationError: Field 'packageName' has not been initialized.
      'Wyatt', // avoids: Unhandled Exception: LateInitializationError: Field 'appName' has not been initialized.
      groupKey: 'dev.lttl.wyatt', // groups alerts in the notification tray
      channelDescription: 'Wyatt reminders',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      color: Color((Random().nextDouble() * 0xFFFFFF)
          .toInt()), // let's make each notification a different color to make them easier to distinguish
    );

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {}
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    return platformChannelSpecifics;
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
/*
  Future<void> showScheduledLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int seconds,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      platformChannelSpecifics,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showPeriodicLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
*/
}
