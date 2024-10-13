import 'package:flutter/material.dart';

PreferredSizeWidget getWyattAppBar(BuildContext context, String title) {
  return AppBar(
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
}
