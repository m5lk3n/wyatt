import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/providers/startup_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(startupNotifierProvider);
    log('SplashScreen: startup = $startup');

    // schedule a callback to run after the frame has been rendered to avoid "setState() ... called during build" error
    // https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!startup.isLoading) {
        if (startup.hasNoKey) {
          log('SplashScreen: no key -> welcome');
          context.go('/welcome');
        } else if (startup.hasInvalidKey) {
          log('SplashScreen: invalid key -> settings');
          context.go('/settings');
        } else {
          log('SplashScreen: else -> reminders');
          context.go('/reminders');
        }
      }
    });

    return Scaffold(
      body: Center(
        child: Container(
          color: seedColor,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2 * bigSpace),
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
                    CircularProgressIndicator(),
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
                  padding: const EdgeInsets.only(bottom: bigSpace),
                  child: GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(Common.devUrl));
                    },
                    child:
                        Image.asset('assets/images/logo.png', height: bigSpace),
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
