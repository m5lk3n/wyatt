import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/screens/reminders.dart';
import 'package:wyatt/screens/settings.dart';
import 'package:wyatt/screens/splash.dart';
import 'package:wyatt/screens/welcome.dart';

class AppRoutes {
  static const welcome = '/welcome';
  static const splash = '/splash';
  static const reminders = '/reminders';
  static const settings = '/settings';

  GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: splash,
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: welcome,
          builder: (context, state) => WelcomeScreen(),
        ),
        GoRoute(
          path: reminders,
          builder: (context, state) => RemindersScreen(),
        ),
        GoRoute(
          path: settings,
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    );
  }
}
