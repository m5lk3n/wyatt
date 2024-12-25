import 'package:flutter/foundation.dart';
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
  ),
  Reminder(
    locationData: LocationData.fromMap({
      'latitude': 44.869862147702186,
      'longitude': -122.63699677304652,
    }),
    locationAlias: 'Silver Falls State Park',
    notificationMessage: 'Hike the Trail of Ten Falls',
  ),
  Reminder(
    locationData: LocationData.fromMap({
      'latitude': 21.367471662637417,
      'longitude': -157.79311359303142,
    }),
    locationAlias: 'Pali Lookout',
    notificationMessage: 'Take a picture',
    enabled: kReleaseMode,
  ),
  if (kDebugMode)
    Reminder(
      locationData: LocationData.fromMap({
        'latitude': 52.0892639,
        'longitude': 4.3840610,
      }),
      locationAlias: 'Mall of The Netherlands',
      notificationMessage: 'Buy coffee',
      enabled: false,
      notificationStartDateTime:
          DateTime.now().subtract(const Duration(days: 10)),
      notificationEndDateTime: DateTime.now().subtract(const Duration(days: 7)),
    ),
  Reminder(
    locationData: LocationData.fromMap({
      'latitude': 46.977165535434615,
      'longitude': 11.109485325338017,
    }),
    locationAlias: 'Stubai Glacier',
    notificationMessage: 'Climb to the Top of Tyrol',
    notificationDistance: 9999,
    enabled: true,
  ),
];
