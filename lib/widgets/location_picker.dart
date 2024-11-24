import 'dart:developer';

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

  final LocationData? locationData; // input location data

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final Location location = Location(); // location data retriever
  final _addressController = TextEditingController();
  bool _isLoading = false;
  LocationData? _currentLocationData;
  String? _error;

  @override
  void initState() {
    super.initState();

    _updateLocation(locationData: widget.locationData);
  }

  @override
  void dispose() {
    _addressController.dispose();

    super.dispose();
  }

  Future<void> _updateLocation({LocationData? locationData}) async {
    setState(() {
      _error = null;
      _isLoading = true;
    });
    try {
      final locationResult = locationData ?? await location.getLocation();
      final locationAddress = await determineAddress(locationResult);
      setState(() {
        _currentLocationData = locationResult;
        _addressController.text = locationAddress;
        _isLoading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log('LocationPicker: location: ${_error ?? '${_currentLocationData ?? "unknown"}'}');

    String hintText = _isLoading ? 'Loading...' : 'Unknown';
    if (_error != null) {
      hintText = 'Error: $_error';
    }

    return TextField(
      readOnly: true,
      maxLines: null, // enables multiline
      controller: _addressController,
      decoration: InputDecoration(
        label: const Text("Address"),
        hintText: hintText,
      ),
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }
}
