import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/screens/ltds.dart';
import 'package:wyatt/screens/settings.dart';
import 'package:wyatt/screens/splash.dart';
import 'package:wyatt/screens/welcome.dart';

class AppRoutes {
  GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => WelcomeScreen(),
        ),
        GoRoute(
          path: '/reminders',
          builder: (context, state) => LtdsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    );
  }
}
