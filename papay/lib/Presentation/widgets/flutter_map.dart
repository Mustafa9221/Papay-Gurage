import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class WebLocationPicker extends StatefulWidget {
  const WebLocationPicker({super.key});

  @override
  State<WebLocationPicker> createState() => _WebLocationPickerState();
}

class _WebLocationPickerState extends State<WebLocationPicker> {
  LatLng? selectedLatLng;
  final MapController _mapController = MapController();
  LatLng currentLocation = LatLng(25.276987, 51.520008); // Doha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TypeAheadField<Map<String, dynamic>>(
              suggestionsCallback: (pattern) async {
                return await _getLocationSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion['display_name']),
                );
              },
              onSelected: (suggestion) {
                double lat = double.parse(suggestion['lat']);
                double lon = double.parse(suggestion['lon']);
                LatLng newLocation = LatLng(lat, lon);
                setState(() {
                  currentLocation = newLocation;
                  selectedLatLng = newLocation;
                  _mapController.move(newLocation, 14);
                });
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search location...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 13.0,
                onTap: (tapPosition, latLng) {
                  setState(() {
                    selectedLatLng = latLng;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                if (selectedLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: selectedLatLng!,
                        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedLatLng != null
            ? () {
                Navigator.pop(context, selectedLatLng);
              }
            : null,
        child: const Icon(Icons.check),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getLocationSuggestions(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5');
    final response = await http.get(url, headers: {'User-Agent': 'Flutter App'});
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      return [];
    }
  }
}
