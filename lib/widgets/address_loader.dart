import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wyatt/widgets/location_helper.dart';

// https://github.com/Lyokone/flutterlocation/blob/master/packages/location/example/lib/get_location.dart
class AddressLoader extends StatefulWidget {
  const AddressLoader({
    super.key,
    this.locationData,
  });

  final LocationData? locationData; // input location data

  @override
  State<AddressLoader> createState() => _AddressLoaderState();
}

class _AddressLoaderState extends State<AddressLoader> {
  final Location location = Location(); // location data retriever
  final _addressController = TextEditingController();
  LocationData? _currentLocationData;
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
    log('AddressLoader: location: ${_error ?? '${_currentLocationData ?? "unknown"}'}');

    return TextField(
      readOnly: true,
      maxLines: null, // enables multiline
      controller: _addressController,
      decoration: InputDecoration(
        label: const Text("Address"),
      ),
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }
}
