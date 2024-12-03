import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/reminder.dart';
import 'package:wyatt/screens/reminder.dart';

class ReminderListItem extends StatelessWidget {
  const ReminderListItem({super.key, required this.reminder});

  final Reminder reminder;

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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ReminderScreen(reminder: reminder)),
          );
        },
        splashColor: Theme.of(context).primaryColor,
        child: ListTile(
            // TODO: make disposable
            isThreeLine: false,
            tileColor: Theme.of(context).colorScheme.onSecondary,
            title: Text(
              "${reminder.notificationMessage} at ${reminder.locationAlias ?? {
                    reminder.locationData.latitude,
                    reminder.locationData.longitude
                  }}",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            leading: Icon(
              reminder.enabled ? Icons.volume_up : Icons.volume_off,
            ),
            trailing: ThreeDotsMenu()),
      ),
    );
  }
}

// https://flutter.github.io/samples/web/material_3_demo/
class ThreeDotsMenu extends StatelessWidget {
  const ThreeDotsMenu({super.key});

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
          onPressed: () {}, // TODO: implement
        ),
        MenuItemButton(
          child: const Text('Delete'),
          onPressed: () {}, // TODO: implement
        ),
        MenuItemButton(
          child: const Text('Toggle Snooze'),
          onPressed: () {}, // TODO: implement
        ),
      ],
    );
  }
}
