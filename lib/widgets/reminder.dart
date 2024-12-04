import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/screens/reminder.dart';

class ReminderListItem extends StatefulWidget {
  const ReminderListItem({
    super.key,
    required this.reminder,
  });

  final Reminder reminder;

  @override
  State<ReminderListItem> createState() => _ReminderListItemState();
}

class _ReminderListItemState extends State<ReminderListItem> {
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
          editReminder(context);
        },
        splashColor: Theme.of(context).primaryColor,
        child: ListTile(
          isThreeLine: false,
          tileColor: Theme.of(context).colorScheme.onSecondary,
          title: Text(
            "${widget.reminder.notificationMessage} at ${widget.reminder.locationAlias ?? {
                  widget.reminder.locationData.latitude,
                  widget.reminder.locationData.longitude
                }}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          trailing: IconButton(
            onPressed: () {
              toggleSnoozeReminder();
            },
            icon: Icon(
              widget.reminder.enabled ? Icons.volume_up : Icons.volume_off,
            ),
          ),
        ),
      ),
    );
  }

  void editReminder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              ReminderScreen(reminder: widget.reminder)),
    );
  }

  void toggleSnoozeReminder() {
    setState(() {
      widget.reminder.enabled = !widget.reminder.enabled;
    });
  }
}
