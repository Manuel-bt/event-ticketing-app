import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String venue;
  final String price;
  final int vibeLevel;
  final String? imageUrl;

  const EventCard({
    super.key,
    required this.title,
    required this.venue,
    required this.price,
    required this.vibeLevel,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background - For now, a dark gradient (later, your TikTok-style video)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black87],
            ),
          ),
        ),
        // Event Details Overlay
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FFA3),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "VIBE: $vibeLevel%",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(venue, style: const TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 15),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFA3),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("GET TICKETS - $price TZS"),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.share, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}