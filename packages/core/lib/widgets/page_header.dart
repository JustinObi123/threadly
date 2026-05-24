import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';

/// Large title + subtitle used at the top of full-screen tabs (Foodie style).
class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(20, 16, 20, 16),
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: t.headlineMedium?.copyWith(color: Tokens.textPrimary(context))),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, style: t.bodyMedium?.copyWith(color: Tokens.textSecondary(context))),
              ],
            ],
          )),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const SectionTitle(this.title, {super.key, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
      child: Row(children: [
        Expanded(child: Text(title,
            style: t.titleLarge?.copyWith(color: Tokens.textPrimary(context)))),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text('View all',
                style: t.titleSmall?.copyWith(color: AppColors.primary)),
          ),
      ]),
    );
  }
}

class PillTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const PillTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Tokens.surfaceAlt(context),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(children: [
        for (int i = 0; i < labels.length; i++)
          Expanded(child: GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: i == selectedIndex ? AppColors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[i],
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  package: 'core',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: i == selectedIndex
                      ? AppColors.primary
                      : Tokens.textSecondary(context),
                ),
              ),
            ),
          )),
      ]),
    );
  }
}
