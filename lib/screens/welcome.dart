import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/screens/settings.dart';
import 'package:wyatt/widgets/common.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        createBackground(context),
        Center(
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary, //onSecondary,
                      )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Howdy!',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                    SizedBox(height: space),
                    Padding(
                      padding: const EdgeInsets.all(space),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Welcome to Wyatt, a location- and time-based reminder app.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: space),
                    Text('When You Are There, Then...',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontStyle: FontStyle.italic)),
                    SizedBox(height: space),
                    Padding(
                      padding: const EdgeInsets.all(space),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(
                                    title: Common.screenSetup,
                                    inSetupMode: true,
                                  ),
                                ),
                              );
                            },
                            autofocus: true,
                            child: Text('Let\'s get started',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    )),
                          ),
                        ],
                      ),
                    ),
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
      ],
    );
  }
}