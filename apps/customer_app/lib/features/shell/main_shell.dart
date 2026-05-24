import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = <_Tab>[
    _Tab('/',           AppIcons.home,     'Home'),
    _Tab('/favourites', AppIcons.favorite, 'Favourites'),
    _Tab('/wallet',     AppIcons.wallet,   'Wallet'),
    _Tab('/orders',     AppIcons.orders,   'Orders'),
    _Tab('/profile',    AppIcons.profile,  'Profile'),
  ];

  int _indexFor(String location) {
    for (var i = _tabs.length - 1; i >= 0; i--) {
      final path = _tabs[i].path;
      if (path == '/' && location == '/') return 0;
      if (path != '/' && location.startsWith(path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _indexFor(location);
    return Scaffold(
      backgroundColor: Tokens.background(context),
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Tokens.surface(context),
            boxShadow: [BoxShadow(color: Tokens.subtleShadow(context), blurRadius: 18, offset: const Offset(0, -6))],
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              for (int i = 0; i < _tabs.length; i++)
                Expanded(child: _TabButton(
                  tab: _tabs[i],
                  selected: i == index,
                  onTap: () => context.go(_tabs[i].path),
                )),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final _Tab tab;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.tab, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? AppColors.primary : Tokens.textPrimary(context);
    final labelColor = selected ? AppColors.primary : Tokens.textSecondary(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(tab.icon, size: 24, color: iconColor),
            const SizedBox(height: 4),
            Text(tab.label,
                style: TextStyle(
                  fontFamily: 'Urbanist', package: 'core',
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: labelColor,
                )),
          ],
        ),
      ),
    );
  }
}

class _Tab {
  final String path;
  final String icon;
  final String label;
  const _Tab(this.path, this.icon, this.label);
}
