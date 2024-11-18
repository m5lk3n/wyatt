import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/reminder.dart';

class ReminderGridItem extends StatelessWidget {
  const ReminderGridItem({super.key, required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Common.space),
      child:
          InkWell /* provides a visual feedback when the user taps the item*/ (
        onTap: () {
          // TODO
        },
        splashColor: Theme.of(context).primaryColor,
        child: GridTile(
          //child: Expanded(
          child: Text(
            "${reminder.message} at ${reminder.locationName}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
      //),
    );
  }
}
