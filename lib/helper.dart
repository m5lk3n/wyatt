import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

Future<void> browseTo(String url) async {
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(uri)) {
    log('Could not launch $uri', name: 'browseTo');
  }
}
