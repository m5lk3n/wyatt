import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wyatt/models/settings.dart';

const cfgDefaultNotificationDistance = 'cfgDefaultNotificationDistance';
const defaultDefaultNotificationDistance = 500;

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings());

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
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, Settings>(
        (ref) => SettingsNotifier());
