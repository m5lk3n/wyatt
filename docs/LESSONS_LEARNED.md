# Lessons Learned

:construction_worker:

- Workmanager notifications don't work without a cell phone plan which includes data; a hot-spotted Wifi connection is not enough (see limited connectivity from cell phone provider in [screenshot](screenshots/no-reminders.png)). Notifications are not reliable in general.
- If possible, use actual devices to test, simply because the dev turnaround is so much quicker.
- GoogleMap with static key baked in, even obfuscated, is just a matter of reverse engineering -> Solution:
  - Dynamic plugin
    - requires dummy key entry `com.google.android.geo.API_KEY` in `AndroidManifest.xml`, otherwise the following (TODO) error occurs
    - requires `setState()` to trigger key refresh on time
- https://developer.android.com/develop/sensors-and-location/location/geofencing and `geofence_foreground_service` are not usable:
  - Reminders are limited to 100 due to technical restriction (https://developer.android.com/develop/sensors-and-location/location/geofencing).
  - https://developers.google.com/android/reference/com/google/android/gms/location/GeofenceStatusCodes.html#GEOFENCE_TOO_MANY_PENDING_INTENTS -> `geofence_foreground_service`: with one zone (=request ID), last one wins = geofence gets overwritten, with many zones: GEOFENCE_TOO_MANY_PENDING_INTENTS if more than 5 zones
