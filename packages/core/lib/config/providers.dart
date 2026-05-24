import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/cart_repository.dart';
import '../repositories/firebase_auth_repository.dart';
import '../repositories/firestore_cart_repository.dart';
import '../repositories/firestore_product_repository.dart';
import '../repositories/product_repository.dart';

// Repository providers — single place to swap implementations (e.g. for tests).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return FirestoreProductRepository();
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return FirestoreCartRepository();
});

// Auth state stream — the rest of the app consumes this.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

// Convenience: current user or null without subscribing to a stream.
final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).value;
});

/// App-wide theme mode. Defaults to system; user can flip via the
/// "Dark Mode" switch in profile.
class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system);
  void setLight() => state = ThemeMode.light;
  void setDark()  => state = ThemeMode.dark;
  void toggle()   => state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>((ref) => ThemeModeController());
