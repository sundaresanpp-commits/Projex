import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class AuthService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  fb_auth.User? get currentFirebaseUser => _auth.currentUser;

  Stream<fb_auth.User?> get authStateChanges => _auth.authStateChanges();

  /// Register a student with Firebase Authentication and save academic profile to Firestore.
  Future<User> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String college,
    required String department,
    required String year,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final fbUser = credential.user;
    if (fbUser == null) {
      throw Exception('Failed to create account.');
    }

    try {
      await fbUser.updateDisplayName(name);
    } catch (e) {
      debugPrint('Failed to update display name: $e');
    }

    final studentUser = User(
      id: fbUser.uid,
      name: name,
      email: email.trim(),
      college: college,
      department: department,
      year: year,
      bio: '',
      skills: const [],
      projectCount: 0,
      followers: 0,
      following: 0,
    );

    // Save profile to Cloud Firestore
    try {
      await _firestore.collection('users').doc(fbUser.uid).set(studentUser.toMap());
    } catch (e) {
      debugPrint('Error saving student profile to Cloud Firestore: $e');
      rethrow;
    }

    return studentUser;
  }

  /// Sign in a student with Firebase Authentication and retrieve profile.
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final fbUser = credential.user;
    if (fbUser == null) {
      throw Exception('Failed to sign in.');
    }

    // Attempt to load student profile from Cloud Firestore
    try {
      final doc = await _firestore.collection('users').doc(fbUser.uid).get();
      if (doc.exists && doc.data() != null) {
        return User.fromMap(doc.data()!, fbUser.uid);
      }
    } catch (e) {
      debugPrint('Warning: Cloud Firestore profile fetch skipped or pending console setup: $e');
    }

    // Fallback profile if Firestore is not yet initialized or profile doc is missing
    return User(
      id: fbUser.uid,
      name: fbUser.displayName ?? email.split('@').first,
      email: fbUser.email ?? email,
      college: 'Student',
      department: 'Engineering',
      year: '1st Year',
      bio: '',
      skills: const [],
      projectCount: 0,
      followers: 0,
      following: 0,
    );
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Helper to convert Firebase Auth exceptions into user-friendly messages.
  static String getErrorMessage(Object error) {
    if (error is fb_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found with this email. Please sign up first.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-credential':
          return 'Incorrect password or account not found. If you are new, tap Sign Up below.';
        case 'email-already-in-use':
          return 'An account already exists for this email.';
        case 'weak-password':
          return 'Password must be at least 6 characters.';
        case 'invalid-email':
          return 'Please enter a valid college email address.';
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled in Firebase Console.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return error.message ?? 'Authentication failed: ${error.code}';
      }
    }
    return error.toString();
  }
}
