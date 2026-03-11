import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("My Account", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // FIXED LOGOUT: Now outside the StreamBuilder
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF00FFA3)),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading profile",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00FFA3)),
            );
          }

          // If document doesn't exist yet in Firestore
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "No profile found.\nTry signing up with a new account!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF00FFA3),
                  child: Icon(Icons.person, size: 50, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Text(
                  userData['name'] ?? "Viber",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['email'] ?? "",
                  style: const TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 40),
                _buildVibeProgress(userData['vibePoints'] ?? 0),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(
                      "Events",
                      userData['totalEvents']?.toString() ?? "0",
                    ),
                    _buildStat("Level", "VIP 1"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVibeProgress(int points) {
    double progress = (points / 500).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "VIBE POINTS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$points / 500",
              style: const TextStyle(color: Color(0xFF00FFA3)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white12,
          color: const Color(0xFF00FFA3),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
