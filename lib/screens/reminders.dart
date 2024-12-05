import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/data/seed.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/providers/reminders_provider.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/drawer.dart';
import 'package:wyatt/widgets/reminder.dart';

// ignore: must_be_immutable
class RemindersScreen extends ConsumerWidget {
  // required for undo:
  Reminder? _deletedItem;
  int? _deletedIndex;

  RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content;
    Widget? floatingActionButton;

    final reminders = ref.watch(remindersNotifierProvider);

    if (reminders.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ain't nothin' here yet",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: Common.space / 2),
            Text(
              'Hit + above to get started',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: Common.space / 2),
            Text(
              '(or tap the light bulb below for inspiration)',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      );

      floatingActionButton = FloatingActionButton(
        tooltip: 'Inspire me',
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Theme(
                data: Theme.of(context)
                    .copyWith(dialogBackgroundColor: Common.seedColor),
                child: AlertDialog(
                  title: Text(
                    'Inspire me',
                  ),
                  content: Text(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      'Are you ok with a sample reminder list?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        log('Seeding ${seedReminders.length} reminders');
                        ref
                            .read(remindersNotifierProvider.notifier)
                            .addAll(seedReminders);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Seed'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.lightbulb),
      );
    } else {
      content = ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              color: Common.seedColor,
              padding: EdgeInsets.symmetric(horizontal: Common.space),
              alignment: AlignmentDirectional.centerStart,
              child: Icon(
                Icons.delete,
              ),
            ),
            secondaryBackground: Container(
              color: Common.seedColor,
              padding: EdgeInsets.symmetric(horizontal: Common.space),
              alignment: AlignmentDirectional.centerEnd,
              child: Icon(
                Icons.delete,
              ),
            ),
            key: ValueKey<Reminder>(reminders[index]),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Theme(
                    data: Theme.of(context)
                        .copyWith(dialogBackgroundColor: Common.seedColor),
                    child: AlertDialog(
                      title: Text(
                        'Please Confirm',
                      ),
                      content: Text(
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          'Are you sure to delete this reminder?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete')),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            onDismissed: (DismissDirection direction) {
              ScaffoldMessenger.of(context).clearSnackBars();
              _deletedItem = reminders.removeAt(index);
              _deletedIndex = index;
              ref
                  .read(remindersNotifierProvider.notifier)
                  .remove(_deletedItem!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Reminder deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => ref
                          .read(remindersNotifierProvider.notifier)
                          .insertAt(_deletedIndex!, _deletedItem!),
                    )),
              );
            },
            child: ReminderListItem(
              reminder: reminders[index],
            ),
          );
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
      floatingActionButton: floatingActionButton,
    );
  }
}
