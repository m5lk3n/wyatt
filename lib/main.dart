import 'package:flutter/material.dart';

void main() {
  runApp(const WyattApp());
}

class WyattApp extends StatelessWidget {
  const WyattApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wyatt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WyattSetupPage(title: 'Wyatt Setup'),
    );
  }
}

class WyattSetupPage extends StatefulWidget {
  const WyattSetupPage({super.key, required this.title});
  final String title;

  @override
  State<WyattSetupPage> createState() => _WyattSetupPageState();
}

class _WyattSetupPageState extends State<WyattSetupPage> {
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter your key:',
            ),
            Text(
              _key,
              style: Theme.of(context).textTheme.headlineMedium,
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
