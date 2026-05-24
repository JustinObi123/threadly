import 'package:core/core.dart';
import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tokens.background(context),
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(
              title: 'Your Favourites,\nAll in One Place',
              subtitle: 'Quick access to the stores and pieces you love.',
            ),
            const SizedBox(height: 4),
            PillTabs(
              labels: const ['Favourite Stores', 'Favourite Items'],
              selectedIndex: _tab,
              onTap: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: EmptyState(
                icon: _tab == 0 ? Icons.storefront_outlined : Icons.favorite_border,
                title: _tab == 0
                    ? 'No favourite stores yet'
                    : 'No favourite items yet',
                message: 'Tap the heart on any store or product to save it here.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
