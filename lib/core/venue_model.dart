import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart'; // Add this import

enum VenueCategory { club, seminar, sports, bar, lounge }

class Venue {
  final String name;
  final LatLng location;
  final Color statusColor;
  final VenueCategory category; // Added Category

  Venue({
    required this.name,
    required this.location,
    required this.statusColor,
    required this.category,
  });
}

// Real coordinates for Masaki/Dar areas
List<Venue> sampleVenues = [
  Venue(
    name: "Elements",
    location: const LatLng(-6.7538, 39.2743),
    statusColor: const Color(0xFFFF007A),
    category: VenueCategory.club,
  ),
  Venue(
    name: "Warehouse",
    location: const LatLng(-6.7820, 39.2620),
    statusColor: const Color(0xFF00FFA3),
    category: VenueCategory.club,
  ),
  Venue(
    name: "Mlimani City Hall",
    location: const LatLng(-6.7700, 39.2200),
    statusColor: const Color(0xFF00FFA3), // Chill
    category: VenueCategory.seminar,
  ),
];
