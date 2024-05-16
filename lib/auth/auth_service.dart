import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null && cred.user!.emailVerified) {
        return cred.user;
      } else {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email is not verified',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error logging in: $e");
      }
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  Future<void> registerUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
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
        print("Error registering user: $e");
      }
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
