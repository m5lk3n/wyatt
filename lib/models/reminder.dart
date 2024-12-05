import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:wyatt/common.dart';

const uuid = Uuid();

class Reminder {
/*
- Input:
  - Location data: Coordinates used to calculate distance away from current location
  - Notification message: Mandatory non-empty string, one liner
  - Location alias: _User_'s name for location (optional string)
  - Distance: Integer >= 0. (TODO: in which unit? meters? default?)
  - Start Time (optional. if set, always starts at 00:00:00)
  - End Time (optional. if set, always starts at 23:59:59)
  - --
  - Later:
    - Image
    - Type (Approaching, Leaving, Staying)
    - Recurring (interval)
    - Action (Check/Done, Snooze, Cancel)
*/
  Reminder({
    required this.locationData,
    required this.notificationMessage,
    this.locationAlias,
    this.notificationStartDateTime,
    this.notificationEndDateTime,
    this.notificationDistance = Default.notificationDistance,
    this.enabled = true,
  }) : id = uuid.v4();

  String id;
  final LocationData locationData;
  final String notificationMessage;
  String? locationAlias;
  int notificationDistance;
  DateTime? notificationStartDateTime;
  DateTime? notificationEndDateTime;
  bool enabled;

  bool isExpired() {
    return notificationEndDateTime != null &&
        notificationEndDateTime!.isBefore(DateTime.now());
  }

  bool validateDateTime() {
    if (notificationStartDateTime == null && notificationEndDateTime == null) {
      return true;
    }

    return notificationStartDateTime != null &&
        notificationEndDateTime != null &&
        notificationStartDateTime!.isBefore(notificationEndDateTime!);
  }

  @override
  String toString() {
    String location = (locationAlias != null && locationAlias!.isNotEmpty)
        ? locationAlias!
        : {locationData.latitude.toString(), locationData.longitude.toString()}
            .join(', ');

    return ("$notificationMessage at $location");
  }

/* TODO: implement this
  bool isInRange(LocationData currentLocation) {
    return locationData.distanceBetween(
            currentLocation.latitude!, currentLocation.longitude!) <=
        notificationDistance;
  }
*/
}
