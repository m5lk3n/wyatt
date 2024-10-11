# wyatt

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

- Copilot prompt to create "A black and white logo showing a cowboy like an old wanted poster", download and save as 512x512 `assets/icon/icon.png`
- [A Step-by-Step Guide to Adding Launcher Icons to Your Flutter App](https://nikhilsomansahu.medium.com/a-step-by-step-guide-to-adding-launcher-icons-to-your-flutter-app-98b5d7e3bb04)

- [ ] Ask user to provide a key (the Google Maps API key) and store it securely on the client: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)

## To do

- [ ] Add intl
- [ ] Add tests
- [ ] Add delete key (and any other local data)
- [ ] Use pubspec's app name and version in about box and rest of app
- [ ] Automate builds (with `flutter build apk --obfuscate "--dart-define=KEY_URL=http://lttl.dev/wyatt...`)

## Open

- [ ] Support landscape mode?
- [ ] [ENVied](https://codewithandrea.com/articles/flutter-api-keys-dart-define-env-files/#enter-envied) up?
- [ ] License?
- [ ] Copyright background?

## [Bookmarks](BOOKMARKS.md)

## Acknowledgements

- Max Schwarzmüller for his incredible [Flutter & Dart - The Complete Guide [2024 Edition]](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
- Copilot for the Wyatt logo and the AppBar background