import 'package:flutter/material.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/screens/reminders.dart';
import 'package:wyatt/screens/settings.dart';
import 'package:wyatt/widgets/common.dart';

class WyattDrawer extends StatelessWidget {
  const WyattDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Row(children: [
              ClipOval(
                child: Image.asset("assets/icon/icon-small.png"),
              ),
              SizedBox(width: space / 2),
              Text(
                Common.appName,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ]),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    size: 32, // half the size of the icon
                  ),
                  title: const Text(Common.screenHome),
                  onTap: () {
                    // TODO
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    size: 32, // half the size of the icon
                  ),
                  title: const Text(Common.screenReminders),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => RemindersScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    size: 32, // half the size of the icon
                  ),
                  title: const Text(Common.screenSettings),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: const Icon(
                Icons.info,
                size: 32, // half the size of the icon
              ),
              title: const Text(Common.screenAbout),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return Theme(
                      data: Theme.of(context)
                          .copyWith(dialogBackgroundColor: seedColor),
                      child: createAboutDialog(context),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
