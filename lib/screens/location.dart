import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:wyatt/widgets/location_picker.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // avoid bottom overflow
      appBar: WyattAppBar(context, "Edit Location"),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Common.space,
              Common.space,
              Common.space,
              0,
            ),
            child: LocationPicker(
              locationData: LocationData.fromMap({
                'latitude': 52.0892639,
                'longitude': 4.3840610,
              }),
            ),
          ),
        ],
      ),
    );
  }
}
