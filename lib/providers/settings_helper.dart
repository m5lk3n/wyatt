import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:wyatt/models/network.dart';

class KeyValidator {
  static Future<bool> validateKey(String key) async {
    log('validating key', name: 'KeyValidator');

    try {
      final response = await http.get(Uri.parse(
          // https://developers.google.com/maps/documentation/geocoding/start
          'https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=$key'));
      if (response.statusCode == 200) {
        GeocodeAddress geocodeAddress = GeocodeAddress.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        if (geocodeAddress.status == 'OK') {
          log('key validation successful', name: 'KeyValidator');

          return true;
        }
      } else {
        log('key validation failed with status code: ${response.statusCode}',
            name: 'KeyValidator');
      }
    } catch (e) {
      log('key validation failed with: $e', name: 'KeyValidator');
    }

    return false;
  }
}
