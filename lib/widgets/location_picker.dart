import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wyatt/widgets/location_helper.dart';

// https://github.com/Lyokone/flutterlocation/blob/master/packages/location/example/lib/get_location.dart
class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
    this.locationData,
  });

  final LocationData? locationData;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final Location location = Location();

  bool _loading = false;

  LocationData? _locationData;
  String? _error;
  String? _address;

  @override
  void initState() {
    super.initState();

    _updateLocation(locationData: widget.locationData);
  }

  Future<void> _updateLocation({LocationData? locationData}) async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final locationResult = locationData ?? await location.getLocation();
      final locationAddress = await determineAddress(locationResult);
      setState(() {
        _locationData = locationResult;
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
            'Location: ${_error ?? '${_locationData ?? "unknown"}'}',
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
              onPressed: _updateLocation,
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Update'),
            ),
          ],
        ),
      ],
    );
  }
}
