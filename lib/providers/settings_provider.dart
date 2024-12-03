import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/settings.dart';
import 'package:wyatt/services/secure_storage.dart';
import 'package:wyatt/services/storage.dart';

const cfgDefaultNotificationDistance = 'cfgDefaultNotificationDistance';
const defaultDefaultNotificationDistance = Default.notificationDistance;

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, Settings>(
        (ref) => SettingsNotifier());

class SettingsNotifier extends StateNotifier<Settings> {
  final _secureStorage = SecurePersistentLocalStorage();
  final _storage = PersistentLocalStorage();

  SettingsNotifier() : super(Settings());

  Future<String> getKey() async {
    final keyValue = await _secureStorage.read(key: Common.keyKey);
    state.key = keyValue?.trim() ?? '';

    return state.key;
  }

  Future<void> setKey(String keyValue) async {
    await _secureStorage.write(
      key: Common.keyKey,
      value: keyValue.trim(),
    );
  }

  Future<int> getDefaultNotificationDistance() async {
    state.defaultNotificationDistance =
        await _storage.readInt(key: 'cfgDefaultNotificationDistance') ??
            defaultDefaultNotificationDistance;

    return state.defaultNotificationDistance;
  }

  Future<void> setDefaultNotificationDistance(int distance) async {
    await _storage.writeInt(
        key: 'cfgDefaultNotificationDistance', value: distance);
    state.defaultNotificationDistance = distance;
  }

  Future<void> clearSettings() async {
    await _secureStorage.deleteAll();
    await _storage.deleteAll();
    state.key = '';
    state.defaultNotificationDistance = defaultDefaultNotificationDistance;
  }
}
