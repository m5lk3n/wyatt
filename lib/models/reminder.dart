import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Reminder {
/*
- Input:
  - Location coordinates (widget, maps picker) -> used to calculate distance & to get name for from Geocode API
  - Location name (determined from coordinates)
  - Label: _User_'s name for location (optional string)
  - Distance (mandatory integer >= 0. in which unit? meters? default?)
  - Message (mandatory non-empty string, one liner)
  - Start Time (optional. if set, always starts at 00:00:00)
  - End Time (optional. if set, always starts at 23:59:59)
  - --
  - Later:
    - Image
    - Type (Approaching, Leaving, Staying)
    - Recurring (interval)
    - Action (Check/Done, Snooze, Cancel)
*/
  Reminder(
      {required this.locationCoordinates,
      required this.locationName,
      required this.message,
      label,
      distance,
      startDate,
      endDate})
      : id = uuid.v4(),
        label = label ?? '',
        distance = 500;

  final String id;
  final String locationCoordinates; // TODO: change type
  final String locationName; // TODO: get from Geocode API
  final String message;
  final String label;
  final int distance;
  DateTime? startDate;
  DateTime? endDate;
}
