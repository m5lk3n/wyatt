import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wyatt/log.dart';
import 'package:wyatt/models/network.dart';

class KeyValidator {
  static Future<bool> validateKey(String key) async {
    log.debug('validating key');

    try {
      final response = await http.get(Uri.parse(
          // https://developers.google.com/maps/documentation/geocoding/start
          'https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=$key'));
      if (response.statusCode == 200) {
        GeocodeAddress geocodeAddress = GeocodeAddress.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        if (geocodeAddress.status == 'OK') {
          log.debug('key validation successful');

          return true;
        }
      } else {
        log.debug(
            'key validation failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log.error('key validation failed', error: e);
    }

    return false;
  }
}
