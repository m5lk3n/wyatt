# DEV

## Working snippets

startup_provider.dart:

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