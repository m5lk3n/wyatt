import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:wyatt/screens/setup.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const WyattApp());
}

class WyattApp extends StatelessWidget {
  const WyattApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wyatt',
      theme: theme,
      home: const WyattSetupScreen(title: 'Wyatt Setup'),
    );
  }
}
