import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wyatt/app_routes.dart';
import 'package:wyatt/providers/key_provider.dart';
import 'package:wyatt/screens/settings.dart';

// ignore: must_be_immutable
class WyattAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  bool isOnSettingsScreen = false;
  bool isSettingUp = false;

  WyattAppBar(
    BuildContext context,
    this.title, {
    super.key,
  }) {
    isOnSettingsScreen = context.widget is SettingsScreen;
    if (isOnSettingsScreen) {
      final screen = context.widget as SettingsScreen;
      isSettingUp = screen.inSetupMode;
    }
  }

  @override
  PreferredSizeWidget build(BuildContext context, WidgetRef ref) {
    final bool isKeyValid = ref.watch(isKeyValidStateProvider);

    final txtSuffix = isOnSettingsScreen
        ? "\n\nPlease obtain a new key."
        : "\n\nYou can change the key in Settings.";

    log("WyattAppBar: context.widget = ${context.widget}");

    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/appbar-bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      title: Text(title),
      actions: isKeyValid || isSettingUp
          ? null
          : <Widget>[
              // TODO: lightbulb icon to seed
              IconButton(
                icon: Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.onError,
                        title: Text("Error",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.error)),
                        content: Text(
                            "The key is invalid, the app won't work!$txtSuffix",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                        actions: <Widget>[
                          isOnSettingsScreen
                              ? SizedBox.shrink()
                              : TextButton(
                                  child: Text("Go to Settings"),
                                  onPressed: () {
                                    context.go(AppRoutes.settings);
                                  },
                                ),
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
