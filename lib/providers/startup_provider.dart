import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/startup.dart';
import 'package:wyatt/providers/settings_helper.dart';
import 'package:wyatt/services/secure_storage.dart';

final startupNotifierProvider =
    AutoDisposeNotifierProvider<StartupNotifier, Startup>(
        () => StartupNotifier());

class StartupNotifier extends AutoDisposeNotifier<Startup> {
  final _secureStorage = SecurePersistentLocalStorage();

  @override
  Startup build() {
    _loadStartupStatus();
    return Startup(); // TODO: should this be a member?
  }

  Future<void> _loadStartupStatus() async {
    await Future.delayed(const Duration(
        seconds: Common
            .magicalWaitTimeInSeconds)); // simulate loading, give splash screen time to show

    Startup startup = Startup(); // TODO: should this be a member?
    state = startup;

    final keyValue = await _secureStorage.read(key: Common.keyKey);
    log('StartupNotifier: key = $keyValue');

    if (keyValue == null || keyValue.isEmpty) {
      state = startup.copyWith(isLoading: false, hasNoKey: true);
      return;
    }

    KeyValidator.validateKey(keyValue).then((isValid) {
      state = startup.copyWith(isLoading: false, hasInvalidKey: !isValid);
    });

    log('StartupNotifier: state = $state');
  }
}
