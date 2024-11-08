import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future<void> writeInt({required String key, required int value}) async {
    final prefs =
        await SharedPreferences.getInstance(); // TODO: make prefs a member
    prefs.setInt(key, value);
  }

  Future<int?> readInt({required String key}) async {
    final prefs =
        await SharedPreferences.getInstance(); // TODO: make prefs a member

    return prefs.getInt(key);
  }

  Future<void> delete({required String key}) async {
    final prefs =
        await SharedPreferences.getInstance(); // TODO: make prefs a member

    prefs.remove(key);
  }

  Future<void> deleteAll() async {
    final prefs =
        await SharedPreferences.getInstance(); // TODO: make prefs a member

    prefs.clear();
  }
}
