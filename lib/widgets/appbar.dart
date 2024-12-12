import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:wyatt/app_routes.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/providers/key_provider.dart';
import 'package:wyatt/providers/permissions_provider.dart';
import 'package:wyatt/screens/reminder.dart';
import 'package:wyatt/screens/reminders.dart';
import 'package:wyatt/screens/settings.dart';
import 'package:wyatt/helper.dart';

class WyattAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final BuildContext context;
  final String title;

  const WyattAppBar({super.key, required this.context, required this.title});

  @override
  ConsumerState<WyattAppBar> createState() => _WyattAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _WyattAppBarState extends ConsumerState<WyattAppBar> {
  bool isOnSettingsScreen = false;
  bool isOnRemindersScreen = false;
  bool isSettingUp = false;
  bool isOnline =
      true; // initially optimistic, will be updated by the listener in initState()
  late StreamSubscription<InternetStatus> connectionListener;

  @override
  void initState() {
    super.initState();

    isOnSettingsScreen = widget.context.widget is SettingsScreen;
    isOnRemindersScreen = widget.context.widget is RemindersScreen;
    if (isOnSettingsScreen) {
      final screen = widget.context.widget as SettingsScreen;
      isSettingUp = screen.inSetupMode;
    }

    connectionListener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          log('Internet connected', name: '$runtimeType');
          if (mounted) {
            setState(() {
              isOnline = true;
            });
          }
          break;
        case InternetStatus.disconnected:
          log('Internet disconnected', name: '$runtimeType');
          if (mounted) {
            setState(() {
              isOnline = false;
            });
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    connectionListener.cancel();

    super.dispose();
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    final bool isKeyValid = ref.watch(isKeyValidStateProvider);
    final bool arePermissionsGranted =
        ref.watch(arePermissionsGrantedStateProvider);

    log('arePermissionsGranted = $arePermissionsGranted', name: '$runtimeType');
    log('isOnline = $isOnline', name: '$runtimeType');
    log("context.widget = ${widget.context.widget}", name: '$runtimeType');

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
      title: Text(widget.title),
      actions: (isOnline && arePermissionsGranted && isKeyValid) || isSettingUp
          ? isOnRemindersScreen
              ? <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ReminderScreen()));
                    },
                  ),
                ]
              : null
          : !isOnline
              ? _createConnectivityWarningAction(context)
              : !isKeyValid
                  ? _createKeyErrorAction(context)
                  : !arePermissionsGranted
                      ? _createPermissionErrorAction(context)
                      : null,
    );
  }

  List<Widget> _createConnectivityWarningAction(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.wifi_off,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.onError,
                  title: Text("Error",
                      style: Style.getErrorDialogTitleStyle(context)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "The app won't work properly without an Internet connection.",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      SizedBox(height: Style.space / 2),
                      Text(
                        "Please connect to the Internet, try again (later).",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
      )
    ];
  }

  List<Widget> _createPermissionErrorAction(BuildContext context) {
    return <Widget>[
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
                    style: Style.getErrorDialogTitleStyle(context)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "The app won't work without certain permissions.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: Style.space / 2),
                    Text(
                      "Please grant the permissions in ${_getOSName(context)} Settings.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: Style.space / 2),
                    InkWell(
                        child: Text(
                          'Learn how, and which permissions are needed as well as why.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).colorScheme.primary,
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        onTap: () => browseTo(Url.permissions)),
                  ],
                ),
                actions: <Widget>[
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
    ];
  }

  List<Widget> _createKeyErrorAction(BuildContext context) {
    final txtSuffix = isOnSettingsScreen
        ? "\n\nPlease obtain a new key."
        : "\n\nYou can change the key in Settings.";

    return <Widget>[
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
                    style: Style.getErrorDialogTitleStyle(context)),
                content: Text(
                    "The key is invalid, the app won't work!$txtSuffix",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
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
    ];
  }

  String _getOSName(BuildContext context) {
    /* switch (Platform.operatingSystem) { ... } is slicker but comparison is based upon
       string values which might change in the future (see remarks in dart.io's platform.dart)
       sp, let's use the more verbose (and "auto-testable") way
    */
    if (Common.isAndroid(context)) {
      return 'Android';
    } else if (Common.isIOS(context)) {
      return 'iOS';
    } else {
      return 'OS';
    }
  }
}
