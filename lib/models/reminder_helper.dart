import 'package:haversine_distance/haversine_distance.dart' as hav;
import 'package:location/location.dart';

int calcDistanceBetweenInM(
    LocationData currentLocationData, LocationData targetLocationData) {
  final haversineDistance = hav.HaversineDistance();
  final targetLocation =
      hav.Location(targetLocationData.latitude!, targetLocationData.longitude!);
  final currentLocation = hav.Location(
      currentLocationData.latitude!, currentLocationData.longitude!);

  final distance = haversineDistance
      .haversine(targetLocation, currentLocation, hav.Unit.METER)
      .floor();

  return distance;
}
