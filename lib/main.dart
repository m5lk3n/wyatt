import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:wyatt/screens/ltds.dart';
//import 'package:wyatt/screens/setup.dart';
import 'package:package_info_plus/package_info_plus.dart';

// https://www.geeksforgeeks.org/how-to-capitalize-the-first-letter-of-a-string-in-flutter/
extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// see https://appainter.dev/
final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color.fromARGB(255, 121, 85,
          72) // = fully opaque (255) "Brown [500] Roman Coffee" with #795548 = 121, 85, 72
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

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // TODO
  ]).then((fn) {
    runApp(const WyattApp());
  });
}

class WyattApp extends StatelessWidget {
  const WyattApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Common.appName,
        theme: theme,
        home: LtdsScreen() // SetupScreen(title: 'Set up ${Common.appName}'),
        );
  }
}
