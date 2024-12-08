import 'package:url_launcher/url_launcher.dart';

Future<void> browseToUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri'); // TODO: intended/handle this?
  }
}
