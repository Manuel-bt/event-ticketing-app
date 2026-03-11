import 'package:flutter/material.dart';
import '../core/venue_model.dart'; // Ensure this matches your folder structure

class MapPin extends StatefulWidget {
  final String venueName;
  final Color color;
  final VenueCategory category; // New: Added category support

  const MapPin({
    super.key, 
    required this.venueName, 
    required this.color,
    required this.category,
  });

  @override
  State<MapPin> createState() => _MapPinState();
}

class _MapPinState extends State<MapPin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Logic to pick the right icon based on the venue type
  IconData _getCategoryIcon() {
    switch (widget.category) {
      case VenueCategory.club:
        return Icons.music_note;
      case VenueCategory.seminar:
        return Icons.school; // Or Icons.mic
      case VenueCategory.sports:
        return Icons.sports_soccer;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // The Pulsing Outer Ring
            ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.8).animate(_controller),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // The Solid Center Circle with Icon
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.6),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Icon(
                _getCategoryIcon(),
                color: Colors.black, // Dark icon on neon background for contrast
                size: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // The Venue Name Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A).withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(
            widget.venueName,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 10, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}