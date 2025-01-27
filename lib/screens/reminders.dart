import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/core.dart';
import 'package:wyatt/data/seed.dart';
import 'package:wyatt/log.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/providers/reminders_provider.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/drawer.dart';
import 'package:wyatt/widgets/reminder.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  // required for undo:
  Reminder? deletedItem;
  int? deletedIndex;
  CoreSystem? core;

  @override
  void initState() {
    super.initState();

    core = CoreSystem(ref);
    core!.checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    Widget? floatingActionButton;

    final reminders = ref.watch(remindersNotifierProvider);
    log.debug('got ${reminders.length} reminders', name: '$runtimeType');
    setBackgroundReminders(reminders.where((r) => r.isActive()).toList());

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
            const SizedBox(height: Style.space),
            Text(
              'Hit + above to get started',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: Style.space / 2),
            Text(
              textAlign: TextAlign.center,
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
                    .copyWith(dialogBackgroundColor: Style.seedColor),
                child: AlertDialog(
                  title: Text(
                    'Inspire me',
                    style: Style.getDialogTitleStyle(context),
                  ),
                  content: Text(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      'Are you ok with a sample reminder list?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        log.debug('seeding ${seedReminders.length} reminders',
                            name: '$runtimeType');
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
      // ReorderableListView: _sortByMessage(reminders);
      content = ReorderableListView.builder(
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = reminders.removeAt(oldIndex);
          ref.read(remindersNotifierProvider.notifier).remove(item);
          reminders.insert(newIndex, item);
          ref.read(remindersNotifierProvider.notifier).insertAt(newIndex, item);
        },
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              color: Style.seedColor,
              padding: EdgeInsets.symmetric(horizontal: Style.space),
              alignment: AlignmentDirectional.centerStart,
              child: Icon(
                Icons.delete,
              ),
            ),
            secondaryBackground: Container(
              color: Style.seedColor,
              padding: EdgeInsets.symmetric(horizontal: Style.space),
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
                        .copyWith(dialogBackgroundColor: Style.seedColor),
                    child: AlertDialog(
                      title: Text(
                        'Confirmation needed',
                        style: Style.getDialogTitleStyle(context),
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
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
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
              deletedItem = reminders.removeAt(index);
              deletedIndex = index;
              ref.read(remindersNotifierProvider.notifier).remove(deletedItem!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Reminder deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => ref
                          .read(remindersNotifierProvider.notifier)
                          .insertAt(deletedIndex!, deletedItem!),
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

    return Container(
      // https://stackoverflow.com/questions/52572850/how-can-i-avoid-the-background-image-to-shrink-when-my-keyboard-is-active/70428060#70428060
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .onInverseSurface, //surfaceContainerHighest,
        image: DecorationImage(
          image: AssetImage('assets/icon/icon-medium.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: WyattAppBar(context: context, title: Screen.reminders),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            Style.space / 2,
            0,
            0,
          ),
          child: content,
        ),
        drawer: WyattDrawer(),
        floatingActionButton: floatingActionButton,
      ),
    );
  }

/*
  void _sortByMessage(List<Reminder> reminders) {
    reminders.sort((r1, r2) => r1.notificationMessage
        .toLowerCase()
        .compareTo(r2.notificationMessage.toLowerCase()));
  }
*/
}
