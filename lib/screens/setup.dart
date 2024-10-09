import 'package:flutter/material.dart';

class WyattSetupScreen extends StatefulWidget {
  const WyattSetupScreen({super.key, required this.title});
  final String title;

  @override
  State<WyattSetupScreen> createState() => _WyattSetupScreenState();
}

class _WyattSetupScreenState extends State<WyattSetupScreen> {
  String _key = "";

  void _setKey() {
    setState(() {
      _key = "TODO";
    });
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            Text(
              'Enter your key:',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _key,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setKey,
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}
