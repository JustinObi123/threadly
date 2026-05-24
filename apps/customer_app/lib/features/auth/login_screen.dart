import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signIn(_email.text.trim(), _password.text);
    _toastErrorIfAny();
  }

  Future<void> _google() async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
    _toastErrorIfAny(silentCodes: const {
      'popup-closed-by-user',
      'cancelled-popup-request',
      'web-context-canceled',
      'user-cancelled',
    });
  }

  void _toastErrorIfAny({Set<String> silentCodes = const {}}) {
    final err = ref.read(authControllerProvider).error;
    if (err == null || !mounted) return;
    final code = err is dynamic && (err as dynamic).code is String
        ? (err as dynamic).code as String
        : '';
    if (silentCodes.contains(code)) return;
    final msg = err is dynamic && (err as dynamic).message is String
        ? (err as dynamic).message as String
        : err.toString();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final t = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Tokens.background(context),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Threadly', style: t.displayMedium),
                    const SizedBox(height: 4),
                    Text('Sign in to keep shopping.', style: t.bodyMedium),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Sign in',
                      loading: state.isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: state.isLoading ? null : _google,
                      icon: const AppIcon(AppIcons.google, size: 20),
                      label: const Text('Continue with Google'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("No account? "),
                        TextButton(
                          onPressed: () => context.go('/signup'),
                          child: const Text('Create one'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
