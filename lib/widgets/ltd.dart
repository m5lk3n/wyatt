import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/models/ltd.dart';

class LtdGridItem extends StatelessWidget {
  const LtdGridItem({super.key, required this.ltd});

  final LocationToDo ltd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Text(
        "${ltd.message} at ${ltd.locationName}",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
