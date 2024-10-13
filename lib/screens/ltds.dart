import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/data/seed.dart';
import 'package:wyatt/widgets/common.dart';
import 'package:wyatt/widgets/ltd.dart';

class LtdsScreen extends StatelessWidget {
  const LtdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getWyattAppBar(context, 'Locations & To-dos'),
      body: GridView(
        /* TODO use builder and itemBuilder (loads as much as needed) here instead of children (always everything) below */
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns horizontally
          childAspectRatio: 3 / 2,
          crossAxisSpacing: space, // 20 pixels between columns
          mainAxisSpacing: space, // 20 pixels between rows
        ),
        children: [
          for (final ltd in seedLtds) LtdGridItem(ltd: ltd),
        ],
      ),
    );
  }
}
