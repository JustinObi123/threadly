import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/app_user.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? fb.FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _db;

  @override
  Stream<AppUser?> authStateChanges() =>
      _auth.userChanges().asyncMap(_resolve);

  @override
  AppUser? get currentUser {
    // Synchronous getter — best-effort; full doc is loaded via stream.
    final u = _auth.currentUser;
    if (u == null) return null;
    return AppUser(
      uid: u.uid,
      email: u.email ?? '',
      displayName: u.displayName,
      photoUrl: u.photoURL,
      phone: u.phoneNumber,
      createdAt: u.metadata.creationTime ?? DateTime.now(),
    );
  }

  Future<AppUser?> _resolve(fb.User? u) async {
    if (u == null) return null;
    final snap = await _db.collection('users').doc(u.uid).get();
    if (!snap.exists) {
      // First-time login: bootstrap the user doc.
      final bootstrap = AppUser(
        uid: u.uid,
        email: u.email ?? '',
        displayName: u.displayName,
        photoUrl: u.photoURL,
        phone: u.phoneNumber,
        createdAt: DateTime.now(),
      );
      await _db.collection('users').doc(u.uid).set(bootstrap.toMap());
      return bootstrap;
    }
    return AppUser.fromMap(u.uid, snap.data()!);
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return (await _resolve(cred.user))!;
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await cred.user!.updateDisplayName(displayName);
    return (await _resolve(cred.user))!;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final provider = fb.GoogleAuthProvider()
      ..addScope('email')
      ..addScope('profile')
      ..setCustomParameters({'prompt': 'select_account'});

    final fb.UserCredential cred;
    if (kIsWeb) {
      // Web: opens a Google popup. Make sure popups aren't blocked for localhost.
      cred = await _auth.signInWithPopup(provider);
    } else {
      // Android/iOS: opens a Chrome custom tab. Requires google_sign_in
      // plugin + per-platform Google OAuth setup for production polish, but
      // the basic provider flow works for testing.
      cred = await _auth.signInWithProvider(provider);
    }
    final user = await _resolve(cred.user);
    if (user == null) {
      throw fb.FirebaseAuthException(
        code: 'google-no-user',
        message: 'Google returned no user.',
      );
    }
    return user;
  }

  @override
  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() => _auth.signOut();
}
