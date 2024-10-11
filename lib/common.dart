abstract class Common {
  static late String appName;
  static late String appVersion;
  static late String packageName;
  static String keyKey = "$packageName.key";
  static const String keyUrl = String.fromEnvironment(
    'KEY_URL',
    defaultValue:
        'wyatt@lttl.dev', // supposed to be a real URL, see launch configuration
  );
}
