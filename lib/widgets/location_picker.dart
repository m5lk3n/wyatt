import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _controller;
  late LatLng _pickedLocation;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _pickLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
      log("picked location: $_pickedLocation", name: "LocationPicker");
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
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(userLocation.latitude!, userLocation.longitude!),
            zoom: 12,
          ),
          onTap: _pickLocation,
        );
      },
    );
  }
}
