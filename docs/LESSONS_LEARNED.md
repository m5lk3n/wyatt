# Lessons Learned

## My related Medium articles

- [Dynamic (and Secure) Google Maps API Key in Flutter](https://m5lk3n.medium.com/dynamic-and-secure-google-maps-api-key-in-flutter-2e7df6c70bd4)

## Not yet documented :construction_worker:

- Workmanager notifications don't work without a cell phone plan which includes data; a hot-spotted Wifi connection is not enough (see limited connectivity from cell phone provider in [screenshot](../device_screens/screenshots/no-notifications.png)). Notifications are not reliable in general.
- If possible, use actual devices to test, simply because the dev turnaround is so much quicker.
- https://developer.android.com/develop/sensors-and-location/location/geofencing and `geofence_foreground_service` are not usable:
  - Reminders are limited to 100 due to technical restriction (https://developer.android.com/develop/sensors-and-location/location/geofencing).
  - https://developers.google.com/android/reference/com/google/android/gms/location/GeofenceStatusCodes.html#GEOFENCE_TOO_MANY_PENDING_INTENTS -> `geofence_foreground_service`: with one zone (=request ID), last one wins = geofence gets overwritten, with many zones: GEOFENCE_TOO_MANY_PENDING_INTENTS if more than 5 zones
