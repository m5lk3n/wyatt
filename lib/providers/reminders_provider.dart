import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/models/reminder.dart';

final remindersNotifierProvider =
    StateNotifierProvider<RemindersNotifier, List<Reminder>>(
        (ref) => RemindersNotifier([]));

class RemindersNotifier extends StateNotifier<List<Reminder>> {
  RemindersNotifier(super.state);

  void add(Reminder reminder) {
    state = [...state, reminder];
  }

  void addAll(List<Reminder> reminders) {
    state = [...state, ...reminders];
  }

  void insertAt(int index, Reminder reminder) {
    state = [...state]..insert(index, reminder);
  }

  void remove(Reminder reminder) {
    state = state.where((r) => r != reminder).toList();
  }

  void update(Reminder reminder) {
    // probably inefficient for larger list, but fine for now
    state = [
      ...state.map(
        (r) => r.id == reminder.id ? reminder : r,
      ),
    ];
  }

  void clearAll() {
    state = [];
  }
}
