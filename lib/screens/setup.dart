import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:wyatt/providers/settings_helper.dart';
import 'package:wyatt/providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, required this.inSetupMode});

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
    _readDefaultNotificationDistance();
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

  Future<void> _saveKey() async {
    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    final ThemeData themeData = Theme.of(context);
    scaffold.clearSnackBars();

    final keyValue = _keyController.text.trim();
    if (keyValue.isEmpty) {
      scaffold.showSnackBar(SnackBar(
        backgroundColor: themeData.colorScheme.onErrorContainer,
        content: Text('Please enter a key'),
      ));
      return;
    }

    final settings = ref.read(settingsNotifierProvider.notifier);
    settings.setKey(keyValue);

    if (await KeyValidator.validateKey(keyValue)) {
      //scaffold.showSnackBar(SnackBar(content: Text('The saved key is valid.')));
    } else {
      scaffold.showSnackBar(SnackBar(
          backgroundColor: themeData.colorScheme.error,
          content: Text('The saved key is invalid, the app won\'t work!')));
    }
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
    // final Settings = ref.watch(settingsNotifierProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false, // avoid bottom overflow
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/appbar-bg.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(Common.screenSettings),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(space, space, space, 0),
            child: Linkify(
              linkStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
              onOpen: (link) async {
                if (!await launchUrl(Uri.parse(link.url))) {
                  throw Exception('Could not launch ${link.url}');
                }
              },
              text: 'Please obtain a key from ${Common.keyUrl}.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          Padding(
            padding: padding,
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
          Divider(
            indent: space,
            endIndent: space,
          ),
          Padding(
            padding: const EdgeInsets.all(space),
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly // no decimal point, no sign
              ],
              enabled: !_isProcessing,
              // causes keyboard to slide up: autofocus: true,
              controller: _distanceController,
              decoration: InputDecoration(
                labelText: 'Default Notification Distance',
                hintText: 'Enter distance in meters',
                //suffixIcon: Icon(Icons.directions),
              ),
              maxLength: 4,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          Divider(
            indent: space,
            endIndent: space,
          ),
          Padding(
            padding: const EdgeInsets.all(space),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                  ),
                  onPressed: _isProcessing ? null : _save,
                  autofocus: true,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
          !_isSettingUp
              ? Divider(
                  indent: space,
                  endIndent: space,
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(space),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              onPressed: _isProcessing ? null : () => _confirmReset(context),
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

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus(); // dismiss keyboard

    setState(() {
      _isProcessing = true;
    });

    _saveKey();
    _saveDefaultNotificationDistance();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Settings saved.')));

    setState(() {
      _isProcessing = false;
    });
  }

  void _confirmReset(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: seedColor),
            child: AlertDialog(
              title: Text(
                'Please Confirm',
              ),
              content: Text(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  'Are you sure to reset the application?\n\nThis will set all settings back to their defaults and remove all data.\n\nThis action cannot be undone.'),
              actions: [
                TextButton(
                    onPressed: () {
                      _reset();
                      Navigator.of(context).pop();
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
