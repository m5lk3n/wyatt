import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:wyatt/models/network.dart';

class KeyValidator {
  static Future<bool> validateKey(String key) async {
    log('KeyValidator: Validating key');

    final response = await http.get(Uri.parse(
        // https://developers.google.com/maps/documentation/geocoding/start
        'https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=$key'));
    if (response.statusCode == 200) {
      try {
        GeocodeAddress geocodeAddress = GeocodeAddress.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        if (geocodeAddress.status == 'OK') {
          log('KeyValidator: Key validation successful');

          return true;
        }
      } catch (e) {
        log('KeyValidator: Key validation failed with: $e');
      }
    } else {
      log('KeyValidator: Key validation failed with status code: ${response.statusCode}');
    }

    return false;
  }
}
