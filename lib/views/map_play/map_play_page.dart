import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ktr/models/user_model_one.dart';
import 'package:latlong2/latlong.dart';

class MapPlayPage extends StatefulWidget {
  final PlaceLocationOne location;
  final bool isBeingSelected;
  const MapPlayPage(
      {super.key,
      this.isBeingSelected = true,
      this.location = const PlaceLocationOne(
        latitude: 11.29,
        longitude: 77.55,
        address: '',
      )});

  @override
  State<MapPlayPage> createState() => _MapPlayPageState();
}

class _MapPlayPageState extends State<MapPlayPage> {
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users Map"),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialZoom: 10,
          onPositionChanged: (position, hasGesture) {
            mapController.move;
          },
          initialCenter:
              LatLng(widget.location.latitude, widget.location.longitude),
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
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: [
            Marker(
                point:
                    LatLng(widget.location.latitude, widget.location.longitude),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                )),
            Marker(
                point: LatLng(11, widget.location.longitude),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                )),
          ]),
        ],
      ),
    );
  }
}


// FlutterMap(
//         mapController: mapController,
//         options: MapOptions(
//           onPositionChanged: (position, hasGesture) {
//             mapController.move;
//           },
//           initialCenter:
//               LatLng(widget.location.latitude, widget.location.longitude),
//         ),
//         children: [
//           const CircleLayer(
//             circles: [
//               CircleMarker(
//                   point: LatLng(10.00, 77.128928),
//                   radius: 1000,
//                   useRadiusInMeter: true),
//             ],
//           ),
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             additionalOptions: const {'h1': 'en'},
//             subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
//             userAgentPackageName: 'com.example.app',
//           ),
//           MarkerLayer(markers: [
//             Marker(
//                 point:
//                     LatLng(widget.location.latitude, widget.location.longitude),
//                 child: const Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                 )),
//           ]),
//         ],
//       ),