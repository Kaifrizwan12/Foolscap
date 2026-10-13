import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/auth_repository.dart';

/// App-lifetime controller, provided once at the root MultiProvider — see
/// docs/STATE_MANAGEMENT.md.
class AuthController extends ChangeNotifier {
  AuthController(this._repository) {
    _sub = _repository.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final AuthRepository _repository;
  StreamSubscription<User?>? _sub;

  User? _user;
  bool _isSubmitting = false;
  AppException? _error;

  bool get isSignedIn => _user != null;
  User? get user => _user;
  bool get isSubmitting => _isSubmitting;
  AppException? get error => _error;

  Future<void> signIn(String email, String password) => _run(
        () => _repository.signInWithEmail(email, password),
      );

  Future<void> signUp(String email, String password) => _run(
        () => _repository.signUpWithEmail(email, password),
      );

  Future<void> signOut() => _repository.signOut();

  Future<void> _run(Future<void> Function() action) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      _error = AppException.from(e);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
