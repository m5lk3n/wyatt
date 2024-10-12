import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:wyatt/screens/setup.dart';
import 'package:package_info_plus/package_info_plus.dart';

// https://www.geeksforgeeks.org/how-to-capitalize-the-first-letter-of-a-string-in-flutter/
extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.robotoSlabTextTheme(), // GoogleFonts.latoTextTheme(),
);

Future<void> initApp() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Common.appName = packageInfo.appName.capitalize();
  Common.appVersion = packageInfo.version;
  Common.packageName = packageInfo.packageName;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initApp();

  runApp(const WyattApp());
}

class WyattApp extends StatelessWidget {
  const WyattApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Common.appName,
      theme: theme,
      home: WyattSetupScreen(title: 'Set up ${Common.appName}'),
    );
  }
}
