import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/address_loader.dart';
import 'package:wyatt/widgets/datetime_picker.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _aliasController = TextEditingController();

  @override
  void dispose() {
    _aliasController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // avoid bottom overflow
      appBar: WyattAppBar(context, Screen.editLocation),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              Common.space,
              Common.space,
              0,
            ),
            child: AddressLoader(
              locationData: LocationData.fromMap({
                'latitude': 52.0892639, // TODO/FIXME -> add also to model
                'longitude': 4.3840610,
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              Common.space,
              Common.space,
              0,
            ),
            child: TextField(
              enableSuggestions: false,
              autocorrect: false,
              // causes keyboard to slide up: autofocus: true,
              controller: _aliasController,
              decoration: InputDecoration(
                label: const Text(
                    "Location Alias"), // TODO/FIXME -> add also to model
                hintText: "Enter a location alias here",
              ),
              maxLength: 40,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              Common.space,
              Common.space,
              0,
            ),
            child: DateTimePicker(
              label: 'Start Notification',
              hintText: 'Select start date & time',
              dateTime: DateTime.now().subtract(
                  Duration(hours: 1)), // TODO/FIXME -> add also to model
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(
                Common.space,
                Common.space,
                Common.space,
                0,
              ),
              child: DateTimePicker(
                  label: 'End Notification', // TODO/FIXME -> add also to model
                  hintText: 'Select end date & time')),
          Divider(
            indent: Common.space,
            endIndent: Common.space,
          ),
          Padding(
            padding: const EdgeInsets.all(Common.space),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                  ),
                  onPressed: null, // TODO: validate/implement
                  autofocus: true,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
