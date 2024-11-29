import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:wyatt/common.dart';
import 'package:wyatt/providers/settings_provider.dart';
import 'package:wyatt/widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:wyatt/widgets/location_helper.dart';

// https://www.youtube.com/watch?v=hCOU8Fe3Ezk
class LocationAutoCompleteScreen extends ConsumerStatefulWidget {
  const LocationAutoCompleteScreen({
    super.key,
    this.locationData,
  });

  final LocationData? locationData; // input location data // TODO: use

  @override
  ConsumerState<LocationAutoCompleteScreen> createState() =>
      _LocationAutoCompleteScreenState();
}

class _LocationAutoCompleteScreenState
    extends ConsumerState<LocationAutoCompleteScreen> {
  final Location location = Location(); // location data retriever

  final _searchController = TextEditingController();
  var uuid = const Uuid();
  List<dynamic> listOfLocations = [];
  late String _key;
  late String _sessionToken;
  bool _isLoading = false;
  static const _minSearchTextLength = 3;

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _readKey();
    _sessionToken = uuid.v4();

    _searchController.addListener(() {
      _onChange();
    });
  }

  _onChange() {
    log('search: ${_searchController.text}, isLoading: $_isLoading',
        name: 'LocationAutoComplete');
    if (_isLoading) {
      return;
    }
    _loadLocationPredictions(_searchController.text);
  }

  void _loadLocationPredictions(String input) async {
    if (input.trim().length < _minSearchTextLength) {
      listOfLocations.clear();
      return;
    }

    try {
      String request =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_key&sessiontoken=$_sessionToken';

      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log('data: $data', name: 'LocationAutoComplete');
        if (data['status'] == 'OK') {
          setState(() {
            listOfLocations = data['predictions'];
          });
        } else {
          log('Error: ${data['status']}', name: 'LocationAutoComplete');
        }
      }
    } catch (e) {
      log('Error: $e', name: 'LocationAutoComplete');
    }
  }

  // side effect: sets _key
  Future<void> _readKey() async {
    final settings = ref.read(settingsNotifierProvider.notifier);

    _key = await settings.getKey();
  }

  @override
  Widget build(BuildContext context) {
    log('location: ${widget.locationData}', name: 'LocationAutoComplete');

    return Scaffold(
        appBar: WyattAppBar(context, Screen.pickLocation),
        body: Padding(
          padding: Common.padding,
          child: Column(
            children: [
              TextField(
                enabled: !_isLoading,
                controller: _searchController,
                maxLines: null, // enables multiline
                decoration: InputDecoration(
                    hintText: "Search place...",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.my_location),
                        onPressed: () {
                          _useCurrentLocation();
                        })),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              Visibility(
                visible: _showPredictions(),
                child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listOfLocations.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // TODO
                          log('selected: ${listOfLocations[index]}',
                              name: 'LocationAutoComplete');
                          setState(() {
                            _searchController.text =
                                listOfLocations[index]["description"];
                            listOfLocations.clear();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            listOfLocations[index]["description"],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _searchController.text = 'Loading...';
    });
    try {
      final locationResult = await location.getLocation();
      final locationAddress = await determineAddress(locationResult);
      setState(() {
        _searchController.text = locationAddress;
        _isLoading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
        _searchController.text = 'Error: $err';
      });
    }
  }

  bool _showPredictions() {
    log('_isLoading: $_isLoading',
        name: 'LocationAutoComplete._showPredictions');

    if (_isLoading) {
      return false;
    }

    log('length: ${_searchController.text.trim().length}',
        name: 'LocationAutoComplete._showPredictions');

    if (_searchController.text.trim().length < _minSearchTextLength) {
      return false;
    }

    return listOfLocations.isNotEmpty;
  }
}
