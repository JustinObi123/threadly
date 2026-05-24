import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? message;

  const ComingSoonScreen({
    super.key,
    required this.title,
    this.icon = Icons.hourglass_empty,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tokens.background(context),
      appBar: AppBar(title: Text(title)),
      body: EmptyState(
        icon: icon,
        title: '$title — coming soon',
        message: message ?? 'This screen will be built in a later phase.',
      ),
    );
  }
}
