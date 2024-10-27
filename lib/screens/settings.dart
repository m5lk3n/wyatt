import 'dart:convert';
import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';
import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wyatt/models/network.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

// https://github.com/mogol/flutter_secure_storage/tree/develop/flutter_secure_storage#note-usage-of-encryptedsharedpreference
AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _keyController = TextEditingController();
  final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  bool _isProcessing = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _readKeyFromStorage();
  }

  @override
  void dispose() {
    _keyController.dispose();

    super.dispose();
  }

  String? _getKeyFormValue() =>
      _keyController.text.isEmpty ? null : _keyController.text;

  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: _getKeyFormValue(),
        accessibility: KeychainAccessibility
            .first_unlock, // running in the background? https://github.com/mogol/flutter_secure_storage/tree/develop/flutter_secure_storage#getting-started
      );

  Future<void> _readKeyFromStorage() async {
    final key = await _storage.read(
      key: Common.keyKey,
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );
    _keyController.text = key?.trim() ?? '';
  }

  _saveKeyToStorage() async {
    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    scaffold.clearSnackBars();

    final keyValue = _keyController.text.trim();
    if (keyValue.isEmpty) {
      scaffold.showSnackBar(SnackBar(content: Text('Please enter a key')));
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await _storage.write(
      key: Common.keyKey,
      value: keyValue,
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );

    if (await _validateKey(keyValue)) {
      scaffold.showSnackBar(SnackBar(content: Text('The key is valid.')));
    } else {
      scaffold.showSnackBar(SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Text('The key is invalid, the app won\'t work.')));
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
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
                  onPressed: _isProcessing ? null : _saveKeyToStorage,
                  autofocus: true,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.brown,
            indent: space,
            endIndent: space,
          ),
          Padding(
            padding: const EdgeInsets.all(space),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: _isProcessing ? null : () => _resetSettings(context),
              child: Align(
                alignment: Alignment.center,
                child: Text('Reset app to factory settings'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _validateKey(String key) async {
    final response = await http.get(Uri.parse(
        // https://developers.google.com/maps/documentation/geocoding/start
        'https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=$key'));
    if (response.statusCode == 200) {
      try {
        GeocodeAddress geocodeAddress = GeocodeAddress.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        if (geocodeAddress.status == 'OK') {
          log('Key validation successful');

          return true;
        }
      } catch (e) {
        log('Key validation failed with: $e');
      }
    }

    return false;
  }

  void _resetSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(
              'Please Confirm',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
            ),
            content: Text(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                'Are you sure to reset the application?\n\nThis will set all settings back to their defaults and remove all data.\n\nThis action cannot be undone.'),
            actions: [
              TextButton(
                  onPressed: () {
                    _removeKeyFromStorage();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  void _removeKeyFromStorage() {
    setState(() {
      _isProcessing = true;
    });

    _storage.delete(
      key: Common.keyKey,
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );

    _keyController.clear();

    setState(() {
      _isProcessing = false;
    });
  }
}
