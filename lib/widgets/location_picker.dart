import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

// https://github.com/Lyokone/flutterlocation/blob/master/packages/location/example/lib/get_location.dart
class GetLocationWidget extends StatefulWidget {
  const GetLocationWidget({super.key});

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocationWidget> {
  final Location location = Location();

  bool _loading = false;

  LocationData? _location;
  String? _error;
  String? _address;

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final locationResult = await location.getLocation();
      final locationAddress = await determineAddress();
      setState(() {
        _location = locationResult;
        _address = locationAddress;
        _loading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
        Center(
          child: Text(
            'Location: ${_error ?? '${_location ?? "unknown"}'}',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: Text(
            'Address: ${_error ?? _address ?? "unknown"}',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: _getLocation,
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Get'),
            ),
          ],
        ),
      ],
    );
  }

  Future<String> determineAddress() async {
    String address = 'unknown';
    if (_location == null) {
      return address;
    }

    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
      _location!.latitude!,
      _location!.longitude!,
    );

    if (placemarks.isNotEmpty) {
      geo.Placemark placemark = placemarks.first;

      address =
          '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    }

    return address;
  }
}
