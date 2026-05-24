import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark ||
        (mode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);

    void go(String path) => context.push(path);

    return Scaffold(
      backgroundColor: Tokens.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'My Profile',
                subtitle: 'Manage your personal information, preferences, and settings.',
              ),
              const _SectionLabel('General Information'),
              _SettingsGroup(items: [
                _Item(AppIcons.profile,  'Profile Information', AppColors.tileBlue,   onTap: () => go('/profile/info')),
                _Item(AppIcons.location, 'My Addresses',        AppColors.tilePurple, onTap: () => go('/profile/addresses')),
                _Item(AppIcons.giftCode, 'Gift Cards',          AppColors.tileYellow, onTap: () => go('/profile/gift-cards')),
                _Item(AppIcons.cashback, 'Cashback Offers',     AppColors.tileOrange, onTap: () => go('/profile/cashback')),
              ]),

              const _SectionLabel('Preferences'),
              _SettingsGroup(items: [
                _Item(AppIcons.language, 'Change Language', AppColors.tileOrange, onTap: () => go('/profile/language')),
                _Item(
                  AppIcons.theme, 'Dark Mode', AppColors.tilePurple,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (v) => v
                        ? ref.read(themeModeProvider.notifier).setDark()
                        : ref.read(themeModeProvider.notifier).setLight(),
                    activeColor: AppColors.primary,
                  ),
                  onTap: () => ref.read(themeModeProvider.notifier).toggle(),
                ),
              ]),

              const _SectionLabel('Social'),
              _SettingsGroup(items: [
                _Item(AppIcons.refer, 'Refer a Friend', AppColors.tileBlue,   onTap: () => go('/profile/refer')),
                _Item(AppIcons.share, 'Share App',      AppColors.tileOrange, onTap: () => _shareApp(context)),
                _Item(AppIcons.rate,  'Rate the App',   AppColors.tileYellow, onTap: () => _rateApp(context)),
              ]),

              const _SectionLabel('Communication'),
              _SettingsGroup(items: [
                _Item(AppIcons.send, 'Vendor Inbox', AppColors.tileBlue,  onTap: () => go('/profile/vendor-inbox')),
                _Item(AppIcons.send, 'Driver Inbox', AppColors.tileGreen, onTap: () => go('/profile/driver-inbox')),
              ]),

              const _SectionLabel('Legal'),
              _SettingsGroup(items: [
                _Item(AppIcons.help,    'Help & Support',     AppColors.tileOrange, onTap: () => go('/profile/help')),
                _Item(AppIcons.privacy, 'Privacy Policy',     AppColors.tileYellow, onTap: () => go('/profile/privacy')),
                _Item(AppIcons.privacy, 'Terms & Conditions', AppColors.tilePurple, onTap: () => go('/profile/terms')),
              ]),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: InkWell(
                  onTap: () => _confirmLogout(context, ref),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Tokens.surface(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Tokens.border(context)),
                    ),
                    child: Row(children: [
                      _IconTile(name: AppIcons.logout, color: AppColors.danger),
                      const SizedBox(width: 14),
                      Text('Log out',
                          style: t.titleMedium?.copyWith(color: AppColors.danger)),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: AppColors.danger),
                    ]),
                  ),
                ),
              ),
              Center(child: Padding(
                padding: const EdgeInsets.only(bottom: 24, top: 8),
                child: Text('V : 0.1', style: t.bodySmall?.copyWith(color: Tokens.textMuted(context))),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(authControllerProvider.notifier).signOut();
  }

  void _shareApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Native share will be wired up in a later phase.'),
    ));
  }

  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Store rating opens once the app is published.'),
    ));
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Text(label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Tokens.textSecondary(context), fontWeight: FontWeight.w600)),
      );
}

class _Item {
  final String icon;
  final String label;
  final Color color;
  final Widget? trailing;
  final VoidCallback? onTap;
  _Item(this.icon, this.label, this.color, {this.trailing, this.onTap});
}

class _SettingsGroup extends StatelessWidget {
  final List<_Item> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Tokens.surface(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Tokens.border(context)),
        ),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: items[i].onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(children: [
                    _IconTile(name: items[i].icon, color: items[i].color),
                    const SizedBox(width: 14),
                    Expanded(child: Text(items[i].label,
                        style: t.titleMedium?.copyWith(color: Tokens.textPrimary(context)))),
                    items[i].trailing ??
                        Icon(Icons.chevron_right, color: Tokens.textMuted(context)),
                  ]),
                ),
              ),
              if (i < items.length - 1)
                Divider(height: 1, indent: 60, endIndent: 16, color: Tokens.border(context)),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  final String name;
  final Color color;
  const _IconTile({required this.name, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: AppIcon(name, size: 20, color: color),
      );
}
