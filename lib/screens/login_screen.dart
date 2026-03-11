import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // Added for name
  bool _isLogin = true;

  Future<void> _submit() async {
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // 1. Create the Auth User
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        // 2. Create the Database Profile for this specific user UID
        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .set({
              'uid': result.user!.uid,
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'vibePoints': 0, // New users start at 0
              'totalEvents': 0,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Text(
              "TICKETBURE",
              style: TextStyle(
                color: Color(0xFF00FFA3),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // Show name field only during Signup
            if (!_isLogin) ...[
              TextField(
                controller: _nameController,
                decoration: _inputDecoration("Full Name", Icons.person_outline),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
            ],

            TextField(
              controller: _emailController,
              decoration: _inputDecoration("Email", Icons.email_outlined),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: _inputDecoration("Password", Icons.lock_outline),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FFA3),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(_isLogin ? "LOGIN" : "CREATE ACCOUNT"),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(
                _isLogin
                    ? "New here? Sign up"
                    : "Already have an account? Login",
                style: const TextStyle(color: Color(0xFF00FFA3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      prefixIcon: Icon(icon, color: const Color(0xFF00FFA3)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF00FFA3)),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
    );
  }
}
