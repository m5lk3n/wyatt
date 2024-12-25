import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/helper.dart';

String _getLegalese() {
  final int currentYear = DateTime.now().year;

  final prefix =
      (Common.appStartYear == currentYear) ? '' : '$Common.appStartYear-';

  return /* TODO: add (c)? '\u00a9 ' */ '$prefix$currentYear by';
}

void showWyattAboutDialog(BuildContext context) {
  final aboutDialog = AboutDialog(
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

  showDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: Style.aboutTheme,
          child: aboutDialog,
        );
      });
}

Widget createBackground(context) {
  const Color color1 = Style.seedColor;
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
            hintText: 'Enter a distance in\u00A0',
            /* this is a right-aligned hint text if no number is provided.
               it's followed by the unit from suffixText.
               \u00A0 is a non-breakable space to avoid Dart's default right-trimming.
               result on screen is: Enter a distance in m*/
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
          color: Style.iconicBackgroundColor,
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
          color: Style.iconicBackgroundColor,
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
    return GestureDetector(
        onTap: () {
          browseTo(Url.dev);
        },
        child: Image.asset('assets/images/logo.png', height: Style.bigSpace));
  }
}
