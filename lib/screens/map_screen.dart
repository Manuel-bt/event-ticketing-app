import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/venue_model.dart';
import '../widgets/map_pin.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          List<Marker> mapMarkers = [];

          if (snapshot.hasData) {
            mapMarkers = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              // Firestore GeoPoint to LatLng conversion
              GeoPoint pos =
                  data['location'] ?? const GeoPoint(-6.7924, 39.2083);

              return Marker(
                point: LatLng(pos.latitude, pos.longitude),
                width: 100,
                height: 100,
                child: MapPin(
                  venueName: data['venue'] ?? '',
                  color: _getVibeColor(data['vibeLevel'] ?? 0),
                  // Add this line to fix the error:
                  category: _parseCategory(data['category'] ?? 'club'),
                ),
              );
            }).toList();
          }

          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-6.7538, 39.2743), // Dar es Salaam center
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
              ),
              MarkerLayer(markers: mapMarkers),
            ],
          );
        },
      ),
    );
  }

  // Helper to change pin color based on crowd density
  Color _getVibeColor(int level) {
    if (level > 80) return const Color(0xFFFF0055); // Hot (Red)
    if (level > 50) return const Color(0xFF00FFA3); // Chilled (Neon Green)
    return Colors.blueAccent; // Quiet
  }
}

VenueCategory _parseCategory(String cat) {
  switch (cat.toLowerCase()) {
    case 'bar': return VenueCategory.bar;
    case 'lounge': return VenueCategory.lounge;
    case 'club': 
    default: return VenueCategory.club;
  }
}
