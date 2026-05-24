import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: _AdminApp()));

class _AdminApp extends StatelessWidget {
  const _AdminApp();
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Threadly Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: Scaffold(
          appBar: AppBar(title: const Text('Threadly Admin')),
          body: const EmptyState(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Admin web — Phase 2/3',
            message: 'Approvals, catalog, orders, payouts, settings, and reports land here.',
          ),
        ),
      );
}
