// Shared app attributes
abstract class Common {
  static late String appName;
  static late String appVersion;
  static String keyKey = "${appName}_${appVersion}_key";
  static const String keyUrl = String.fromEnvironment(
    'KEY_URL',
    defaultValue:
        'wyatt@lttl.dev', // supposed to be a real URL, see launch configuration
  );
}
