import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Update Profile Info (Phone, Name, or Photo URL)
  Future<void> updateProfile(Map<String, dynamic> data) async {
    String uid = _auth.currentUser!.uid;
    await _db.collection('users').doc(uid).update(data);
  }

  // Record a New Purchase
  Future<void> saveTicket(Map<String, dynamic> ticketData) async {
    String uid = _auth.currentUser!.uid;
    await _db.collection('users').doc(uid).collection('tickets').add({
      ...ticketData,
      'purchaseDate': FieldValue.serverTimestamp(),
      'status': 'valid',
    });

    // Also reward the user with Vibe Points!
    await _db.collection('users').doc(uid).update({
      'vibePoints': FieldValue.increment(50), // Give 50 points per ticket
    });
  }
}
