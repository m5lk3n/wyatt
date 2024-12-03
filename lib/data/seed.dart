import 'package:location/location.dart';
import 'package:wyatt/models/reminder.dart';

final seedReminders = [
  Reminder(
    locationData: LocationData.fromMap({
      'latitude': 37.537949599357454,
      'longitude': -122.29249353548951,
    }),
    locationAlias: 'Yumi Yogurt',
    notificationMessage: 'Eat ice cream',
    enabled: false,
  ),
  Reminder(
    locationData: LocationData.fromMap({
      'latitude': 52.0892639,
      'longitude': 4.3840610,
    }),
    locationAlias: 'Mall of The Netherlands',
    notificationMessage: 'Buy coffee',
    enabled: true,
  ),
];
