import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:wyatt/log.dart';

Future<String> determineAddress(LocationData locationData) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    locationData.latitude!,
    locationData.longitude!,
  );

  if (placemarks.isEmpty) {
    log.debug('no placemarks at address');
    return 'Unknown';
  }

  Placemark placemark = placemarks.first;

  return '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
}
