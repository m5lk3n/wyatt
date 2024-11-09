import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wyatt/common.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        color: Theme.of(context).colorScheme.onSecondary,
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
                      launchUrl(Uri.parse('https://lttl.dev'));
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
