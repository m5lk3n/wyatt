import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/providers/reminders_provider.dart';
import 'package:wyatt/screens/reminder.dart';

class ReminderListItem extends ConsumerStatefulWidget {
  const ReminderListItem({
    super.key,
    required this.reminder,
  });

  final Reminder reminder;

  @override
  ConsumerState<ReminderListItem> createState() => _ReminderListItemState();
}

class _ReminderListItemState extends ConsumerState<ReminderListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Common.space,
        Common.space / 2,
        Common.space,
        Common.space / 2,
      ),
      child:
          InkWell /* provides a visual feedback when the user taps the item*/ (
        onTap: () {
          _editReminder();
        },
        splashColor: Theme.of(context).primaryColor,
        child: ListTile(
          isThreeLine: false,
          tileColor: widget.reminder.isExpired()
              ? Theme.of(context).colorScheme.onInverseSurface
              : Theme.of(context).colorScheme.onSecondary,
          title: Text(
            '${widget.reminder}',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          trailing: IconButton(
            onPressed: () {
              widget.reminder.isExpired()
                  ? _editReminder()
                  : _toggleSnoozeReminder();
            },
            icon: Icon(
              widget.reminder.isExpired()
                  ? Icons.notifications_paused
                  : widget.reminder.enabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
            ),
          ),
        ),
      ),
    );
  }

  void _editReminder() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              ReminderScreen(reminder: widget.reminder)),
    );
  }

  void _toggleSnoozeReminder() {
    widget.reminder.enabled = !widget.reminder.enabled;
    ref.read(remindersNotifierProvider.notifier).update(widget.reminder);
  }
}
