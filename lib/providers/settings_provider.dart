import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/settings.dart';

const cfgDefaultNotificationDistance = 'cfgDefaultNotificationDistance';
const defaultDefaultNotificationDistance = 500;

// https://github.com/mogol/flutter_secure_storage/tree/develop/flutter_secure_storage#note-usage-of-encryptedsharedpreference
AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class SettingsNotifier extends StateNotifier<Settings> {
  final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  SettingsNotifier() : super(Settings());

  IOSOptions _getIOSOptions() => IOSOptions(
        accessibility: KeychainAccessibility
            .first_unlock, // running in the background? https://github.com/mogol/flutter_secure_storage/tree/develop/flutter_secure_storage#getting-started
      );

  Future<String> getKey() async {
    final key = await _storage.read(
      key: Common.keyKey,
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );

    return key?.trim() ?? '';
  }

  Future<void> setKey(String keyValue) async {
    await _storage.write(
      key: Common.keyKey,
      value: keyValue,
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );
  }

  // shared_preferences below

  Future<int> getDefaultNotificationDistance() async {
    final prefs =
        await SharedPreferences.getInstance(); // TODO: make prefs a member
    state.defaultNotificationDistance =
        prefs.getInt('cfgDefaultNotificationDistance') ??
            defaultDefaultNotificationDistance;

    return state.defaultNotificationDistance;
  }

  Future<void> setDefaultNotificationDistance(int distance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cfgDefaultNotificationDistance', distance);
    state.defaultNotificationDistance = distance;
  }

  Future<bool> clearSettings() async {
    await _storage.deleteAll(
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );

    final prefs = await SharedPreferences.getInstance();

    return prefs.clear();
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, Settings>(
        (ref) => SettingsNotifier());
