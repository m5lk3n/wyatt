import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/screens/reminder.dart';

// ignore: must_be_immutable
class ReminderListItem extends StatefulWidget {
  ReminderListItem({super.key, required this.reminder});

  Reminder reminder;

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
            leading: IconButton(
              onPressed: () {
                toggleSnoozeReminder();
              },
              icon: Icon(
                widget.reminder.enabled ? Icons.volume_up : Icons.volume_off,
              ),
            ),
            trailing: ThreeDotsMenu(
              editReminder: editReminder,
              toggleSnoozeReminder: toggleSnoozeReminder,
            )),
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

// https://flutter.github.io/samples/web/material_3_demo/
class ThreeDotsMenu extends StatelessWidget {
  final dynamic editReminder;
  final dynamic toggleSnoozeReminder;

  const ThreeDotsMenu({
    super.key,
    required this.editReminder,
    required this.toggleSnoozeReminder,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Icon(
            Common.isIOS(context) ? Icons.more_horiz : Icons.more_vert,
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          child: const Text('Edit'),
          onPressed: () {
            editReminder(context);
          },
        ),
        MenuItemButton(
          child: const Text('Delete'),
          onPressed: () {}, // TODO: implement
        ),
        MenuItemButton(
          child: const Text('Snooze/Unsnooze'),
          onPressed: () {
            toggleSnoozeReminder();
          },
        ),
      ],
    );
  }
}
