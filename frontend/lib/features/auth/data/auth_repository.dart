import 'package:firebase_auth/firebase_auth.dart';

/// Only place in the app that talks to FirebaseAuth directly. See
/// docs/FEATURE_PLAN.md Phase 0.1 and docs/TECHNICAL_DEEP_DIVE.md section 1.3.
class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithEmail(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}
