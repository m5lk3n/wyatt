import 'package:wyatt/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _padding = EdgeInsets.all(16);
// https://github.com/mogol/flutter_secure_storage/tree/develop/flutter_secure_storage#note-usage-of-encryptedsharedpreference
AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class WyattSetupScreen extends StatefulWidget {
  const WyattSetupScreen({super.key, required this.title});
  final String title;

  @override
  State<WyattSetupScreen> createState() => _WyattSetupScreenState();
}

class _WyattSetupScreenState extends State<WyattSetupScreen> {
  final _keyController = TextEditingController();
  final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  bool _isSaving = false;

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
    scaffold.hideCurrentSnackBar();

    final keyValue = _keyController.text.trim();
    if (keyValue.isEmpty) {
      scaffold.showSnackBar(SnackBar(content: Text('Please enter a key')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await _storage.write(
      key: Common.keyKey,
      value: keyValue,
      iOptions: _getIOSOptions(),
    );
    scaffold.showSnackBar(SnackBar(content: Text('Key saved')));

    setState(() {
      _isSaving = false;
    });
  }

  Widget _createAboutDialog() {
    return AboutDialog(
      applicationName: Common.appName,
      applicationVersion: Common.appVersion,
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
        onPressed: _isSaving ? null : _saveKey,
        tooltip: _isSaving ? 'Saving...' : 'Save',
        backgroundColor: // https://api.flutter.dev/flutter/material/FloatingActionButton-class.html
            _isSaving
                ? Theme.of(context).colorScheme.secondary
                : null /* default */,
        child: const Icon(Icons.save),
      ),
    );
  }
}
