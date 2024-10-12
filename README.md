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

- [ ] Manage locations
  - [ ] Add a location
  - [ ] Delete a location
  - [ ] Load locations into an overview grid ([exemplified fetch](https://docs.flutter.dev/cookbook/networking/fetch-data))
  - [ ] Sort locations overview by (due) date

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

## [Bookmarks](BOOKMARKS.md)

## Acknowledgements

- Max Schwarzmüller for his incredible [Flutter & Dart - The Complete Guide [2024 Edition]](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
- Copilot for the Wyatt logo and the AppBar background
- Google for Maps and font
