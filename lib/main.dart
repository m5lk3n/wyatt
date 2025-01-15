import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wyatt/app_routes.dart';
import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'package:wyatt/core.dart';
import 'package:wyatt/log.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/notifications.dart';
import 'package:wyatt/services/storage.dart';
import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    initLogging();
    log.debug('executing workmanager task: $taskName');
    try {
      /* doesn't work:
      Location location = Location();
      location.enableBackgroundMode(enable: true);
      LocationData currentLocation = await location.getLocation(); // throws a java.lang.NullPointerException, hence we use Geolocator
      */
      DartPluginRegistrant.ensureInitialized(); // required for geolocation
      Position currentLocation = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings());
      log.debug(
          'retrieved current geolocation ${currentLocation.latitude}, ${currentLocation.longitude}');

      List<Reminder> remindersInRange =
          await getBackgroundRemindersInRangeAndTime(
              currentLocation.latitude, currentLocation.longitude);

      String message = '';
      for (Reminder reminder in remindersInRange) {
        message += message.isEmpty ? '$reminder' : ', $reminder';
      }

      if (message.trim().isEmpty) {
        log.debug('message is empty, skipping notification');
      } else {
        await NotificationService().showLocalNotification(
            id: 0,
            title: "Howdy!",
            body: "Wyatt reminds you: $message",
            payload: "");
      }
    } catch (e) {
      log.error(
        'error executing workmanager task',
        error: e,
      );
    }

    return Future.value(true);
  });
}

// https://www.geeksforgeeks.org/how-to-capitalize-the-first-letter-of-a-string-in-flutter/
extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

Future<void> initApp() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Common.appName = packageInfo.appName.capitalize();
  Common.appVersion = packageInfo.version;
  Common.packageName = packageInfo.packageName;

  initWorkmanager();
  initLogging();
  initPersistentLocalStorage();
}

void initWorkmanager() async {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode:
        false, // we use flutter_local_notifications in callbackDispatcher
  );
  await NotificationService().initializePlatformNotifications();
  Workmanager().registerPeriodicTask(
    Common.packageName,
    Common.appName,
    initialDelay: Duration(seconds: 5),
    frequency: Duration(minutes: 15), // min. 15min as per OS
  );
  tz.initializeTimeZones();

  log.debug('workmanager initialized');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // TODO
  ]).then((fn) {
    runApp(const ProviderScope(
      child: WyattApp(),
    ));
  });
}

class WyattApp extends ConsumerWidget {
  const WyattApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRoutes().createRouter(ref);

    return MaterialApp.router(
        // TODO: CupertinoApp.router?
        title: Common.appName,
        theme: Style.theme,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider);
  }
}
