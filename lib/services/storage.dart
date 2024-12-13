import 'dart:developer';

import 'package:get_storage/get_storage.dart';

enum StorageType { reminders, settings }

Future<void> initPersistentLocalStorage() async {
  for (var type in StorageType.values) {
    await GetStorage.init(type.toString());
  }

  log('persistent storage initialized', name: 'WyattApp');
}

class PersistentLocalStorage {
  GetStorage? box;

  PersistentLocalStorage(StorageType type) {
    box = GetStorage(type.toString());
  }

  void writeString({required String key, required String value}) {
    box!.write(key, value);
    // use ReadWriteValue(key, value)?
  }

  String? readString({required String key}) {
    return box!.read(key);
  }

  void writeInt({required String key, required int value}) {
    box!.write(key, value);
  }

  int? readInt({required String key}) {
    return box!.read(key);
  }

  void delete({required String key}) {
    box!.remove(key);
  }

  void deleteAll() {
    box!.erase();
  }

  Iterable<String> readKeys() {
    return box!.getKeys();
  }

  Iterable<dynamic> readValues() {
    return box!.getValues();
  }
}
