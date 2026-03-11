import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'map_screen.dart';
import 'tickets_screen.dart'; // Add your tickets screen
import 'profile_screen.dart';

class NavShell extends StatefulWidget {
  const NavShell({super.key});

  @override
  State<NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<NavShell> {
  int _selectedIndex = 0;

  // Now the bottom bar only switches between these three
  final List<Widget> _screens = [
    const FeedScreen(),
    const MapScreen(),
    const TicketsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Let the feed/map go under the status bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // THE PROFILE ICON (Top Right)
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF00FFA3),
                child: Icon(Icons.person, color: Colors.black, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF00FFA3),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: "Feed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: "Tickets",
          ),
        ],
      ),
    );
  }
}
