import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/ltd.dart';

class LtdGridItem extends StatelessWidget {
  const LtdGridItem({super.key, required this.ltd});

  final LocationToDo ltd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(space),
      child:
          InkWell /* provides a visual feedback when the user taps the item*/ (
        onTap: () {
          // TODO
        },
        splashColor: Theme.of(context).primaryColor,
        child: GridTile(
          //child: Expanded(
          child: Text(
            "${ltd.message} at ${ltd.locationName}",
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
