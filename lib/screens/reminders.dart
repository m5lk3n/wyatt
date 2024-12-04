import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/data/seed.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/drawer.dart';
import 'package:wyatt/widgets/reminder.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Reminder> _items = List.from(seedReminders); // TODO: load

  @override
  Widget build(BuildContext context) {
    Widget content;
    Widget? floatingActionButton;

    if (_items.isEmpty) {
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
              'Add a reminder to get started',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                          setState(() {
                            log('Seeding ${seedReminders.length} reminders');
                            _items = List.from(seedReminders);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Seed')),
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
        itemCount: _items.length,
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
            key: ValueKey<Reminder>(_items[index]),
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
              deleteReminder(context, index);
            },
            child: ReminderListItem(
              reminder: _items[index],
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

  void deleteReminder(BuildContext context, int index) {
    setState(() {
      Reminder deletedItem = _items.removeAt(index);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder deleted'),
          action: SnackBarAction(
              label: 'UNDO',
              onPressed: () => setState(
                    () => _items.insert(index, deletedItem),
                  )),
        ),
      );
    });
  }
}
