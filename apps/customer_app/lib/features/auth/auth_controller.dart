import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._ref) : super(const AsyncData(null));
  final Ref _ref;

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(authRepositoryProvider).signInWithEmail(email, password),
    );
  }

  Future<void> signUp({required String name, required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(authRepositoryProvider).signUpWithEmail(
            email: email, password: password, displayName: name,
          ),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _ref.read(authRepositoryProvider).signInWithGoogle(),
    );
  }

  Future<void> signOut() => _ref.read(authRepositoryProvider).signOut();
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) => AuthController(ref));
