import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/log.dart';
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
    return Startup();
  }

  Future<void> _loadStartupStatus() async {
    await Future.delayed(const Duration(
        microseconds: Common
            .magicalWaitTimeInMs)); // simulate loading, give splash screen time to show

    Startup startup = Startup(); // TODO: should this be a member?
    state = startup;

    final key = await _secureStorage.read(key: SecureSettingsKeys.key);
    log.debug('key = $key', name: '$runtimeType');
    if (key == null || key.isEmpty) {
      state = startup.copyWith(
        isLoading: false,
        hasNoKey: true,
      );
      return;
    }

    KeyValidator.validateKey(key).then((isValid) {
      state = startup.copyWith(
        isLoading: false,
        hasInvalidKey: !isValid,
      );
    });

    log.debug('state = $state', name: '$runtimeType');
  }
}
