import 'package:shared_preferences/shared_preferences.dart';
import 'package:wyatt/common.dart';

class PersistentLocalStorage {
  Future<void> writeString({required String key, required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String?> readString({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> writeInt({required String key, required int value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<int?> readInt({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }

  Future<void> delete({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<Iterable<String>> readSettingsKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().where((key) => key.startsWith(SettingsKeys.prefix));
  }

  Future<Iterable<String>> readRemindersKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().where((key) => !key.startsWith(SettingsKeys.prefix));
  }
}
