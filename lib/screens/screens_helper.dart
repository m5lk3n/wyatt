import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/providers/settings_provider.dart';

Future<void> readDefaultNotificationDistance(
  WidgetRef ref,
  TextEditingController controller,
) async {
  final settings = ref.read(settingsNotifierProvider.notifier);
  int distance = await settings.getDefaultNotificationDistance();

  controller.text = distance.toString();
}
