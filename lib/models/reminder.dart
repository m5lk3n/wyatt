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
    this.id,
    required this.locationData,
    required this.notificationMessage,
    this.locationAlias,
    this.notificationStartDateTime,
    this.notificationEndDateTime,
    this.notificationDistance = Default.notificationDistance,
    this.enabled = true, // snoozed or not
    this.notified = false,
    this.inError = false,
  }) {
    id ??= uuid.v4();
  }

  String? id;
  final LocationData locationData;
  final String notificationMessage;
  String? locationAlias;
  int notificationDistance;
  DateTime? notificationStartDateTime;
  DateTime? notificationEndDateTime;
  bool enabled;
  bool notified;
  bool inError;

  void setDone() {
    setDisabled();
    setNotified();
  }

  void reset() {
    setEnabled();
    notified = false;
    inError = false;
  }

  void setInError() {
    inError = true;
    setDisabled();
  }

  bool isInError() {
    return inError;
  }

  // for consistency
  void setEnabled() {
    enabled = true;
  }

  // for consistency
  void setDisabled() {
    enabled = false;
  }

  // for consistency
  void setNotified() {
    notified = true;
    inError = false;
  }

  // for consistency
  bool isNotified() {
    return notified;
  }

  // for consistency
  bool isEnabled() {
    return enabled;
  }

  // for convenience
  bool isDisabled() {
    return !enabled;
  }

  bool isExpired() {
    return notificationEndDateTime != null &&
        notificationEndDateTime!.isBefore(DateTime.now());
  }

  bool isDateTimeValid() {
    if (notificationEndDateTime == null) {
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

    return ('$notificationMessage at $location');
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      locationData: LocationData.fromMap(json['locationData']),
      notificationMessage: json['notificationMessage'],
      locationAlias: json['locationAlias'],
      notificationDistance: json['notificationDistance'],
      notificationStartDateTime: json['notificationStartDateTime'] != null
          ? DateTime.parse(json['notificationStartDateTime'])
          : null,
      notificationEndDateTime: json['notificationEndDateTime'] != null
          ? DateTime.parse(json['notificationEndDateTime'])
          : null,
      enabled: json['enabled'],
      notified: json['notified'],
      inError: json['inError'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationData': {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
      },
      'notificationMessage': notificationMessage,
      'locationAlias': locationAlias,
      'notificationDistance': notificationDistance,
      'notificationStartDateTime': notificationStartDateTime?.toIso8601String(),
      'notificationEndDateTime': notificationEndDateTime?.toIso8601String(),
      'enabled': enabled,
      'notified': notified,
      'inError': inError,
    };
  }

/*
  bool isInRange(LocationData currentLocation) {
    return _distanceBetween(locationData, currentLocation) <=
        notificationDistance;
  }
*/
}
