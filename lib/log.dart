import 'dart:io';

import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;

import 'package:path_provider/path_provider.dart';

// https://stackoverflow.com/questions/75859813/retrieve-logs-from-customer-device-in-flutter

final log = Logger('WyattApp');

extension LogExtensions on Logger {
  void prod(String message, {String name = 'WyattApp'}) {
    log.fine('[PROD] $name: $message', error);
  }

  void error(String message, {String name = 'WyattApp', Object? error}) {
    log.finer('[ERROR] $name: $message', error);
  }

  void debug(String message, {String name = 'WyattApp'}) {
    log.finest('[DEBUG] $name: $message');
  }
}

Future<void> initLogging() async {
  if (kDebugMode && Platform.isAndroid /* doesn't work on iOS */) {
    // log everything to stdout and logfile
    Logger.root.level = Level.ALL;
    final file = await _localFile;
    Logger.root.onRecord.listen((record) {
      final String logMessage = '${record.time}: ${record.message}';
      dev.log(logMessage); // use dev.log to integrate with Flutter DevTools
      file.writeAsStringSync(
        '$logMessage\n',
        mode: FileMode.append,
        flush: true, // TODO: check if this is necessary
      );
    });
  } /* else {
    Logger.root.level = Level.INFO; // is also the default
    Logger.root.onRecord.listen((record) {
      // TODO: write log to file, or use something like crashlytics, e.g.
      // FirebaseCrashlytics.instance.log('${record.time}: ${record.message}');
    });
  }*/
}

Future<String> get _localPath async {
  final directory =
      // getTemporaryDirectory() // /data/user/0/dev.lttl.wyatt/cache - nothing found here
      // getApplicationDocumentsDirectory() // /data/user/0/dev.lttl.wyatt/app_flutter - nothing found here
      await getExternalStorageDirectory(); // /storage/emulated/0/Android/data/dev.lttl.wyatt/files

  return directory!.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  final logFile =
      '$path/wyatt-debug-log.txt'; // don't call it .log, as it's recognized as a bininary file on Android

  dev.log('logging to $logFile', name: 'initLogging');

  return File(logFile);
}
