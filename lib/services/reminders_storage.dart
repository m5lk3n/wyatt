import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/services/storage.dart';

class RemindersStorage {
  final _storage = PersistentLocalStorage(StorageType.reminders);

  List<Reminder> getReminders() {
    List<Reminder> reminders = [];

    for (var value in _storage.readValues()) {
      if (value != null) {
        Reminder reminder = Reminder.fromJson(jsonDecode(value));
        reminders.add(reminder);
      }
    }

    log('retrieved ${reminders.length} reminders from persistent storage',
        name: '$runtimeType');

    return reminders;
  }

  void add(Reminder reminder) {
    _storeReminder(reminder);
    log('added reminder: $reminder', name: '$runtimeType');
  }

  void addAll(List<Reminder> reminders) {
    for (var reminder in reminders) {
      _storeReminder(reminder);
    }
    log('added all ${reminders.length} reminders', name: '$runtimeType');
  }

  void insertAt(int index, Reminder reminder) {
    _storeReminder(reminder);
    log('inserted reminder: $reminder', name: '$runtimeType');
  }

  void remove(Reminder reminder) {
    _deleteReminder(reminder.id!);
    log('deleted reminder: $reminder', name: '$runtimeType');
  }

  void update(Reminder reminder) {
    _storeReminder(reminder);
    log('updated reminder: $reminder', name: '$runtimeType');
  }

  void clearAll() {
    _storage.deleteAll();
    log('updated all reminders', name: '$runtimeType');
  }

  // overrides an existing reminder with the same id
  void _storeReminder(Reminder reminder) {
    _storage.writeString(key: reminder.id!, value: jsonEncode(reminder));
  }

  void _deleteReminder(String reminderId) {
    _storage.delete(key: reminderId);
  }
}
