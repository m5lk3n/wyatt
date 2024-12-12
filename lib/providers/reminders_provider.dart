import 'dart:core';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/services/reminders_storage.dart';

final remindersNotifierProvider =
    StateNotifierProvider<RemindersNotifier, List<Reminder>>(
        (ref) => RemindersNotifier([]));

class RemindersNotifier extends StateNotifier<List<Reminder>> {
  final _storage = RemindersStorage();

  RemindersNotifier(super.state) {
    log('had ${state.length} reminders', name: '$runtimeType');
    state = _storage.getReminders();
    log('now ${state.length} reminders', name: '$runtimeType');
  }

  void add(Reminder reminder) {
    state = [...state, reminder];
    _storage.add(reminder);
  }

  void addAll(List<Reminder> reminders) {
    log('adding ${reminders.length} reminders to ${state.length} from the state',
        name: '$runtimeType');
    state = [...state, ...reminders];
    _storage.addAll(reminders);
  }

  void insertAt(int index, Reminder reminder) {
    state = [...state]..insert(index, reminder);
    _storage.add(reminder);
  }

  void remove(Reminder reminder) {
    state = state.where((r) => r != reminder).toList();
    _storage.remove(reminder);
    log('removed reminder: $reminder, ${state.length} is left',
        name: '$runtimeType');
  }

  void update(Reminder reminder) {
    // probably inefficient for larger list, but fine for now
    state = [
      ...state.map(
        (r) => r.id == reminder.id ? reminder : r,
      ),
    ];
    _storage.update(reminder);
  }

  void clearAll() {
    state = [];
    _storage.clearAll();
  }
}
