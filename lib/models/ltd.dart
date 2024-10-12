import 'package:uuid/uuid.dart';

const uuid = Uuid();

class LocationToDo {
/*
- Input:
  - Location coordinates (widget?)
  - Location name (optional string)
  - Distance (mandatory integer >= 0. in which unit? meters? default?)
  - Message (mandatory non-empty string, one liner)
  - Start Time (optional. if set, always starts at 00:00:00)
  - End Time (optional. if set, always starts at 23:59:59)
  - --
  - Later:
    - Type (Approaching, Leaving, Staying)
    - Recurring (interval)
    - Action (Check/Done, Snooze, Cancel)
*/
  LocationToDo(
      {required this.location,
      required this.message,
      distance,
      startDate,
      endDate})
      : id = uuid.v4(),
        distance = 500;

  final String id;
  final String
      location; // name // TODO: change to optional, add location coordinates
  final int distance;
  final String message;
  DateTime? startDate;
  DateTime? endDate;
}
