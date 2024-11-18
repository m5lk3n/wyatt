import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/data/seed.dart';
import 'package:wyatt/widgets/common.dart';
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
      content = GridView.builder(
        itemCount: seedReminders.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns horizontally
          childAspectRatio: 3 / 2,
          crossAxisSpacing: Common.space, // 20 pixels between columns
          mainAxisSpacing: Common.space, // 20 pixels between rows
        ),
        itemBuilder: (context, index) {
          return ReminderGridItem(reminder: seedReminders[index]);
        },
      );
    }

    return Scaffold(
      appBar: createWyattAppBar(context, Screen.reminders),
      body: content,
      drawer: WyattDrawer(),
    );
  }
}
