# Wyatt

When
You
Are
There
Then ...

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

- [ ] Implement Haversine

- [ ] Implement notification

## To do

- [ ] Clarify permissions
  - [ ] [android.permission.INTERNET / com.apple.security.network.client](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [ ] Add `intl`
- [ ] Add tests
- [ ] Add delete key (and any other local data)
- [ ] Automate builds (`flutter build apk --obfuscate "--dart-define=KEY_URL=https://developers.google.com/maps/documentation/geocoding/get-api-key ...`)
- [ ] Generate `lttl.dev/wyatt/index.html`
- [ ] Clean up assets

## Open

- Merge nearby locations?
- Support landscape mode?
- License?

## [Bookmarks](BOOKMARKS.md)

## Acknowledgements

- Max Schwarzmüller for his incredible [Flutter & Dart - The Complete Guide [2024 Edition]](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
- Copilot for the Wyatt logo and the AppBar background
- Google for Maps and font
