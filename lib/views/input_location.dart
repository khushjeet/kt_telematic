import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:ktr/views/widget/map_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../models/user_model_one.dart';

// ignore: must_be_immutable
class InputLocation extends StatefulWidget {
  InputLocation({super.key, required this.onLocationPicked});

  void Function(PlaceLocationOne pickedLocation) onLocationPicked;

  @override
  State<InputLocation> createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  PlaceLocationOne? _pickedLocation;
  bool _isGettingLocation = false;

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      setState(() {
        _isGettingLocation = true;
      });
      return;
    }
    setState(() {
      _isGettingLocation = true;
    });
    _savePlace(latitude, longitude);
  }

  Future<List<geo.Placemark>> _gettingLocationAddress(
      double lat, double lon) async {
    List<geo.Placemark> placeMark =
        await geo.placemarkFromCoordinates(lat, lon);
    return placeMark;
  }

  void _savePlace(double lat, double lon) async {
    final addressData = await _gettingLocationAddress(lat, lon);
    if (addressData.isEmpty) {
      return;
    }
    // final String? street = addressData[0].street;
    final String? postalCode = addressData[0].postalCode;
    final String? locality = addressData[0].locality;
    //  final String? country = addressData[0].country;
    final String? administrativeArea = addressData[0].administrativeArea;
    //final String? name = addressData[0].name;

    final String address = '$postalCode ,$locality  ,$administrativeArea ';

    setState(() {
      _pickedLocation =
          PlaceLocationOne(latitude: lat, longitude: lon, address: address);
      _isGettingLocation = false;
    });
    widget.onLocationPicked(_pickedLocation!);
  }

  Future<void> _selectOnMap() async {
    final position = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(builder: ((context) => const MapScreen())));
    _savePlace(position!.latitude, position.longitude);
  }

  final MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Location Select Yet..."),
    );
    if (_isGettingLocation) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_pickedLocation != null) {
      content = FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onPositionChanged: (position, hasGesture) {
            mapController.move;
          },
          // initialCenter:
          //     LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
        ),
        children: [
          const CircleLayer(
            circles: [
              CircleMarker(
                  point: LatLng(10.00, 77.128928),
                  radius: 1000,
                  useRadiusInMeter: true),
            ],
          ),
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            additionalOptions: const {'h1': 'en'},
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
          ),
          MarkerLayer(markers: [
            Marker(
                point: LatLng(
                    _pickedLocation!.latitude, _pickedLocation!.longitude),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ))
          ])
        ],
      );
    }
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
          ),
          child: content,
        ),
        Row(
          children: [
            TextButton.icon(
                onPressed: () {
                  _getCurrentLocation();
                },
                icon: const Icon(Icons.location_on),
                label: const Text(
                  "Get Current Location",
                  style: TextStyle(fontSize: 13),
                )),
            TextButton.icon(
                onPressed: () {
                  _selectOnMap();
                },
                icon: const Icon(Icons.map),
                label: const Text(
                  "Select on Map",
                  style: TextStyle(fontSize: 13),
                )),
          ],
        ),
      ],
    );
  }
}
