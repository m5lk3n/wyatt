import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/settings.dart';
import 'package:wyatt/services/secure_storage.dart';
import 'package:wyatt/services/storage.dart';

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, Settings>(
        (ref) => SettingsNotifier());

class SettingsNotifier extends StateNotifier<Settings> {
  final _secureStorage = SecurePersistentLocalStorage();
  final _storage = PersistentLocalStorage(StorageType.settings);

  SettingsNotifier() : super(Settings());

  // --- secure storage ---

  Future<String> getKey() async {
    final keyValue = await _secureStorage.read(key: SecureSettingsKeys.key);
    state.key = keyValue?.trim() ?? '';

    return state.key;
  }

  Future<void> setKey(String keyValue) async {
    await _secureStorage.write(
      key: SecureSettingsKeys.key,
      value: keyValue.trim(),
    );
  }

  // --- storage ---

  Future<int> getDefaultNotificationDistance() async {
    state.defaultNotificationDistance =
        _storage.readInt(key: SettingsKeys.distance) ??
            Default.notificationDistance;

    return state.defaultNotificationDistance;
  }

  void setDefaultNotificationDistance(int distance) {
    _storage.writeInt(key: SettingsKeys.distance, value: distance);
    state.defaultNotificationDistance = distance;
  }

  // --- storage & secure storage ---

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    _storage.deleteAll();
    state.key = '';
    state.defaultNotificationDistance = Default.notificationDistance;
  }
}
