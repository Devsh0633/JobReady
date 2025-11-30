import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'user_profile.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  /// Sign up with email and password
  Future<UserCredential> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  /// Login with email and password
  Future<UserCredential> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send reset email: $e');
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Save profile to Firestore (keyed by Auth UID)
  Future<void> saveProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) return; // Or throw error

    // Ensure the profile ID matches the Auth UID
    final profileWithId = UserProfile(
      id: user.uid,
      email: profile.email,
      name: profile.name,
      primaryIndustry: profile.primaryIndustry,
      experienceBand: profile.experienceBand,
      skills: profile.skills,
      goals: profile.goals,
      resumeUrl: profile.resumeUrl,
      portfolioUrl: profile.portfolioUrl,
    );

    await _users.doc(user.uid).set(profileWithId.toJson());
  }

  /// Load profile from Firestore
  Future<UserProfile?> loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _users.doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error loading profile: $e');
      return null;
    }
  }

  /// Clear profile (local only, usually handled by logout)
  Future<void> clearProfile() async {
    // No-op for Firestore, but we could clear local cache if we had one
  }

  // Deprecated: Credentials are now handled by FirebaseAuth
  Future<void> saveCredentials(String email, String password) async {}
  Future<Map<String, String>?> loadCredentials() async => null;
  Future<void> clearCredentials() async {}
}
