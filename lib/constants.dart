// Environment variables and shared app constants.
abstract class Constants {
  static const String appName = 'Wyatt'; // TODO: get from pubspec.yaml
  static const String appVersion = '0.0.1'; // TODO: get from pubspec.yaml
  static const String keyUrl = String.fromEnvironment(
    'KEY_URL',
    defaultValue:
        'wyatt@lttl.dev', // supposed to be a real URL, see launch configuration
  );
  static const String keyKey = "wyatt_${appVersion}_key";
}
