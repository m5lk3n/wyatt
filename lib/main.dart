import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/app_routes.dart';
import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wyatt/services/storage.dart';

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

  initPersistentLocalStorage(); // TODO: move to CoreService?
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
