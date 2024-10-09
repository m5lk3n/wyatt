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
              // TODO: Show about dialog
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
