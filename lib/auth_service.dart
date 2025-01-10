import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!userDoc.exists) {
        if (kDebugMode) {
          print(
            'AuthService: Creating user document in Firestore');
        } 
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'createdAt': Timestamp.now(),
        });
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('AuthService Error: $e');
      } 
      rethrow;
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      if (kDebugMode) {
        print('AuthService: Attempting sign up...');
      } 
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (kDebugMode) {
        print(
          'AuthService: Auth user created, creating Firestore document...');
      } 
      
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'createdAt': Timestamp.now(),
      });

      if (kDebugMode) {
        print('AuthService: Sign up complete');
      } 
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('AuthService Error: $e');
      } 
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
