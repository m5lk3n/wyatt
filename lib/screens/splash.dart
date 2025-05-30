import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wyatt/app_routes.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/log.dart';
import 'package:wyatt/providers/key_provider.dart';
import 'package:wyatt/providers/startup_provider.dart';
import 'package:wyatt/widgets/common.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(startupNotifierProvider);
    log.debug('startup = $startup', name: '$runtimeType');

    // schedule a callback to run after the frame has been rendered to avoid "setState() ... called during build" error
    // https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!startup.isLoading) {
        if (startup.hasNoKey) {
          log.debug('no key -> welcome', name: '$runtimeType');
          ref.read(isKeyValidStateProvider.notifier).state = false;
          context.go(AppRoutes.welcome);
        } else if (startup.hasInvalidKey) {
          log.debug('invalid key -> settings', name: '$runtimeType');
          ref.read(isKeyValidStateProvider.notifier).state = false;
          context.go(AppRoutes.settings);
        } else {
          log.debug('else -> reminders', name: '$runtimeType');
          ref.read(isKeyValidStateProvider.notifier).state = true;
          context.go(AppRoutes.reminders);
        }
      }
    });

    return Scaffold(
      body: Center(
        child: Container(
          color: Style.seedColor,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2 * Style.bigSpace),
                  child: AppIcon(),
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
                  padding: const EdgeInsets.only(bottom: Style.bigSpace),
                  child: Logo(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
