import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/services/storage.dart';

final remindersNotifierProvider =
    StateNotifierProvider<RemindersNotifier, List<Reminder>>(
        (ref) => RemindersNotifier([]));

class RemindersNotifier extends StateNotifier<List<Reminder>> {
  final _storage = PersistentLocalStorage();

  RemindersNotifier(super.state) {
    _storage.readRemindersKeys().then((ids) {
      List<Reminder> reminders = [];

      for (var id in ids) {
        _storage.readString(key: id).then((value) {
          if (value != null) {
            Reminder reminder = Reminder.fromJson(jsonDecode(value));
            reminders = [
              ...reminders,
              reminder
            ]; // updating state here would maybe fire notifications, don't know
          }
        });

        state = reminders;
      }
    });
  }

  void add(Reminder reminder) {
    state = [...state, reminder];
    _storeReminder(reminder);
  }

  void addAll(List<Reminder> reminders) {
    state = [...state, ...reminders];
    for (var reminder in reminders) {
      _storeReminder(reminder);
    }
  }

  void insertAt(int index, Reminder reminder) {
    state = [...state]..insert(index, reminder);
    _storeReminder(reminder);
  }

  void remove(Reminder reminder) {
    state = state.where((r) => r != reminder).toList();
    _deleteReminder(reminder.id!);
  }

  void update(Reminder reminder) {
    // probably inefficient for larger list, but fine for now
    state = [
      ...state.map(
        (r) => r.id == reminder.id ? reminder : r,
      ),
    ];
    _storeReminder(reminder);
    log('updated reminder: $reminder', name: '$runtimeType');
  }

  void clearAll() {
    state = [];
    _storage.readRemindersKeys().then((ids) {
      for (var id in ids) {
        _deleteReminder(id);
      }
    });
  }

  // overrides an existing reminder with the same id
  void _storeReminder(Reminder reminder) {
    _storage.writeString(key: reminder.id!, value: jsonEncode(reminder));
  }

  void _deleteReminder(String reminderId) {
    _storage.delete(key: reminderId);
  }
}
