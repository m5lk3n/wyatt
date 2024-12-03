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
  final List<Reminder> _items = seedReminders;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nothing here yet',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: Common.space / 2),
          Text(
            'Add a reminder to get started',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );

    if (_items.isNotEmpty) {
      content = ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              color: Common.seedColor,
            ),
            key: ValueKey<Reminder>(_items[index]),
            onDismissed: (DismissDirection direction) {
              setState(() {
                Reminder deletedItem = _items.removeAt(index);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Reminder deleted"),
                    action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () => setState(
                              () => _items.insert(index, deletedItem),
                            )),
                  ),
                );
              });
            },
            child: ReminderListItem(reminder: _items[index]),
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
    );
  }
}
