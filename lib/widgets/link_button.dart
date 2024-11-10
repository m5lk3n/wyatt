import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// https://stackoverflow.com/questions/43583411/how-to-create-a-hyperlink-in-flutter-widget
class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.urlLabel,
    required this.url,
  });

  final String urlLabel;
  final String url;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),*/
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //visualDensity: VisualDensity.compact,
          minimumSize: const Size(0, 0),
          textStyle: Theme.of(context).textTheme.bodyLarge
          /*
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              //decoration: TextDecoration.underline,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            */
          ),
      onPressed: () {
        _launchUrl(url);
      },
      child: Text(urlLabel),
    );
  }
}
