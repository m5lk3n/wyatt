# DEV

## Working snippets

`startup_provider.dart:`

```
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/providers/settings_helper.dart';
import 'package:wyatt/services/secure_storage.dart';

final startupNotifierProvider =
    AutoDisposeNotifierProvider<StartupNotifier, bool>(() => StartupNotifier());

class StartupNotifier extends AutoDisposeNotifier<bool> {
  final _secureStorage = SecurePersistentLocalStorage();

  @override
  bool build() {
    _loadStartupStatus();
    return false;
  }

  Future<void> _loadStartupStatus() async {
    state = false;

    final keyValue = await _secureStorage.read(key: Common.keyKey);
    log('StartupNotifier: key = $keyValue');

    KeyValidator.validateKey(keyValue).then((isValid) {
      if (isValid) {
        state = true;
      }
    });

    log('StartupNotifier: state = $state');
  }
}
```

During start-up/splash, add this check ([source](https://medium.com/@piyushhh01/comprehensive-guide-to-error-handling-in-flutter-strategies-and-code-examples-2929071e5716)):

```
class MyHomePage extends StatelessWidget {
  Future<void> checkInternetConnection(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Display a "No Internet Connection" message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Perform the network request
      // ...
    }
  }
```