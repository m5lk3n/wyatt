import 'dart:developer';
import 'package:wyatt/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

const _padding = EdgeInsets.all(16);

class WyattSetupScreen extends StatefulWidget {
  const WyattSetupScreen({super.key, required this.title});
  final String title;

  @override
  State<WyattSetupScreen> createState() => _WyattSetupScreenState();
}

class _WyattSetupScreenState extends State<WyattSetupScreen> {
  final _keyController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  _saveKey() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final key = _keyController.text.trim();

    if (key.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a key')));
      return;
    }

    log('Key: $key');

    // TODO: disable floatingActionButton and lose focus
    // TODO: Save key using flutter_secure_storage
  }

  Widget _createAboutDialog() {
    return AboutDialog(
      applicationName: 'Wyatt',
      applicationVersion: '0.0.1',
      applicationIcon: CircleAvatar(
        child: Image.asset("assets/images/logo.png"),
      ),
      applicationLegalese: '${DateTime.now().year} by lttl.dev',
      children: [
        Text(
          '\nWhen You Are There, Then...',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
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
                    child: _createAboutDialog(),
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
              padding: _padding,
              child: Linkify(
                onOpen: (link) async {
                  if (!await launchUrl(Uri.parse(link.url))) {
                    throw Exception('Could not launch ${link.url}');
                  }
                },
                text:
                    'Howdy!\n\nPlease obtain a key from ${Constants.keyUrl}, enter it below and save.',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: _padding,
              child: TextField(
                controller: _keyController,
                decoration: const InputDecoration(label: Text("Key")),
                maxLength: 40,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveKey,
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}
