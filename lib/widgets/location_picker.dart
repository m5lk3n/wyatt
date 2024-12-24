import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_map_dynamic_key/google_map_dynamic_key.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/log.dart';
import 'package:wyatt/providers/settings_provider.dart';
import 'package:wyatt/widgets/appbar.dart';

class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker({
    super.key,
    required this.locationData,
  });

  final LocationData locationData; // initial location data

  @override
  ConsumerState<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  final _googleMapDynamicKeyPlugin = GoogleMapDynamicKey();
  late GoogleMapController _controller; // TODO: use takeSnapshot()
  late String _key;
  bool _isLoading = false;

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
    log.debug('picked location: $pickedLocation', name: '$runtimeType');
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

    /* don't omit setState() and _isLoading here, otherwise the GoogleMap widget
       will not be updated with the key, and tries to read the (dummy) key from 
       the manifest instead (results in a blank Google Maps screen and an error
      message in the console): */
    setState(() {
      _isLoading = true;
    });

    _key = await settings.getKey();
    log.debug('key from settings: $_key',
        name:
            '$runtimeType'); // if key is empty, the app will crash with FATAL EXCEPTION: androidmapsapi-ula-1
    // TODO: complain if key is invalid (set global error via notifier and route to setup page)

    await _googleMapDynamicKeyPlugin.setGoogleApiKey(_key).then((value) {
      log.debug('GoogleMap key set dynamically', name: '$runtimeType');
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final latLngLocation =
        LatLng(widget.locationData.latitude!, widget.locationData.longitude!);

    return Scaffold(
      appBar: WyattAppBar(context: context, title: Screen.pickLocation),
      body: _isLoading
          ? Center(child: const CircularProgressIndicator.adaptive())
          : GoogleMap(
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: latLngLocation,
                zoom: 12,
              ),
              markers: {
                Marker(
                  position: latLngLocation,
                  markerId: MarkerId(''), // there's only one, not ID needed
                  infoWindow: InfoWindow(
                    title: 'Reminder location',
                    snippet: 'Pick this as your reminder location',
                  ), // InfoWindo
                )
              },
              onTap: _pickLocation,
            ),
    );
  }
}
