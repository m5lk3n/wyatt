import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/helper.dart';
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
                  padding: const EdgeInsets.only(top: 2 * Style.bigSpace),
                  child: AppIcon(),
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
                    SizedBox(height: Style.space),
                    Padding(
                      padding: const EdgeInsets.all(Style.space),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              textAlign: TextAlign.center,
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
                    SizedBox(height: Style.space),
                    Text('When You Are There, Then...',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontStyle: FontStyle.italic)),
                    SizedBox(height: Style.space),
                    Padding(
                      padding: const EdgeInsets.all(Style.space),
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
                            onPressed: () async {
                              if (await confirm(
                                context,
                                title: const Text('Important'),
                                content: Column(
                                  children: [
                                    const Text(
                                        'Wyatt needs permission to access your location and to send you notifications.\n\nPlease grant these permissions if asked next.'),
                                    SizedBox(height: Style.space),
                                    InkWell(
                                        child: Text(
                                          'Learn about the how and why.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                        onTap: () => browseTo(Url.permissions)),
                                  ],
                                ),
                                textOK: const Text('Continue'),
                                textCancel: const Text('Cancel'),
                              )) {
                                Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsScreen(
                                      title: Screen.setup,
                                      inSetupMode: true,
                                    ),
                                  ),
                                );
                              }
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
              Common.isIOS(
                      context) // TODO/FIXME: fix font size for iOS, and put the bottom back in
                  ? SizedBox.shrink()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Style.bigSpace),
                        child: Logo(),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
