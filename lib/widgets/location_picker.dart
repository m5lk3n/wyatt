import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_map_dynamic_key/google_map_dynamic_key.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/providers/settings_provider.dart';
import 'package:wyatt/widgets/appbar.dart';

class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker({
    super.key,
    required this.locationData,
  });

  final LocationData
      locationData; // input location data // TODO/WIP: use this to set the initial location

  @override
  ConsumerState<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  final _googleMapDynamicKeyPlugin = GoogleMapDynamicKey();
  late GoogleMapController _controller; // TODO: use takeSnapshot()
  late String _key;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _pickLocation(LatLng position) {
    // return value
    LocationData pickedLocation = LocationData.fromMap({
      "latitude": position.latitude,
      "longitude": position.longitude,
    });
    log("picked location: $pickedLocation", name: "LocationPicker");
    Navigator.of(context).pop(pickedLocation);
  }

  @override
  void initState() {
    super.initState();

    initGoogleMapKey();
  }

  // initializes _key as a side effect
  Future<void> initGoogleMapKey() async {
    final settings = ref.read(settingsNotifierProvider.notifier);

    _key = await settings.getKey();
    log('key = $_key',
        name:
            'LocationPicker'); // if key is empty, the app will crash with FATAL EXCEPTION: androidmapsapi-ula-1
    // TODO: complain if key is invalid

    await _googleMapDynamicKeyPlugin.setGoogleApiKey(_key).then((value) {
      log("GoogleMap key set dynamically", name: "LocationPicker");
    });
  }

  @override
  Widget build(BuildContext context) {
    log("build", name: "LocationPicker");
    final latLngLocation =
        LatLng(widget.locationData.latitude!, widget.locationData.longitude!);

    return Scaffold(
      appBar: WyattAppBar(context, Screen.pickLocation),
      body: GoogleMap(
        mapToolbarEnabled: false,
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          //target: LatLng(userLocation.latitude!, userLocation.longitude!),
          target: latLngLocation,
          zoom: 12,
        ),
        markers: {
          Marker(
            position: latLngLocation,
            markerId: MarkerId(
                'TODO'), // TODO/FIXME: use a unique ID? or a random one? or the reminder text?
            infoWindow: InfoWindow(
              title: "Reminder location",
              snippet: "Buy coffee", // TODO/FIXME: use the reminder text
            ), // InfoWindo
          )
        },
        onTap: _pickLocation,
      ),
    );
  }
}
