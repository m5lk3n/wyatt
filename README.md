# Wyatt

![](assets/icon/icon-small.png)

"*W*hen *Y*ou *A*re *T*here *T*hen ..."

A location- and time-based To-do app for iOS and Android.

:construction_worker:

## Tips

- If you plan to be notified for a bigger place, like a mall, give it a good radius. Not a good example is a distance of 100m from the center of the mall as this probably doesn't trigger a notification around the mall.

## Structure

```
.
├── .vscode     # me: app launch configs
├── android     # Flutter
├── assets      # me: app icons and images
├── docs        # me
├── ios         # Flutter
├── lib         # Flutter
├── lttl.dev    # me: app supporting web page 
├── screenshots # me: app screenshots 
└── test        # Flutter
```

## Steps

- [x] `flutter create --platforms android,ios --org dev.lttl wyatt`
- [x] `rm wyatt.iml`
- [x] `rm android/wyatt_android.iml`
- [x] `rm -rf .idea`
- [x] clean up `.gitignore`

- Copilot prompt to 
  - "Create a black and white logo showing a cowboy like an old wanted poster", download and save as 512x512 `assets/icon/icon.png`
  - "Create a brown leather background"
- [A Step-by-Step Guide to Adding Launcher Icons to Your Flutter App](https://nikhilsomansahu.medium.com/a-step-by-step-guide-to-adding-launcher-icons-to-your-flutter-app-98b5d7e3bb04)

- [x] Ask user to provide a key (the Google Maps API key) and store it securely on the client: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)

- [x] Splashcreen / Loading

