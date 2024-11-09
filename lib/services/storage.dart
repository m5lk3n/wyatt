import 'package:shared_preferences/shared_preferences.dart';

class PersistentLocalStorage {
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
}
