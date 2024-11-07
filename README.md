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
├── .vscode  # me: app launch configs
├── android  # Flutter
├── assets   # me: app icons and images
├── docs     # me
├── ios      # Flutter
├── lib      # Flutter
├── lttl.dev # me: app supporting web page 
└── test     # Flutter
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

- [ ] Getting started (Set up Wyatt) (default if there's no key)

- [ ] Home (default it there are no locations)
  - [ ] Intro text
    - [ ] Animate text (?)
    - [ ] Getting Started button at the bottom
  - [ ] Add help button right upper corner (?)
  - [x] Left drawer with
      - [Home](https://api.flutter.dev/flutter/material/Icons/home-constant.html)
      - [Locations](https://api.flutter.dev/flutter/material/Icons/location_on-constant.html) ([alternative icon](https://api.flutter.dev/flutter/material/Icons/pin_drop-constant.html))
      - [Settings](https://api.flutter.dev/flutter/material/Icons/settings-constant.html)
      - [About](https://api.flutter.dev/flutter/material/Icons/info-constant.html)

- [ ] Locations (default if there are locations)
  - [ ] Load locations into an overview grid ([exemplified fetch](https://docs.flutter.dev/cookbook/networking/fetch-data))
    - [ ] Pre-seed (?)
  - [ ] Sort locations overview by (due) date or by city name
  - [ ] Search locations (?)
  - [ ] Filter locations (?)

  - [ ] Manage locations (through dots menu)
    - [ ] [Add a location](https://api.flutter.dev/flutter/material/Icons/add-constant.html)
      - [ ] Evaluate and use a location picker:
            - [map_location_picker](https://pub.dev/packages/map_location_picker)
            - [Custom Map For Location Picker](https://community.flutterflow.io/c/community-custom-widgets/post/custom-map-for-location-picker-kPu8C7qdo1eSy0h)
            - [how to pick an address from map in flutter](https://stackoverflow.com/questions/69443353/how-to-pick-an-address-from-map-in-flutter)
    - [ ] [Edit a location](https://api.flutter.dev/flutter/material/Icons/edit-constant.html)
    - [ ] [Delete a location](https://api.flutter.dev/flutter/material/Icons/delete-constant.html)
    - [ ] [Turn off a location](https://api.flutter.dev/flutter/material/Icons/volume_off-constant.html) or [Suspend a location](https://api.flutter.dev/flutter/material/Icons/location_off-constant.html)
    - [ ] [Turn on a location](https://api.flutter.dev/flutter/material/Icons/volume_up-constant.html) or [Hibernate a location](https://api.flutter.dev/flutter/material/Icons/location_on-constant.html)

- [x] Settings
  - [x] Save key
  - [x] Choose Language (foreseen)
  - [x] Choose Metric/Imperial units (foreseen)
  - [x] Default notification distance (500m)
  - [x] Reset to factory settings

- [ ] Download my data (?)

- [ ] [_handleLocationPermission](https://github.com/m5lk3n/locato/blob/main/lib/location_page.dart#L44)

- [ ] Implement Haversine (`flutter pub add haversine_distance`)

- [ ] Implement notification

## Wireframe

[Mockup](docs/wireframe.pdf)

## To do

- [ ] Clarify minimal API key scope and document
- [ ] Clarify permissions
  - [ ] [android.permission.INTERNET / com.apple.security.network.client](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [ ] [Source](https://github.com/fernandoptrr/flutter-location-practice/tree/master):
  - [ ] Add `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>` to `AndroidManifest.xml` as well
  - [ ] Clarify: `Geolocator.getCurrentPosition` is only executed on physical devices that are online (!?)
- [ ] Add `intl`
  - [ ] Unify syntax ("Enter Distance in Meters" or "Enter distance in meters")
- [ ] Add tests
- [ ] Add delete key (and any other local data)
- [ ] Automate builds (`flutter build apk --obfuscate "--dart-define=KEY_URL=https://developers.google.com/maps/documentation/geocoding/get-api-key ...`)
- [ ] Generate `lttl.dev/wyatt/index.html`
- [ ] Godoc
- [ ] Clean up assets

## Doing

- [Onboarding with routes and riverpod](https://flutterexplained.com/p/flutter-onboarding-with-riverpod)?


## Open

- Suspend app, wake up?
- Recover from "panic"/exception (loss of connectivity in a tunnel?)
- Merge nearby locations?
- Support landscape mode?
- License?

## Backlog

- [ ] Sort locations overview by continent name
- [ ] [Share a location](https://api.flutter.dev/flutter/material/Icons/share_location-constant.html)
- [ ] OpenStreetMap version

## Docs

- [Styleguide](docs/STYLEGUIDE.md)
- [How-to](docs/HOWTO.md)
- [Bookmarks](docs/BOOKMARKS.md)
- [Ideas](docs/IDEAS.md) (partially outdated, archivable)
- [Appendix](docs/APPENDIX.md) (not app-specific)

## Acknowledgements

- Max Schwarzmüller for his incredible [Flutter & Dart - The Complete Guide [2024 Edition]](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
- Copilot for the Wyatt logo and the AppBar background
- Google for Maps and font(s)
- [Moqups](https://app.moqups.com) for the wireframe
- [zeshuaro](https://github.com/zeshuaro) for [Appainter](https://appainter.dev/)
