import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        if (cred.user!.emailVerified) {
          return cred.user;
        } else {
          await _auth.signOut();
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
    return null;
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
        print("General error: $e");
      }
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
