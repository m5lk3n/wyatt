import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// https://github.com/mogol/flutter_secure_storage/tree/develop/flutter_secure_storage#note-usage-of-encryptedsharedpreference
AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class SecurePersistentLocalStorage {
  final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  IOSOptions _getIOSOptions() => IOSOptions(
        accessibility: KeychainAccessibility
            .first_unlock, // running in the background? https://github.com/mogol/flutter_secure_storage/tree/develop/flutter_secure_storage#getting-started
      );

  Future<void> write({required String key, required String value}) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );
  }

  Future<String?> read({required String key}) async {
    return await _storage.read(
      key: key,
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(
      key: key,
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll(
      iOptions: _getIOSOptions(),
      // see above for aOptions
    );
  }
}
