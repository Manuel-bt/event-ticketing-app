import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/event_model.dart';
import 'checkout_sheet.dart';

class VibeOverlay extends StatelessWidget {
  final NightlifeEvent event; // Added this line

  const VibeOverlay({super.key, required this.event}); // Updated constructor

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 15,
      right: 15,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title, // Dynamic Title
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF00FFA3),
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      event.venue,
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ), // Dynamic Venue
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CheckoutSheet(event: event),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFA3),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "GET TICKETS - TZS ${event.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ), // Dynamic Price
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
