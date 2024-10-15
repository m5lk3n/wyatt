import 'dart:convert';
import 'dart:developer';

import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wyatt/models/network.dart';
import 'package:wyatt/widgets/common.dart';

// https://github.com/mogol/flutter_secure_storage/tree/develop/flutter_secure_storage#note-usage-of-encryptedsharedpreference
AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key, required this.title});
  final String title;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _keyController = TextEditingController();
  final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    _readKey();
  }

  @override
  void dispose() {
    _keyController.dispose();

    super.dispose();
  }

  String? _getKey() => _keyController.text.isEmpty ? null : _keyController.text;

  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: _getKey(),
        accessibility: KeychainAccessibility
            .first_unlock, // running in the background? https://github.com/mogol/flutter_secure_storage/tree/develop/flutter_secure_storage#getting-started
      );

  Future<void> _readKey() async {
    final key = await _storage.read(
      key: Common.keyKey,
      iOptions: _getIOSOptions(),
    );
    _keyController.text = key?.trim() ?? '';
  }

  _saveKey() async {
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
    );

    if (await validateKey(keyValue)) {
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
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
        /*
        leading: IconButton(
          onPressed: () {
            // TODO: Navigate to home screen
          },
          icon: Icon(Icons.home),
        ),
        */
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Theme(
                    data: Theme.of(context)
                        .copyWith(dialogBackgroundColor: Colors.brown),
                    child: createAboutDialog(context),
                  );
                },
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: padding,
              child: Linkify(
                onOpen: (link) async {
                  if (!await launchUrl(Uri.parse(link.url))) {
                    throw Exception('Could not launch ${link.url}');
                  }
                },
                text:
                    'Howdy!\n\nPlease obtain a key from ${Common.keyUrl} and enter it below, then save.',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: padding,
              child: TextField(
                controller: _keyController,
                decoration: const InputDecoration(label: Text("Key")),
                maxLength: 40,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isProcessing ? null : _saveKey,
        tooltip: _isProcessing ? 'Saving...' : 'Save',
        backgroundColor: // https://api.flutter.dev/flutter/material/FloatingActionButton-class.html
            _isProcessing
                ? Theme.of(context).colorScheme.secondary
                : null /* default */,
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<bool> validateKey(String key) async {
    final response = await http.get(Uri.parse(
        // https://developers.google.com/maps/documentation/geocoding/start
        'https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=$key'));
    if (response.statusCode == 200) {
      try {
        GeocodeAddress.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        log('Key validation successful');

        return true;
      } catch (e) {
        log('Key validation failed with: $e');
      }
    }

    return false;
  }
}
