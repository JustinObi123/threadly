import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileInfoScreen extends ConsumerStatefulWidget {
  const ProfileInfoScreen({super.key});
  @override
  ConsumerState<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends ConsumerState<ProfileInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final u = ref.read(currentUserProvider);
    _nameCtl.text  = u?.displayName ?? '';
    _phoneCtl.text = u?.phone ?? '';
  }

  @override
  void dispose() { _nameCtl.dispose(); _phoneCtl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final u = ref.read(currentUserProvider);
    if (u == null) return;
    setState(() => _saving = true);
    try {
      final fbUser = fb.FirebaseAuth.instance.currentUser;
      await fbUser?.updateDisplayName(_nameCtl.text.trim());
      await FirebaseFirestore.instance.collection('users').doc(u.uid).set({
        'displayName': _nameCtl.text.trim(),
        'phone': _phoneCtl.text.trim(),
      }, SetOptions(merge: true));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = ref.watch(currentUserProvider);
    return Scaffold(
      backgroundColor: Tokens.background(context),
      appBar: AppBar(title: const Text('Profile Information')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Tokens.surfaceAlt(context),
                    backgroundImage: u?.photoUrl != null ? NetworkImage(u!.photoUrl!) : null,
                    child: u?.photoUrl == null
                        ? Icon(Icons.person, size: 48, color: Tokens.textPrimary(context))
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameCtl,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (v) => Validators.required(v, 'Name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: u?.email ?? '',
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneCtl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 28),
                PrimaryButton(label: 'Save changes', loading: _saving, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
