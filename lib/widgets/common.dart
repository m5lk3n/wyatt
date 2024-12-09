import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wyatt/common.dart';

String _getLegalese() {
  const int startYear = 2024;
  final int currentYear = DateTime.now().year;

  final prefix = (startYear == currentYear) ? '' : '$startYear-';

  return /* TODO '© '? unicode? */ '$prefix$currentYear by';
}

Widget createAboutDialog(BuildContext context) => AboutDialog(
      applicationName: Common.appName,
      applicationVersion: "v${Common.appVersion}",
      applicationIcon: AppIconSmall(),
      applicationLegalese: _getLegalese(),
      children: [
        Logo(),
        Text(
          '\nWhen You Are There, Then...',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontStyle: FontStyle.italic),
        ),
      ],
    );

Widget createBackground(context) {
  const Color color1 = Common.seedColor;
  final Color color2 = Theme.of(context)
      .colorScheme
      .surface; // Theme.of(context).colorScheme.outlineVariant;
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  return Column(
    children: [
      Row(
        children: [
          Container(
            color: color1,
            width: screenWidth / 2,
            height: screenHeight / 2,
          ),
          Container(
            color: color2,
            width: screenWidth / 2,
            height: screenHeight / 2,
          ),
        ],
      ),
      Row(
        children: [
          Container(
            color: color2,
            width: screenWidth / 2,
            height: screenHeight / 2,
          ),
          Container(
            color: color1,
            width: screenWidth / 2,
            height: screenHeight / 2,
          ),
        ],
      ),
    ],
  );
}

Widget createDistanceField(
  BuildContext context,
  TextEditingController distanceController,
  bool isProcessing,
) {
  return Flexible(
    // https://stackoverflow.com/questions/57242651/using-fractionallysizedbox-in-a-row
    child: FractionallySizedBox(
      widthFactor: 1,
      alignment: Alignment.centerLeft,
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly // no decimal point, no sign
        ],
        enabled: !isProcessing,
        // causes keyboard to slide up: autofocus: true,
        controller: distanceController,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
            // prefixIcon: Icon(Icons.straighten),
            labelText: 'Notification Distance *',
            hintText: 'Enter a distance',
            suffixText: 'm', // TODO: support yards?
            helperText: 'Minimum 100 m'),
        maxLength: 4,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
        validator: (value) {
          return (value == null ||
                  int.tryParse(value) == null ||
                  int.tryParse(value)! < 100)
              ? 'Please provide a distance of at least 100 m'
              : null; // success
        },
      ),
    ),
  );
}

class AppIcon extends StatelessWidget {
  final double size = 100;

  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Stack(children: [
        Container(
          color: Common.iconicBackgroundColor,
          height: size,
          width: size,
        ),
        Container(
          alignment: Alignment.center,
          height: size,
          width: size,
          child: Image.asset('assets/icon/icon.png', height: (2 / 3) * size),
        ),
      ]),
    );
  }
}

class AppIconSmall extends StatelessWidget {
  final double size = 64;

  const AppIconSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Stack(children: [
        Container(
          color: Common.iconicBackgroundColor,
          height: size,
          width: size,
        ),
        Image.asset('assets/icon/icon-small.png'),
      ]),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/logo.png', height: Common.bigSpace);
  }
}
