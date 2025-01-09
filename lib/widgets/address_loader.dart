import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wyatt/log.dart';
import 'package:wyatt/widgets/location_helper.dart';
import 'package:wyatt/widgets/location_picker.dart';

typedef LocationDataCallback = void Function(LocationData locationData);

// https://github.com/Lyokone/flutterlocation/blob/master/packages/location/example/lib/get_location.dart
class AddressLoader extends StatefulWidget {
  const AddressLoader({
    super.key,
    this.locationData,
    required this.onLocationDataChange,
  });

  final LocationData?
      locationData; // initial location data // TODO/FIXME: restore on LocationPicker back
  final LocationDataCallback onLocationDataChange;

  @override
  State<AddressLoader> createState() => _AddressLoaderState();
}

class _AddressLoaderState extends State<AddressLoader> {
  final Location location =
      Location(); // location data retriever // TODO: shows several deprecated warnings when compiled. usage? update?
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

  @override
  void setState(fn) {
    // attempt to avoid "setState() called after dispose()" exception
    if (mounted) {
      super.setState(fn);
    }
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
        widget.onLocationDataChange(locationResult);
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _addressController.text =
            'Error loading location. You may be offline. Please try again later.';
        log.error('error loading location',
            error: _error, name: '$runtimeType');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log.debug('location: ${_error ?? '${_currentLocationData ?? "unknown"}'}',
        name: '$runtimeType');

    return TextField(
      onTap: () {
        pickLocation(context);
      },
      readOnly: true,
      maxLines: null, // enables multiline
      controller: _addressController,
      decoration: InputDecoration(
        label: const Text("Location *"),
        prefixIcon: IconButton(
            icon: Icon(Icons.edit_location_alt),
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
      log.debug('no location data', name: '$runtimeType');
      return;
    }

    final LocationData? location = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LocationPicker(locationData: _currentLocationData!)),
    );
    log.debug('location picked: $location', name: '$runtimeType');
    if (location == null) {
      return;
    }
    _updateAddress(locationData: location);
  }
}
