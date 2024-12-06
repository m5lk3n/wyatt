import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wyatt/app_routes.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/providers/key_provider.dart';
import 'package:wyatt/providers/startup_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  /* TODO: add checks

  check internet connectivity

  check https://pub.dev/packages/location

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  import 'package:permission_handler/permission_handler.dart';

  void setPermissions() async{
   Map<PermissionGroup, PermissionStatus> permissions = 
   await PermissionHandler().requestPermissions([PermissionGroup.location]);
  }
  */

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(startupNotifierProvider);
    log('startup = $startup', name: 'SplashScreen');

    // schedule a callback to run after the frame has been rendered to avoid "setState() ... called during build" error
    // https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!startup.isLoading) {
        if (startup.hasNoKey) {
          log('no key -> welcome', name: 'SplashScreen');
          ref.read(isKeyValidStateProvider.notifier).state = false;
          context.go(AppRoutes.welcome);
        } else if (startup.hasInvalidKey) {
          log('invalid key -> settings', name: 'SplashScreen');
          ref.read(isKeyValidStateProvider.notifier).state = false;
          context.go(AppRoutes.settings);
        } else {
          log('else -> reminders', name: 'SplashScreen');
          ref.read(isKeyValidStateProvider.notifier).state = true;
          context.go(AppRoutes.reminders);
        }
      }
    });

    return Scaffold(
      body: Center(
        child: Container(
          color: Common.seedColor,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2 * Common.bigSpace),
                  child: ClipOval(
                    child: Image.asset('assets/icon/icon.png', height: 100),
                  ),
                ),
              ),
              Text(Common.appName,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator.adaptive(),
                    Text('Saddling up...',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Common.bigSpace),
                  child: GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(Common.devUrl));
                    },
                    child: Image.asset('assets/images/logo.png',
                        height: Common.bigSpace),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
