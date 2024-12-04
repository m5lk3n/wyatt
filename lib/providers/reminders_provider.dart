import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/models/reminder.dart';

final remindersNotifierProvider =
    StateNotifierProvider<RemindersNotifier, List<Reminder>>(
        (ref) => RemindersNotifier([]));

class RemindersNotifier extends StateNotifier<List<Reminder>> {
  RemindersNotifier(super.state);
}
