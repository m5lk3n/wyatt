// Environment variables and shared app constants.
abstract class Constants {
  static const String keyUrl = String.fromEnvironment(
    'KEY_URL',
    defaultValue:
        'wyatt@lttl.dev', // supposed to be a real URL, see launch configuration
  );
}
