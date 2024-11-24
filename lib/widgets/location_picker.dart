import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_map_dynamic_key/google_map_dynamic_key.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wyatt/providers/settings_provider.dart';

class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker({super.key});

  @override
  ConsumerState<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  final _googleMapDynamicKeyPlugin = GoogleMapDynamicKey();
  late GoogleMapController _controller;
  late LatLng _pickedLocation;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _pickLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
      log("picked location: $_pickedLocation", name: "LocationPicker");
      Navigator.of(context).pop(
          _pickedLocation); // TODO/WIP: pass picked location back to caller
    });
  }

  @override
  void initState() {
    super.initState();

    initGoogleMapKey();
  }

  Future<void> initGoogleMapKey() async {
    final settings = ref.read(settingsNotifierProvider.notifier);

    String key = await settings.getKey();
    log('key = $key',
        name:
            'LocationPicker'); // if key is empty, the app will crash with a fatal error
    // TODO: complain if key is invalid

    await _googleMapDynamicKeyPlugin.setGoogleApiKey(key).then((value) {
      log("GoogleMap key set dynamically", name: "LocationPicker");
    });
  }

  @override
  Widget build(BuildContext context) {
    log("build", name: "LocationPicker");
    return FutureBuilder(
      future: Location().getLocation(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final userLocation = snapshot.data as LocationData;
        return GoogleMap(
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(userLocation.latitude!, userLocation.longitude!),
            zoom: 12,
            // TODO: drop a pin on the user's location
          ),
          onTap: _pickLocation,
        );
      },
    );
  }
}