- [x] Getting started (Set up Wyatt) (default if there's no key)
  - [x] Squared background color

- [ ] Home (default it there are no reminders)
  - [x] Intro text
    - [ ] Animate text (?) (see `flutter_animate`)
    - [x] Getting Started button at the bottom
  - [ ] Add help button right upper corner (?)
  - [x] Left drawer with
      - [Home](https://api.flutter.dev/flutter/material/Icons/home-constant.html)
      - [Reminders](https://api.flutter.dev/flutter/material/Icons/location_on-constant.html) ([alternative icon](https://api.flutter.dev/flutter/material/Icons/pin_drop-constant.html))
      - [Settings](https://api.flutter.dev/flutter/material/Icons/settings-constant.html)
      - [About](https://api.flutter.dev/flutter/material/Icons/info-constant.html)

- [ ] Reminders
  - [x] Load reminders into an overview list (not a grid) ([exemplified fetch](https://docs.flutter.dev/cookbook/networking/fetch-data))
    - [x] Seed option
  - (?) Sort reminders overview by (due) date or by city name
  - [ ] Search reminders
  - (?) Filter reminders

  - [x] Manage reminders ~~(through dots menu)~~
    - [x] [Add a reminder](https://api.flutter.dev/flutter/material/Icons/add-constant.html)
      - [x] Evaluate and use a location picker:
            - [map_location_picker](https://pub.dev/packages/map_location_picker)
            - [Custom Map For Location Picker](https://community.flutterflow.io/c/community-custom-widgets/post/custom-map-for-location-picker-kPu8C7qdo1eSy0h)
            - [how to pick an address from map in flutter](https://stackoverflow.com/questions/69443353/how-to-pick-an-address-from-map-in-flutter)
    - [x] [Edit a reminder](https://api.flutter.dev/flutter/material/Icons/edit-constant.html)
    - [x] [Delete a reminder](https://api.flutter.dev/flutter/material/Icons/delete-constant.html)
    - [x] [Snooze/Turn off a reminder](https://api.flutter.dev/flutter/material/Icons/volume_off-constant.html) or [Suspend a reminder](https://api.flutter.dev/flutter/material/Icons/location_off-constant.html)
    - [x] [Activate/Turn on a reminder](https://api.flutter.dev/flutter/material/Icons/volume_up-constant.html) or [Hibernate a reminder](https://api.flutter.dev/flutter/material/Icons/location_on-constant.html)

- [x] Settings
  - [x] Save key
  - [x] Choose Language (foreseen)
  - [x] Choose Metric/Imperial units (foreseen)
  - [x] Default notification distance (500m)
  - [x] Reset to factory settings

- [x] Check and indicate invalid key in appbar
- [x] Check and indicate missing permissions in appbar
  - [x] https://pub.dev/packages/permission_handler
- [x] Handle broken (Internet) connectivity

- [x] Incorporate [loctose](https://github.com/m5lk3n/loctose/)
- [x] Incorporate [locato](https://github.com/m5lk3n/geo_fencing_demo/blob/main/lib/locato.dart)
- [x] [_handleLocationPermission](https://github.com/m5lk3n/locato/blob/main/lib/location_page.dart#L44)
- [x] Implement Haversine (`flutter pub add haversine_distance`)

- (?) Download my data

- [x] Implement notification
  - ~~(?) https://pub.dev/packages/awesome_notifications~~
  - [x] https://pub.dev/packages/flutter_local_notifications

## Wireframe

[Mockup](docs/wireframe.pdf)

## To do

- [ ] Reminder with tabs for `standard` add/edit and `advanced` (like approaching, leaving)
- [ ] Update screenshots
- [ ] Take over [Spec.](https://github.com/m5lk3n/locato?tab=readme-ov-file#spec)
- [ ] Search a location
- [ ] Time between the same notification
- [x] Field validation
- [ ] Logging, levels, see also [here](https://medium.com/@sunisha.guptan/cracking-the-code-debugging-magic-in-flutter-release-mode-f2e089a61f78)
- [ ] DRY
- [ ] Recover from crash (e.g., by revoking permissions)
- [ ] Add to each StatefulWidget (?) ((reasoning)[https://stackoverflow.com/questions/49340116/setstate-called-after-dispose]):

      @override
      void setState(fn) {
        if(mounted) {
          super.setState(fn);
        }
      }

- [ ] Clarify minimal API key scope and document
- [ ] Clarify permissions
  - [ ] https://developer.android.com/develop/sensors-and-location/location/retrieve-current#permissions
  - [ ] See "Permissions" under https://github.com/Michael-M-aher/location_picker_flutter_map/tree/main?tab=readme-ov-file#setup
  - [ ] [android.permission.INTERNET / com.apple.security.network.client](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [ ] Document permissions
  - updating permissions while the app is open requires an app action to refresh appbar to get rid of the error message reg. missing permissions
  - [geofence_foreground_service](https://pub.dev/packages/geofence_foreground_service) package: ACCESS_FINE_LOCATION and ACCESS_COARSE_LOCATION on Android, Core Location on iOS
- Clarify minimum requirements (Android (API) version, etc.), see e.g., Note under https://docs.flutter.dev/deployment/android#enable-multidex-support
- [ ] [Source](https://github.com/fernandoptrr/flutter-location-practice/tree/master):
  - [ ] Add `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>` to `AndroidManifest.xml` as well
  - [ ] Clarify: `Geolocator.getCurrentPosition` is only executed on physical devices that are online (!?)
- [ ] Add `intl` (e.g. https://emiliodinen.medium.com/flutter-guide-to-use-internalization-and-localization-c8feedb46ac1)
  - [ ] Unify syntax ("Enter Distance in Meters" or "Enter distance in meters")
- [ ] Add tests
- [x] Add delete key (and any other local data)
- [ ] TODOs in code
- [ ] Rename members to start with an underscore
- [ ] Adhere to conventions, lie *widget constructors only use named arguments. Also by convention, the first argument is key, and the last argument is child, children, or the equivalent.*
- [ ] Automate builds (`flutter build apk --obfuscate "--dart-define=KEY_URL=https://developers.google.com/maps/documentation/geocoding/get-api-key ...`)
- [ ] Generate `lttl.dev/wyatt/index.html`
- [ ] Godoc
- [ ] Clean up assets

## Doing

- https://medium.com/@ravipatel84184/integrating-local-notifications-in-flutter-using-flutter-local-notifications-package-3951c5fc21cd
- https://pub.dev/packages/flutter_local_notifications#scheduled-android-notifications

- Incorporate locato ([from geo_fencing_demo](https://github.com/m5lk3n/geo_fencing_demo/blob/main/lib/locato.dart))
  - https://stackoverflow.com/questions/64111677/streamsubscription-not-resuming-when-the-app-comes-back-to-foreground

- Auto-cancel expired reminders
- notification is a one-off!

- Add service
  - https://30dayscoding.com/blog/working-with-background-services-in-flutter-apps
  - https://pub.dev/packages/flutter_background_service
    (Background service: *iOS... cannot be faster than 15 minutes and only alive about 15-30 seconds.*/)
  - https://medium.com/@hasibulhasan3590/elevate-your-flutter-app-with-background-services-using-flutter-background-service-131f4ba7ec8a

  - https://github.com/fluttercommunity/flutter_workmanager/issues/151#issuecomment-612637579

- Time between notifications?

## Open

- Consolidate Geolocator and LocationData?
- Cancel workmanager?
- Check if async is always needed
- How to use `._();` construct / how to implement singletons?
- How to reset non-FormFields?
- Use riverpod with families or providerscope?
- Are all StatefulWidgets needed?
  - "Stateful widgets are mutable and they update their data every time a `setState((){data;})` is called."
  - "Stateless widgets on the other hand are immutable, i.e they contain data that shouldn't change during runtime."
- Theme.of vs. Theme.of.copyWith?
- What if navigation back from Settings happens during saving?
- Suspend app, wake up?
- Recover from "panic"/exception (loss of connectivity in a tunnel?)
- Merge nearby reminders?
- Support landscape mode?
- License?

## Lessons learned:

- If possible, use actual devices to test, simply because the dev turnaround is so much quicker.
- GoogleMap with static key baked in, even obfuscated just a matter of reverse engineering
  - Dynamic plugin
    - requires dummy key entry `com.google.android.geo.API_KEY` in `AndroidManifest.xml`
    - requires `setState()` to trigger key refresh on time
- Document why https://developer.android.com/develop/sensors-and-location/location/geofencing and `geofence_foreground_service` are not usable:
  - Limit reminders to 100 due to technical restriction (https://developer.android.com/develop/sensors-and-location/location/geofencing), document.
  - https://developers.google.com/android/reference/com/google/android/gms/location/GeofenceStatusCodes.html#GEOFENCE_TOO_MANY_PENDING_INTENTS -> `geofence_foreground_service`: with one zone (=request ID), last one wins = geofence gets overwritten, with many zones: GEOFENCE_TOO_MANY_PENDING_INTENTS if more than 5 zones

## Backlog / Outlook

- [ ] Sort reminders overview by continent name
- [ ] [Share a reminder](https://api.flutter.dev/flutter/material/Icons/share_location-constant.html)
- [ ] Support spoken reminders
- [ ] Enhance location with a picture taken
- [ ] OpenStreetMap version
  - https://github.com/Michael-M-aher/location_picker_flutter_map/
  - https://switch2osm.org/the-basics/
  - https://pub.dev/packages/flutter_osm_plugin
  - https://github.com/liodali/osm_flutter
  - https://help.openstreetmap.org/questions/9367/can-i-use-openstreetmaps-openstreetmaps-api-for-commercial-apps-on-android
  - https://stackoverflow.com/questions/51842695/openstreetmap-in-flutter
  - https://leafletjs.com/

## Docs

- [Styleguide](docs/STYLEGUIDE.md)
- [How-to](docs/HOWTO.md)
- [Bookmarks](docs/BOOKMARKS.md)
- [Ideas](docs/IDEAS.md) (partially outdated, archivable)
- [Appendix](docs/APPENDIX.md) (not app-specific)

## Acknowledgements

- Max Schwarzmüller for his incredible [Flutter & Dart - The Complete Guide [2024 Edition]](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
- Copilot for the Wyatt logo and the AppBar background
- Google for Maps and the font(s)
- [Moqups](https://app.moqups.com) for the wireframe
- [zeshuaro](https://github.com/zeshuaro) for [Appainter](https://appainter.dev/)

### Future Acknowledgements

- Map theme and tile by

  [![](https://maptiler.com/styles/style/logo/maptiler-logo-adaptive.svg?123#maptilerLogo)](https://maptiler.com/)
