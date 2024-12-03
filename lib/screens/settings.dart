import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wyatt/app_routes.dart';
import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';
import 'package:wyatt/providers/key_provider.dart';
import 'package:wyatt/providers/settings_helper.dart';
import 'package:wyatt/providers/settings_provider.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/common.dart';
import 'package:wyatt/widgets/link_button.dart';
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

  @override
  void initState() {
    super.initState();

    _isSettingUp = widget.inSetupMode;

    _readKey();
    if (!_isSettingUp) {
      _readDefaultNotificationDistance();
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _distanceController.dispose();

    super.dispose();
  }

  Future<void> _readKey() async {
    final settings = ref.read(settingsNotifierProvider.notifier);

    String key = await settings.getKey();

    _keyController.text = key;
  }

  Future<bool> _saveKey() async {
    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    final ThemeData themeData = Theme.of(context);
    scaffold.clearSnackBars();

    final keyValue = _keyController.text.trim();
    if (keyValue.isEmpty) {
      scaffold.showSnackBar(SnackBar(
        backgroundColor: themeData.colorScheme.onErrorContainer,
        content: Text('Please enter a key'),
      ));
      return false;
    }

    final settings = ref.read(settingsNotifierProvider.notifier);
    settings.setKey(keyValue);

    if (await KeyValidator.validateKey(keyValue)) {
      scaffold.showSnackBar(SnackBar(content: Text('The saved key is valid.')));
      ref.read(isKeyValidStateProvider.notifier).state = true;
      return true;
    } else {
      ref.read(isKeyValidStateProvider.notifier).state = false;
      scaffold.showSnackBar(SnackBar(
          backgroundColor: themeData.colorScheme.error,
          content: Text('The saved key is invalid, the app won\'t work!')));
    }

    return false;
  }

  Future<void> _readDefaultNotificationDistance() async {
    final settings = ref.read(settingsNotifierProvider.notifier);

    int distance = await settings.getDefaultNotificationDistance();

    _distanceController.text = distance.toString();
  }

  Future<void> _saveDefaultNotificationDistance() async {
    if (_distanceController.text.trim().isEmpty) {
      return;
    }

    final settings = ref.read(settingsNotifierProvider.notifier);
    settings
        .setDefaultNotificationDistance(int.parse(_distanceController.text));

    setState(() {
      _readDefaultNotificationDistance(); // show parsed value, e.g. 0500 -> 500
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget distanceField = createDistanceField(
      context,
      'Default Notification Distance',
      _distanceController,
      _isProcessing,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false, // avoid bottom overflow
      appBar: WyattAppBar(context, widget.title),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              Common.space,
              Common.space,
              0,
            ),
            child: Text.rich(
              // don't use RichText here as it's overriding the default font: https://stackoverflow.com/questions/74459505/richtext-overriding-default-font-family
              TextSpan(children: [
                TextSpan(
                  text: _isSettingUp
                      ? 'A key is needed. Please obtain one from '
                      : 'If needed, please obtain a key from ',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: LinkButton(
                    urlLabel: 'this page',
                    url: Common.keyUrl,
                  ),
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
                  padding: const EdgeInsets.fromLTRB(
                    Common.space,
                    Common.space,
                    Common.space,
                    0,
                  ),
                  child: Text.rich(
                    // don't use RichText here as it's overriding the default font: https://stackoverflow.com/questions/74459505/richtext-overriding-default-font-family
                    TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: LinkButton(
                            urlLabel: 'What',
                            url: Common.keyWhatUrl,
                          ),
                        ),
                        TextSpan(
                          text: ' is this and ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: LinkButton(
                            urlLabel: 'why',
                            url: Common.keyWhyUrl,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' is this needed?\nYou can change the key later in ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        TextSpan(
                          text: 'Settings',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink(),
          Padding(
            padding: Common.padding,
            child: TextField(
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
            ),
          ),
          _isSettingUp
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Common.space,
                    0,
                    Common.space,
                    0,
                  ),
                  child: distanceField),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              Common.space,
              Common.space,
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                  ),
                  onPressed: _isProcessing ? null : () => _save(context),
                  autofocus: true,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
          _isSettingUp
              ? SizedBox.shrink()
              : Divider(
                  indent: Common.space,
                  endIndent: Common.space,
                ),
          _isSettingUp
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Common.space,
                    0,
                    Common.space,
                    0,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                    ),
                    onPressed:
                        _isProcessing ? null : () => _confirmReset(context),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Reset to factory settings'),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future<bool> _saveSettings(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus(); // dismiss keyboard

    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    setState(() {
      _isProcessing = true;
    });

    bool result =
        await _saveKey(); // we need to wait for this to finish, otherwise the ref in `ref.read(isKeyValidStateProvider.notifier).state = ...` will be called after the widget is disposed on an invalidated ref, causing an error
    String savedMsg = 'Key saved.';
    if (!_isSettingUp) {
      _saveDefaultNotificationDistance();
      savedMsg = 'Settings saved.';
    }

    scaffold.showSnackBar(SnackBar(content: Text(savedMsg)));

    setState(() {
      _isProcessing = false;
    });

    return result;
  }

  void _save(BuildContext context) async {
    if (await _saveSettings(context)) {
      // ignore: use_build_context_synchronously
      context.go(AppRoutes.reminders);
    }
  }

  void _confirmReset(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: Common.seedColor),
            child: AlertDialog(
              title: Text(
                'Please Confirm',
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
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'))
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
    settings.clearSettings();

    _keyController.clear();
    _distanceController.clear();

    setState(() {
      _isProcessing = false;
    });
  }
}
