import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: _VendorApp()));

class _VendorApp extends StatelessWidget {
  const _VendorApp();
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Threadly Vendor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: Scaffold(
          appBar: AppBar(title: const Text('Threadly Vendor')),
          body: const EmptyState(
            icon: Icons.storefront_outlined,
            title: 'Vendor app — Phase 2',
            message: 'Onboarding, product CRUD, and order management land here.',
          ),
        ),
      );
}
