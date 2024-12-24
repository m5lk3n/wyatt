import 'dart:convert';
import 'dart:core';

import 'package:wyatt/log.dart';
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

    log.debug('retrieved ${reminders.length} reminders from persistent storage',
        name: '$runtimeType');

    return reminders;
  }

  void add(Reminder reminder) {
    _storeReminder(reminder);
    log.debug('added reminder: $reminder', name: '$runtimeType');
  }

  void addAll(List<Reminder> reminders) {
    for (var reminder in reminders) {
      _storeReminder(reminder);
    }
    log.debug('added all ${reminders.length} reminders', name: '$runtimeType');
  }

  void insertAt(int index, Reminder reminder) {
    _storeReminder(reminder);
    log.debug('inserted reminder: $reminder', name: '$runtimeType');
  }

  void remove(Reminder reminder) {
    _deleteReminder(reminder.id!);
    log.debug('deleted reminder: $reminder', name: '$runtimeType');
  }

  void update(Reminder reminder) {
    _storeReminder(reminder);
    log.debug('updated reminder: $reminder', name: '$runtimeType');
  }

  void clearAll() {
    _storage.deleteAll();
    log.debug('updated all reminders', name: '$runtimeType');
  }

  // overrides an existing reminder with the same id
  void _storeReminder(Reminder reminder) {
    _storage.writeString(key: reminder.id!, value: jsonEncode(reminder));
  }

  void _deleteReminder(String reminderId) {
    _storage.delete(key: reminderId);
  }
}
