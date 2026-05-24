import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary       = Color(0xFFF76B1C); // orange CTA
  static const Color primarySoft   = Color(0xFFFFB36B);
  static const Color accent        = Color(0xFF0E1430); // deep navy pills/headlines
  static const Color accentSoft    = Color(0xFF1B2347);

  // Backgrounds (soft lavender-gray)
  static const Color background    = Color(0xFFF5F4FB);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceAlt    = Color(0xFFEFEEF7);
  static const Color border        = Color(0xFFE6E5EE);

  // Text
  static const Color textPrimary   = Color(0xFF0E1430);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted     = Color(0xFF9CA3AF);

  // Status
  static const Color success = Color(0xFF22B07D);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger  = Color(0xFFF03E3E);
  static const Color info    = Color(0xFF3BB6F0);

  // Tile accents used in profile menu (matching Foodie's colored icons)
  static const Color tileBlue   = Color(0xFF3BB6F0);
  static const Color tilePurple = Color(0xFF6C63FF);
  static const Color tileYellow = Color(0xFFF4C242);
  static const Color tilePink   = Color(0xFFFF7AAB);
  static const Color tileGreen  = Color(0xFF22B07D);
  static const Color tileOrange = Color(0xFFF76B1C);

  // Wallet gradient
  static const Color walletStart = Color(0xFF6C63FF);
  static const Color walletEnd   = Color(0xFF4F46E5);
  static const Color walletCta   = Color(0xFFF4C242);

  // Dark theme
  static const Color darkBackground = Color(0xFF0B0B0B);
  static const Color darkSurface    = Color(0xFF1A1A1A);
  static const Color darkSurfaceAlt = Color(0xFF222222);
  static const Color darkBorder     = Color(0xFF2F2F2F);
}
