import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Import your screens
import 'screens/nav_shell.dart';
import 'screens/login_screen.dart'; // We will create this next

void main() async {
  // Ensure Flutter is ready for the Firebase handshake
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the file you generated in the terminal
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const NightlifeApp());
}

class NightlifeApp extends StatelessWidget {
  const NightlifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicketBure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF00FFA3), // That neon green vibe
      ),
      // The AuthGate decides which screen to show first
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // This stream listens for changes in the user's login status
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. If the connection is still loading, show a spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF00FFA3)),
            ),
          );
        }

        // 2. If the user is NOT logged in, show the Login screen
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // 3. If they ARE logged in, go to the main app navigation
        return const NavShell();
      },
    );
  }
}
