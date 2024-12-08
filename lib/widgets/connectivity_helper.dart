import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// inspired by https://stackoverflow.com/questions/49648022/check-whether-there-is-an-internet-connection-available-on-flutter-app
class ConnectivityHelper {
  Future<bool> check() async {
    return await InternetConnection().hasInternetAccess;
  }

  dynamic checkConnection(Function func) {
    check().then((connected) {
      func(connected);
    });
  }
}
