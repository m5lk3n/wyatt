import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';

PreferredSizeWidget createWyattAppBar(BuildContext context, String title) =>
    AppBar(
      //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      /*
        leading: IconButton(
          onPressed: () {
            // TODO: Navigate to home screen
          },
          icon: Icon(Icons.home),
        ),
        */
      /*
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.info,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Theme(
                data: Theme.of(context)
                    .copyWith(dialogBackgroundColor: Colors.brown),
                child: _createAboutDialog(),
              );
            },
          );
        },
      )
    ],*/
    );

String _getLegalese() {
  const int startYear = 2024;
  final int currentYear = DateTime.now().year;

  final prefix = (startYear == currentYear) ? '' : '$startYear-';

  return /* TODO '© '? */ '$prefix$currentYear by';
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
              ),
        ),
      ],
    );