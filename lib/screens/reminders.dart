import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/data/seed.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/drawer.dart';
import 'package:wyatt/widgets/reminder.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nothing to do',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: Common.space / 2),
          Text(
            'Add some reminders to get started',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );

    if (seedReminders.isNotEmpty) {
      content = ListView.builder(
        itemCount: seedReminders.length,
        itemBuilder: (context, index) {
          return ReminderListItem(reminder: seedReminders[index]);
        },
      );
    }

    return Scaffold(
      appBar: WyattAppBar(context, Screen.reminders),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          0,
          Common.space / 2,
          0,
          0,
        ),
        child: content,
      ),
      drawer: WyattDrawer(),
    );
  }
}
