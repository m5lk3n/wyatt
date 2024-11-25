import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wyatt/widgets/location_helper.dart';
import 'package:wyatt/widgets/location_picker.dart';

// https://github.com/Lyokone/flutterlocation/blob/master/packages/location/example/lib/get_location.dart
class AddressLoader extends StatefulWidget {
  AddressLoader({
    super.key,
    this.locationData,
  });

  LocationData?
      locationData; // input location data // TODO/FIXME: restore on LocationPicker back

  @override
  State<AddressLoader> createState() => _AddressLoaderState();
}

class _AddressLoaderState extends State<AddressLoader> {
  final Location location = Location(); // location data retriever
  final _addressController = TextEditingController();
  LocationData? _currentLocationData; // TODO: check if needed
  String? _error;

  @override
  void initState() {
    super.initState();

    _updateAddress(locationData: widget.locationData);
  }

  @override
  void dispose() {
    _addressController.dispose();

    super.dispose();
  }

  Future<void> _updateAddress({LocationData? locationData}) async {
    setState(() {
      _error = null;
      _currentLocationData = null;
      _addressController.text = 'Loading...';
    });
    try {
      final locationResult = locationData ?? await location.getLocation();
      final locationAddress = await determineAddress(locationResult);
      setState(() {
        _currentLocationData = locationResult;
        _addressController.text = locationAddress;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _addressController.text = 'Error: $_error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log('location: ${_error ?? '${_currentLocationData ?? "unknown"}'}',
        name: 'AddressLoader');

    return TextField(
      onTap: () {
        pickLocation(context);
      },
      readOnly: true,
      maxLines: null, // enables multiline
      controller: _addressController,
      decoration: InputDecoration(
        label: const Text("Address"),
        suffixIcon: IconButton(
            icon: Icon(Icons.directions),
            onPressed: () {
              pickLocation(context);
            }),
      ),
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }

  Future<void> pickLocation(BuildContext context) async {
    if (_currentLocationData == null) {
      log('no location data', name: 'AddressLoader');
      return;
    }

    final LocationData? location = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LocationPicker(locationData: _currentLocationData!)),
    );
    log('location picked: $location', name: 'AddressLoader');
    if (location == null) {
      return;
    }
    widget.locationData = location;
    _updateAddress(locationData: location);
  }
}
