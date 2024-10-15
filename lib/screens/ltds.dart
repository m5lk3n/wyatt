import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/data/seed.dart';
import 'package:wyatt/widgets/common.dart';
import 'package:wyatt/widgets/drawer.dart';
import 'package:wyatt/widgets/ltd.dart';

class LtdsScreen extends StatelessWidget {
  const LtdsScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nothing to do',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: space / 2),
          Text(
            'Add some to-dos to get started',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );

    if (seedLtds.isNotEmpty) {
      content = GridView.builder(
        itemCount: seedLtds.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns horizontally
          childAspectRatio: 3 / 2,
          crossAxisSpacing: space, // 20 pixels between columns
          mainAxisSpacing: space, // 20 pixels between rows
        ),
        itemBuilder: (context, index) {
          return LtdGridItem(ltd: seedLtds[index]);
        },
      );
    }

    return Scaffold(
      appBar: getWyattAppBar(context, title),
      body: content,
      drawer: WyattDrawer(),
    );
  }
}
