import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme-aware color tokens. Use these for any "chrome" color (background,
/// surface, border, text). Brand colors (primary, accent, tile colors)
/// stay in [AppColors] and are mode-agnostic.
///
/// Usage:
///   color: Tokens.surface(context)
///   color: Tokens.textPrimary(context)
class Tokens {
  Tokens._();

  static bool _dark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;

  static Color background(BuildContext c) =>
      _dark(c) ? AppColors.darkBackground : AppColors.background;

  static Color surface(BuildContext c) =>
      _dark(c) ? AppColors.darkSurface : AppColors.surface;

  static Color surfaceAlt(BuildContext c) =>
      _dark(c) ? AppColors.darkSurfaceAlt : AppColors.surfaceAlt;

  static Color border(BuildContext c) =>
      _dark(c) ? AppColors.darkBorder : AppColors.border;

  static Color textPrimary(BuildContext c) =>
      _dark(c) ? Colors.white : AppColors.textPrimary;

  static Color textSecondary(BuildContext c) =>
      _dark(c) ? const Color(0xFFB3B3B8) : AppColors.textSecondary;

  static Color textMuted(BuildContext c) =>
      _dark(c) ? const Color(0xFF7A7A82) : AppColors.textMuted;

  /// Slight elevation tint over surface (for chips, search bars).
  static Color subtleShadow(BuildContext c) =>
      _dark(c) ? const Color(0x33000000) : const Color(0x14000000);
}
