# DEV

## Snippets

`startup_provider.dart:`

```
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/providers/settings_helper.dart';
import 'package:wyatt/services/secure_storage.dart';

final startupNotifierProvider =
    AutoDisposeNotifierProvider<StartupNotifier, bool>(() => StartupNotifier());

class StartupNotifier extends AutoDisposeNotifier<bool> {
  final _secureStorage = SecurePersistentLocalStorage();

  @override
  bool build() {
    _loadStartupStatus();
    return false;
  }

  Future<void> _loadStartupStatus() async {
    state = false;

    final keyValue = await _secureStorage.read(key: Common.keyKey);
    log('StartupNotifier: key = $keyValue');

    KeyValidator.validateKey(keyValue).then((isValid) {
      if (isValid) {
        state = true;
      }
    });

    log('StartupNotifier: state = $state');
  }
}
```

During start-up/splash, add this check ([source](https://medium.com/@piyushhh01/comprehensive-guide-to-error-handling-in-flutter-strategies-and-code-examples-2929071e5716)):

```
class MyHomePage extends StatelessWidget {
  Future<void> checkInternetConnection(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Display a "No Internet Connection" message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Perform the network request
      // ...
    }
  }
```

Location picker from [flutter_flow](https://community.flutterflow.io/c/community-custom-widgets/post/custom-map-for-location-picker-kPu8C7qdo1eSy0h):

```
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GoogleMaps;
import 'package:geocoding/geocoding.dart';

class CustomMapForLocationPicker extends StatefulWidget {
  const CustomMapForLocationPicker({
    super.key,
    this.width,
    this.height,
    required this.onTapMap,
  });

  final double? width;
  final double? height;
  final Future<dynamic> Function(String address, double lat, double long)
      onTapMap;

  @override
  State<CustomMapForLocationPicker> createState() =>
      _CustomMapForLocationPickerState();
}

class _CustomMapForLocationPickerState
    extends State<CustomMapForLocationPicker> {
  GoogleMaps.GoogleMapController? _controller;
  late GoogleMaps.LatLng _selectedLatLng;
  GoogleMaps.LatLng currentLatLng =
      GoogleMaps.LatLng(FFAppState().currentLat, FFAppState().currentLng);
  String _selectedAddress = '';
  Set<GoogleMaps.Marker> _markers = Set();

  @override
  void initState() {
    super.initState();
    getCurrentPosition().then((value) {
      if (mounted) {
        setState(() {
          currentLatLng = GoogleMaps.LatLng(
              FFAppState().currentLat, FFAppState().currentLng);
          _controller?.animateCamera(GoogleMaps.CameraUpdate.newCameraPosition(
              GoogleMaps.CameraPosition(
            target: currentLatLng,
            zoom: 12,
          )));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GoogleMaps.GoogleMap(
            initialCameraPosition: GoogleMaps.CameraPosition(
              target: currentLatLng,
              zoom: 12,
            ),
            onMapCreated: (GoogleMaps.GoogleMapController controller) {
              _controller = controller;
            },
            onTap: _addMarker,
            mapType: GoogleMaps.MapType.normal,
            markers: _markers,
            myLocationButtonEnabled: false,
          ),
        ),
      ],
    );
  }

  void _addMarker(GoogleMaps.LatLng latLng) async {
    setState(() {
      _selectedLatLng = latLng;
      _markers.clear();
      _markers.add(
        GoogleMaps.Marker(
          markerId: GoogleMaps.MarkerId('TappedLocation'),
          position: latLng,
          infoWindow: GoogleMaps.InfoWindow(
            title: _selectedAddress,
            snippet: '${latLng.latitude}, ${latLng.longitude}',
          ),
        ),
      );
      log("LocationPicker: $_selectedAddress");
      widget.onTapMap(_selectedAddress, _selectedLatLng.latitude,
          _selectedLatLng.longitude);
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      setState(() {
        _selectedAddress =
            '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
      });
    }

    _controller?.animateCamera(GoogleMaps.CameraUpdate.newLatLng(latLng));
  }
}
```