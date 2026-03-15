import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("My Tickets", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('tickets')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFF00FFA3)));
          
          final tickets = snapshot.data!.docs;

          if (tickets.isEmpty) {
            return const Center(
              child: Text("No tickets yet. Go find a vibe!", style: TextStyle(color: Colors.white24)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index].data() as Map<String, dynamic>;
              return _buildTicketCard(context, ticket, tickets[index].id);
            },
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Map<String, dynamic> ticket, String ticketId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00FFA3).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // QR CODE
          QrImageView(
            data: ticketId, // The ID the bouncer scans
            version: QrVersions.auto,
            size: 80.0,
            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF00FFA3)),
            dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.white),
          ),
          const SizedBox(width: 20),
          // TICKET INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket['eventTitle']?.toUpperCase() ?? 'EVENT',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(ticket['venue'] ?? 'Venue', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 10),
                const Text("VALID TICKET", style: TextStyle(color: Color(0xFF00FFA3), fontWeight: FontWeight.bold, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}