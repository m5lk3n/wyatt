import 'package:flutter/material.dart';
import 'package:wyatt/helper.dart';

// https://stackoverflow.com/questions/43583411/how-to-create-a-hyperlink-in-flutter-widget
class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.urlLabel,
    required this.url,
  });

  final String urlLabel;
  final String url;

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
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.primary)),
      onPressed: () {
        browseTo(url);
      },
      child: Text(urlLabel),
    );
  }
}
