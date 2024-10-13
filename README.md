# Wyatt

When
You
Are
There
Then ...

A location-based To-Do app for iOS and Android.

:construction_worker:

## Tips

- If you plan to be notified for a bigger place, like a mall, give it a good radius. Not a good example is a distance of 100m from the center of the mall as this probably doesn't trigger a notification around the mall.

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

- [ ] Splashcreen / Loading

- [ ] Getting started (Set up Wyatt) (default if there's no key)

- [ ] Home (default it there are no locations)
  - [ ] Intro text
    - [ ] Animate text (?)
    - [ ] Getting Started button at the bottom
  - [ ] Add location button right upper corner
  - [ ] Left drawer with
      - [Home](https://api.flutter.dev/flutter/material/Icons/home-constant.html)
      - [Locations](https://api.flutter.dev/flutter/material/Icons/location_on-constant.html) ([alternative icon](https://api.flutter.dev/flutter/material/Icons/pin_drop-constant.html))
      - [Settings](https://api.flutter.dev/flutter/material/Icons/settings-constant.html)
      - [About](https://api.flutter.dev/flutter/material/Icons/info-constant.html)

- [ ] Locations (default if there are locations)
  - [ ] Load locations into an overview grid ([exemplified fetch](https://docs.flutter.dev/cookbook/networking/fetch-data))
    - [ ] Pre-seed (?)
  - [ ] Sort locations overview by (due) date or by city name
  - [ ] Filter locations (?)

  - [ ] Manage locations (through dots menu)
    - [ ] [Add a location](https://api.flutter.dev/flutter/material/Icons/add-constant.html)
    - [ ] [Edit a location](https://api.flutter.dev/flutter/material/Icons/edit-constant.html)
    - [ ] [Delete a location](https://api.flutter.dev/flutter/material/Icons/delete-constant.html)
    - [ ] [Turn off a location](https://api.flutter.dev/flutter/material/Icons/volume_off-constant.html) or [Suspend a location](https://api.flutter.dev/flutter/material/Icons/location_off-constant.html)
    - [ ] [Turn on a location](https://api.flutter.dev/flutter/material/Icons/volume_up-constant.html) or [Hibernate a location](https://api.flutter.dev/flutter/material/Icons/location_on-constant.html)

- [ ] Settings
  - [ ] Save a key
  - [ ] Reset to factory settings

- [ ] [_handleLocationPermission](https://github.com/m5lk3n/locato/blob/main/lib/location_page.dart#L44)

- [ ] Implement Haversine (`flutter pub add haversine_distance`)

- [ ] Implement notification

## To do

- [ ] Clarify minimal API key scope and document
- [ ] Clarify permissions
  - [ ] [android.permission.INTERNET / com.apple.security.network.client](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [ ] [Source](https://github.com/fernandoptrr/flutter-location-practice/tree/master):
  - [ ] Add `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>` to `AndroidManifest.xml` as well
  - [ ] Clarify: `Geolocator.getCurrentPosition` is only executed on physical devices that are online (!?)
- [ ] Add `intl`
- [ ] Add tests
- [ ] Add delete key (and any other local data)
- [ ] Automate builds (`flutter build apk --obfuscate "--dart-define=KEY_URL=https://developers.google.com/maps/documentation/geocoding/get-api-key ...`)
- [ ] Generate `lttl.dev/wyatt/index.html`
- [ ] Clean up assets

## Open

- Suspend app, wake up?
- Recover from "panic"/exception (loss of connectivity in a tunnel?)
- Merge nearby locations?
- Support landscape mode?
- License?

## Backlog

- [ ] Sort locations overview by continent name
- [ ] [Share a location](https://api.flutter.dev/flutter/material/Icons/share_location-constant.html)

## [Bookmarks](BOOKMARKS.md)

## Acknowledgements

- Max Schwarzmüller for his incredible [Flutter & Dart - The Complete Guide [2024 Edition]](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
- Copilot for the Wyatt logo and the AppBar background
- Google for Maps and font