# Wyatt

<div>
  <img alt="Wyatt logo" style="vertical-align: middle;" src="assets/icon/icon-small.png"/> <i>W</i>hen <i>Y</i>ou <i>A</i>re <i>T</i>here <i>T</i>hen ...
</div>

A location- and time-based reminder app for Android and iOS.

<img alt="Wyatt screenrecording" src="device_screens/screenrecording.gif" width="33%"/>

## Documentation

- [Appendix](docs/APPENDIX.md)
- [Backlog](docs/BACKLOG.md)
- [Bookmarks](docs/BOOKMARKS.md)
- [Dev](docs/DEV.md)
- [How-to](docs/HOWTO.md)
- [Ideas](docs/IDEAS.md) (partially outdated, archivable)
- [Styleguide](docs/STYLEGUIDE.md)
- [To-do](docs/TODO.md)

## [Use Cases](docs/IDEAS.md#use-cases)

## Tips

- If you plan to be notified for a bigger place, like a mall, give it a good radius. Not a good example is a distance of 100 m from the center of the mall as this probably doesn't trigger a notification around the mall.

- There should be a minimum of ~2h for a notification start and end date/time window, esp. when traveling (due to the (OS given) 15 mins interval between background activities).

## Repo Structure

```
.
├── .vscode        # Wyatt: app launch configs
├── android        # Flutter
├── assets         # Wyatt: app icons and images
├── device_screens # Wyatt: app screenshots and screenrecording
├── docs           # Wyatt: documentation incl. images
├── ios            # Flutter
├── lib            # Flutter
├── logcat         # Wyatt: for logcat-specific logging
├── lttl.dev       # Wyatt: app supporting web page 
└── test           # Flutter
```

## Get Started (DEV)

TODO

## Wireframe

[Mockup](docs/wireframe.pdf)

## Known issues

- Reordering of reminders is not yet persistent.
- Android only: With the Nova Launcher, the app icon doesn't show the white (circular) background as intended (and as it does with the default launcher), but a dark-greyish one.

## Lessons learned

- Workmanager notifications don't work without a cell phone plan which includes data; a hot-spotted Wifi connection is not enough (see limited connectivity from cell phone provider in [screenshot](screenshots/no-reminders.png))
- If possible, use actual devices to test, simply because the dev turnaround is so much quicker.
- GoogleMap with static key baked in, even obfuscated just a matter of reverse engineering
  - Dynamic plugin
    - requires dummy key entry `com.google.android.geo.API_KEY` in `AndroidManifest.xml`
    - requires `setState()` to trigger key refresh on time
- Document why https://developer.android.com/develop/sensors-and-location/location/geofencing and `geofence_foreground_service` are not usable:
  - Limit reminders to 100 due to technical restriction (https://developer.android.com/develop/sensors-and-location/location/geofencing), document.
  - https://developers.google.com/android/reference/com/google/android/gms/location/GeofenceStatusCodes.html#GEOFENCE_TOO_MANY_PENDING_INTENTS -> `geofence_foreground_service`: with one zone (=request ID), last one wins = geofence gets overwritten, with many zones: GEOFENCE_TOO_MANY_PENDING_INTENTS if more than 5 zones

## Acknowledgements

- Max Schwarzmüller for his incredible [Flutter & Dart - The Complete Guide [2024 Edition]](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
- Copilot for the Wyatt logo and the AppBar background
- Google for Maps and the font(s)
- [Moqups](https://app.moqups.com) for the wireframe
- [zeshuaro](https://github.com/zeshuaro) for [Appainter](https://appainter.dev/)