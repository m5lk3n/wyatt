import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wyatt/widgets/location_picker.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LocationPicker(
      locationData: LocationData.fromMap({
        'latitude': 52.0892639,
        'longitude': 4.3840610,
      }),
    );
  }
}
