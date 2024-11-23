import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

Future<String> determineAddress(LocationData locationData) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    locationData.latitude!,
    locationData.longitude!,
  );

  if (placemarks.isEmpty) {
    log('Location picker: no placemarks');
    return 'unknown';
  }

  Placemark placemark = placemarks.first;

  return '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
}
