import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/event_card.dart'; // Your existing UI widget

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        // Listen to the 'events' collection you just created
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error loading vibes"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF00FFA3)));
          }

          final docs = snapshot.data!.docs;

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              
              // Map the Firestore data to your UI
              return EventCard(
                title: data['title'] ?? 'Unknown Event',
                venue: data['venue'] ?? 'TBA',
                price: data['price']?.toString() ?? 'Free',
                vibeLevel: data['vibeLevel'] ?? 0,
                imageUrl: data['imageUrl'], // Optional: Add image links in Firebase
              );
            },
          );
        },
      ),
    );
  }
}