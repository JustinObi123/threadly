import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: _DriverApp()));

class _DriverApp extends StatelessWidget {
  const _DriverApp();
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Threadly Driver',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: Scaffold(
          appBar: AppBar(title: const Text('Threadly Driver')),
          body: const EmptyState(
            icon: Icons.local_shipping_outlined,
            title: 'Driver app — Phase 5',
            message: 'Local delivery assignments, navigation, and earnings land here.',
          ),
        ),
      );
}
