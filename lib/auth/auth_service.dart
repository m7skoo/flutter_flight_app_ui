import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to log in a user with email and password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to sign in with the provided email and password
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Check if the user exists and their email is verified
      if (cred.user != null) {
        if (cred.user!.emailVerified) {
          return cred.user; // Return the authenticated user
        } else {
          await _auth.signOut(); // Sign out the user if email is not verified
          throw FirebaseAuthException(
              code: 'email-not-verified', message: 'Email is not verified');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("FirebaseAuthException: ${e.message}");
      }
      rethrow; // Rethrow the error to handle it in the UI
    } catch (e) {
      if (kDebugMode) {
        print("General error: $e");
      }
      rethrow; // Rethrow the error to handle it in the UI
    }
    return null; // Return null if login was unsuccessful
  }

  // Method to register a new user with email and password
  Future<void> registerUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to create a new user with the provided email and password
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Check if the user exists and send an email verification
      if (cred.user != null) {
        await cred.user!.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Error registering user: ${e.message}");
      }
      throw Exception("Registration failed: ${e.message}");
    } catch (e) {
      if (kDebugMode) {
        print("General error: $e");
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
