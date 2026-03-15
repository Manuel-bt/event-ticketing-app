import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_methods_screen.dart'; // Make sure this import matches your file name

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("My Account", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF00FFA3)));
          }

          final userData = userSnapshot.data?.data() as Map<String, dynamic>? ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // --- PROFILE HEADER ---
                CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0xFF00FFA3),
                  backgroundImage: userData['profilePicUrl'] != null 
                      ? NetworkImage(userData['profilePicUrl']) 
                      : null,
                  child: userData['profilePicUrl'] == null 
                      ? const Icon(Icons.person, size: 50, color: Colors.black) 
                      : null,
                ),
                const SizedBox(height: 15),
                Text(
                  userData['name'] ?? "Viber",
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  userData['primaryPhone'] ?? "+255 XXX XXX XXX",
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),

                const SizedBox(height: 40),

                // --- VIBE POINTS SECTION ---
                _buildVibeSection(userData['vibePoints'] ?? 0),

                const SizedBox(height: 30),

                // --- STATS ROW ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(userData['totalEvents']?.toString() ?? "0", "Events"),
                    _buildStatItem("0", "Active Tickets"), // This can be calculated from tickets sub-collection later
                    _buildStatItem(userData['vibePoints'] != null && userData['vibePoints'] > 500 ? "VIP" : "Basic", "Level"),
                  ],
                ),

                const SizedBox(height: 40),

                // --- RECENT PURCHASES (REAL BACKEND FETCH) ---
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "RECENT PURCHASES",
                    style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
                const SizedBox(height: 15),
                
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('tickets')
                      .orderBy('purchaseDate', descending: true)
                      .limit(3)
                      .snapshots(),
                  builder: (context, ticketSnapshot) {
                    if (!ticketSnapshot.hasData || ticketSnapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text("No purchases found", style: TextStyle(color: Colors.white24)),
                      );
                    }

                    return Column(
                      children: ticketSnapshot.data!.docs.map((doc) {
                        final ticket = doc.data() as Map<String, dynamic>;
                        return _buildPurchaseCard(
                          ticket['eventTitle'] ?? 'Event', 
                          "Recently", 
                          "${ticket['price']} TZS"
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // --- SETTINGS SECTION ---
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "SETTINGS",
                    style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.account_balance_wallet_outlined,
                        title: "Payment Methods",
                        subtitle: userData['provider'] ?? "Link M-Pesa / Tigo Pesa",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                          );
                        },
                      ),
                      const Divider(color: Colors.white10, height: 1, indent: 50),
                      _buildSettingsTile(
                        icon: Icons.notifications_none_outlined,
                        title: "Notifications",
                        onTap: () {},
                      ),
                      const Divider(color: Colors.white10, height: 1, indent: 50),
                      _buildSettingsTile(
                        icon: Icons.help_outline_rounded,
                        title: "Help & Support",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // --- LOGOUT BUTTON ---
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text("LOG OUT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.white.withOpacity(0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildVibeSection(int points) {
    double progress = (points / 500).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("VIBE POINTS", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            Text("$points / 500", style: const TextStyle(color: Color(0xFF00FFA3), fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white12,
          color: const Color(0xFF00FFA3),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _buildPurchaseCard(String title, String date, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF00FFA3), size: 24),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
    );
  }
}