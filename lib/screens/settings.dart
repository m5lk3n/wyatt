import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wyatt/app_routes.dart';
import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';
import 'package:wyatt/core.dart';
import 'package:wyatt/helper.dart';
import 'package:wyatt/providers/key_provider.dart';
import 'package:wyatt/providers/reminders_provider.dart';
import 'package:wyatt/providers/settings_helper.dart';
import 'package:wyatt/providers/settings_provider.dart';
import 'package:wyatt/screens/screens_helper.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/common.dart';
import 'package:restart_app/restart_app.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({
    super.key,
    this.title = Screen.settings,
    this.inSetupMode = false,
  });

  final String title;
  final bool inSetupMode;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _keyController = TextEditingController();
  final _distanceController = TextEditingController();

  late final bool _isSettingUp;
  bool _isProcessing = false;
  bool _isObscured = true;

  final _formKey = GlobalKey<FormState>();
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    _isSettingUp = widget.inSetupMode;

    CoreSystem(ref).checkPermissions();
    _readKey();
    if (!_isSettingUp) {
      readDefaultNotificationDistance(ref, _distanceController);
    }

    _tapGestureRecognizer = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _keyController.dispose();
    _distanceController.dispose();

    _tapGestureRecognizer.dispose();

    super.dispose();
  }

  Future<void> _readKey() async {
    final settings = ref.read(settingsNotifierProvider.notifier);

    String key = await settings.getKey();

    _keyController.text = key;
  }

  Future<bool> _saveKey() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    final ThemeData themeData = Theme.of(context);

    final keyValue = _keyController.text
        .trim(); // we know here it's not empty as it was validated before

    final settings = ref.read(settingsNotifierProvider.notifier);
    settings.setKey(keyValue);

    if (await KeyValidator.validateKey(keyValue)) {
      scaffold.showSnackBar(SnackBar(content: Text('The key is valid.')));
      ref.read(isKeyValidStateProvider.notifier).state = true;
      return true;
    } else {
      ref.read(isKeyValidStateProvider.notifier).state = false;
      scaffold.showSnackBar(SnackBar(
          backgroundColor: themeData.colorScheme.error,
          content: Text('The key is invalid, the app won\'t work!')));
    }

    return false;
  }

  Future<void> _saveDefaultNotificationDistance() async {
    if (_distanceController.text.trim().isEmpty) {
      return;
    }

    final settings = ref.read(settingsNotifierProvider.notifier);
    settings
        .setDefaultNotificationDistance(int.parse(_distanceController.text));

    setState(() {
      readDefaultNotificationDistance(
          ref, _distanceController); // show parsed value, e.g. 0500 -> 500
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget distanceField = createDistanceField(
      context,
      _distanceController,
      _isProcessing,
    );
    Widget notificationsIntervalField = SizedBox.shrink(); // TODO: implement

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // goes along with SingleChildScrollView below to allow keyboard to slide up and not cover input fields (https://stackoverflow.com/questions/49207145/flutter-keyboard-over-textformfield)
      appBar: WyattAppBar(context: context, title: widget.title),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Style.space,
                  Style.space,
                  Style.space,
                  0,
                ),
                child: Text.rich(
                  // don't use RichText here as it's overriding the default font: https://stackoverflow.com/questions/74459505/richtext-overriding-default-font-family
                  // don't use TextButton here either as its textStyle yields a different result on Android 14 and 15
                  TextSpan(children: [
                    TextSpan(
                      text: _isSettingUp
                          ? 'A key is needed. Please obtain one from '
                          : 'If needed, please obtain a key from ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    TextSpan(
                      recognizer: _tapGestureRecognizer
                        ..onTap = () {
                          browseTo(Url.key);
                        },
                      text: 'this page',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.primary,
                          decorationColor:
                              Theme.of(context).colorScheme.primary),
                    ),
                    TextSpan(
                      text: '.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ]),
                ),
              ),
              _isSettingUp
                  ? Padding(
                      padding: const EdgeInsets.all(Style.space),
                      child: Text.rich(
                        // don't use RichText here as it's overriding the default font: https://stackoverflow.com/questions/74459505/richtext-overriding-default-font-family
                        // don't use TextButton here either as its textStyle yields a different result on Android 14 and 15
                        TextSpan(
                          children: [
                            TextSpan(
                              recognizer: _tapGestureRecognizer
                                ..onTap = () {
                                  browseTo(Url.keyWhat);
                                },
                              text: 'What',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      decorationColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                            TextSpan(
                              text: ' is that and ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                            TextSpan(
                              recognizer: _tapGestureRecognizer
                                ..onTap = () {
                                  browseTo(Url.keyWhy);
                                },
                              text: 'why',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      decorationColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                            TextSpan(
                              text:
                                  ' is this needed?\nYou can change the key later in ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                            TextSpan(
                              text: 'Settings',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                            ),
                            TextSpan(
                              text: '.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Style.space,
                  0,
                  Style.space,
                  0,
                ),
                child: TextFormField(
                  obscureText: _isObscured,
                  enableSuggestions: false,
                  autocorrect: false,
                  enabled: !_isProcessing,
                  // causes keyboard to slide up: autofocus: true,
                  controller: _keyController,
                  decoration: InputDecoration(
                      label: const Text("Key *"),
                      hintText: "Enter your key here",
                      suffixIcon: IconButton(
                          icon: Icon(_isObscured
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          })),
                  maxLength: 40,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  validator: (value) {
                    return (value == null || value.trim().isEmpty)
                        ? 'Please enter a key'
                        : null; // success
                  },
                ),
              ),
              _isSettingUp
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Style.space,
                        0,
                        Style.space,
                        0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Defaults:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [distanceField]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [notificationsIntervalField]),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Style.space,
                  Style.space,
                  Style.space,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: _isProcessing
                          ? null
                          : () async {
                              if (await _save()) {
                                if (context.mounted) {
                                  context.go(AppRoutes.reminders);
                                }
                              }
                            },
                      autofocus: true,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
              _isSettingUp
                  ? SizedBox.shrink()
                  : Divider(
                      indent: Style.space,
                      endIndent: Style.space,
                    ),
              _isSettingUp
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Style.space,
                        0,
                        Style.space,
                        0,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.inversePrimary,
                        ),
                        onPressed: _isProcessing ? null : () => _confirmReset(),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('Reset to factory settings'),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _save() async {
    FocusManager.instance.primaryFocus?.unfocus(); // dismiss keyboard

    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    scaffold.clearSnackBars();

    setState(() {
      _isProcessing = true;
    });

    bool result =
        await _saveKey(); // we need to wait for this to finish, otherwise the ref in `ref.read(isKeyValidStateProvider.notifier).state = ...` will be called after the widget is disposed on an invalidated ref, causing an error
    if (result) {
      String savedMsg = 'Key saved.';
      if (!_isSettingUp) {
        _saveDefaultNotificationDistance();
        savedMsg = 'Settings saved.';
      }
      scaffold.showSnackBar(SnackBar(content: Text(savedMsg)));
    }

    setState(() {
      _isProcessing = false;
    });

    return result;
  }

  void _confirmReset() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: Style.seedColor),
            child: AlertDialog(
              title: Text(
                'Confirmation needed',
                style: Style.getDialogTitleStyle(context),
              ),
              content: Text(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  'Are you sure to reset the application?\n\nThis will set all settings back to their defaults and remove all data.\n\nThis action cannot be undone.\n\nAlso, the application will restart (reopen on iOS).'),
              actions: [
                TextButton(
                    onPressed: () {
                      _reset();
                      Restart.restartApp(
                        // customize restart notification message for iOS:
                        notificationTitle: 'Restarting ${Common.appName}',
                        notificationBody:
                            'Please tap here to open the app again.',
                      );
                    },
                    child: const Text('Reset')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'))
              ],
            ),
          );
        });
  }

  void _reset() {
    setState(() {
      _isProcessing = true;
    });

    final settings = ref.read(settingsNotifierProvider.notifier);
    settings.clearAll();

    final reminders = ref.read(remindersNotifierProvider.notifier);
    reminders.clearAll();

    _keyController.clear();
    _distanceController.clear();

    setState(() {
      _isProcessing = false;
    });
  }
}
