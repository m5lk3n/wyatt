import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wyatt/app_routes.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/screens/settings.dart';

PreferredSizeWidget createWyattAppBar(BuildContext context, String title) {
  final bool isOnSettingsScreen = context.widget is SettingsScreen;
  final txtSuffix =
      isOnSettingsScreen ? "" : "\n\nYou can change the key in Settings.";

  return AppBar(
    flexibleSpace: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/appbar-bg.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    title: Text(title),
    actions: !Common.isKeyValid
        ? null
        : <Widget>[
            // TODO: lightbulb icon to seed
            IconButton(
              icon: Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Theme.of(context).colorScheme.onError,
                      title: Text("Error",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.error)),
                      content: Text(
                          "The key is invalid, the app won't work!$txtSuffix",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                      actions: <Widget>[
                        isOnSettingsScreen
                            ? SizedBox.shrink()
                            : TextButton(
                                child: Text("Go to Settings"),
                                onPressed: () {
                                  context.go(AppRoutes.settings);
                                },
                              ),
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
  );
}

String _getLegalese() {
  const int startYear = 2024;
  final int currentYear = DateTime.now().year;

  final prefix = (startYear == currentYear) ? '' : '$startYear-';

  return /* TODO '© '? unicode? */ '$prefix$currentYear by';
}

Widget createAboutDialog(BuildContext context) => AboutDialog(
      applicationName: Common.appName,
      applicationVersion: "v${Common.appVersion}",
      applicationIcon: ClipOval(
        child: Image.asset("assets/icon/icon-small.png"),
      ),
      applicationLegalese: _getLegalese(),
      children: [
        Image.asset(
          "assets/images/logo.png",
          width: 175,
        ),
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
