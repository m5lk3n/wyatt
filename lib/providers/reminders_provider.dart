import 'dart:core';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/services/reminders_storage.dart';

final remindersNotifierProvider =
    StateNotifierProvider<RemindersNotifier, List<Reminder>>(
        (ref) => RemindersNotifier([]));

class RemindersNotifier extends StateNotifier<List<Reminder>> {
  final _persistentStorage = RemindersStorage();

  RemindersNotifier(super.state) {
    log('had ${state.length} reminders', name: '$runtimeType');
    state = _persistentStorage.getReminders();
    log('now ${state.length} reminders', name: '$runtimeType');
  }

  void add(Reminder reminder) {
    state = [...state, reminder];
    _persistentStorage.add(reminder);
  }

  void addAll(List<Reminder> reminders) {
    log('adding ${reminders.length} reminders to ${state.length} from the state',
        name: '$runtimeType');
    state = [...state, ...reminders];
    _persistentStorage.addAll(reminders);
  }

  void insertAt(int index, Reminder reminder) {
    state = [...state]..insert(index, reminder);
    _persistentStorage.add(reminder);
  }

  void remove(Reminder reminder) {
    state = state.where((r) => r != reminder).toList();
    _persistentStorage.remove(reminder);
    log('removed reminder: $reminder, ${state.length} is/are left',
        name: '$runtimeType');
  }

  void update(Reminder reminder) {
    // probably inefficient for larger list, but fine for now
    state = [
      ...state.map(
        (r) => r.id == reminder.id ? reminder : r,
      ),
    ];
    _persistentStorage.update(reminder);
  }

  void clearAll() {
    state = [];
    _persistentStorage.clearAll();
  }
}
