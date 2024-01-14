import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ktr/models/user_model_one.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocationOne location;
  final bool isBeingSelected;
  const MapScreen(
      {super.key,
      this.isBeingSelected = true,
      this.location = const PlaceLocationOne(
        latitude: 11.29,
        longitude: 77.55,
        address: '',
      )});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _onClicked(TapPosition position, LatLng coordinates) {
    setState(() {
      _pickedLocation = coordinates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isBeingSelected ? "Pick Your Location" : "Your Location"),
        actions: [
          if (widget.isBeingSelected)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(_pickedLocation);
                },
                icon: const Icon(Icons.save))
        ],
      ),
      body: FlutterMap(
        options: MapOptions(onTap: _onClicked),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            additionalOptions: const {'h1': 'en'},
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
          ),
          if (widget.isBeingSelected)
            MarkerLayer(markers: [
              Marker(
                  point: _pickedLocation ??
                      LatLng(
                          widget.location.latitude, widget.location.longitude),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ))
            ])
        ],
      ),
    );
  }
}
