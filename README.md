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
  - [ ] Load reminders into an overview list (not a grid) ([exemplified fetch](https://docs.flutter.dev/cookbook/networking/fetch-data))
    - [ ] Pre-seed (?)
  - [ ] Sort reminders overview by (due) date or by city name
  - [ ] Search reminders (?)
  - [ ] Filter reminders (?)

  - [ ] Manage reminders (through dots menu)
    - [ ] [Add a reminder](https://api.flutter.dev/flutter/material/Icons/add-constant.html)
      - [x] Evaluate and use a location picker:
            - [map_location_picker](https://pub.dev/packages/map_location_picker)
            - [Custom Map For Location Picker](https://community.flutterflow.io/c/community-custom-widgets/post/custom-map-for-location-picker-kPu8C7qdo1eSy0h)
            - [how to pick an address from map in flutter](https://stackoverflow.com/questions/69443353/how-to-pick-an-address-from-map-in-flutter)
    - [ ] [Edit a reminder](https://api.flutter.dev/flutter/material/Icons/edit-constant.html)
    - [ ] [Delete a reminder](https://api.flutter.dev/flutter/material/Icons/delete-constant.html)
    - [ ] [Snooze/Turn off a reminder](https://api.flutter.dev/flutter/material/Icons/volume_off-constant.html) or [Suspend a reminder](https://api.flutter.dev/flutter/material/Icons/location_off-constant.html)
    - [ ] [Activate/Turn on a reminder](https://api.flutter.dev/flutter/material/Icons/volume_up-constant.html) or [Hibernate a reminder](https://api.flutter.dev/flutter/material/Icons/location_on-constant.html)

- [x] Settings
  - [x] Save key
  - [x] Choose Language (foreseen)
  - [x] Choose Metric/Imperial units (foreseen)
  - [x] Default notification distance (500m)
  - [x] Reset to factory settings

- [x] Indicate invalid key in appbar

- [ ] Download my data (?)

- [ ] [_handleLocationPermission](https://github.com/m5lk3n/locato/blob/main/lib/location_page.dart#L44)

- [ ] Check Internet connectivity

- [ ] Implement Haversine (`flutter pub add haversine_distance`)

- [ ] Implement notification

      https://pub.dev/packages/location:

      *You can also get continuous callbacks when your position is changing:*

      ```
      location.onLocationChanged.listen((LocationData currentLocation) {
        // Use current location
      });
      ```

      *To receive location when application is in background you have to enable it:*

      ```
      location.enableBackgroundMode(enable: true)
      ```

## Wireframe

[Mockup](docs/wireframe.pdf)

## To do

- [ ] Field validation
- [ ] Logging, levels, see also [here](https://medium.com/@sunisha.guptan/cracking-the-code-debugging-magic-in-flutter-release-mode-f2e089a61f78)
- [ ] DRY
- [ ] Recover from crash
- [ ] Clarify minimal API key scope and document
- [ ] Clarify permissions
  - [ ] https://developer.android.com/develop/sensors-and-location/location/retrieve-current#permissions
  - [ ] See "Permissions" under https://github.com/Michael-M-aher/location_picker_flutter_map/tree/main?tab=readme-ov-file#setup
  - [ ] [android.permission.INTERNET / com.apple.security.network.client](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [ ] Document permissions
  - e.g., [location](https://pub.dev/packages/location) package: "Remember that the user has to accept the location permission to always allow to use the background location."
- [ ] [Source](https://github.com/fernandoptrr/flutter-location-practice/tree/master):
  - [ ] Add `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>` to `AndroidManifest.xml` as well
  - [ ] Clarify: `Geolocator.getCurrentPosition` is only executed on physical devices that are online (!?)
- [ ] Add `intl`
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

- Seeding?
- Add/Edit Location
  - Default Notification Distance widget (see also settings)

## Open

- Are all StatefulWidgets needed?
- Theme.of vs. Theme.of.copyWith?
- What if navigation back from Settings happens during saving?
- Suspend app, wake up?
- Recover from "panic"/exception (loss of connectivity in a tunnel?)
- Merge nearby reminders?
- Support landscape mode?
- License?

## Backlog

- [ ] Sort reminders overview by continent name
- [ ] [Share a reminder](https://api.flutter.dev/flutter/material/Icons/share_location-constant.html)
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
