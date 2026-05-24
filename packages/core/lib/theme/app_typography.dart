import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String _family = 'Urbanist';

  static TextTheme textTheme(Brightness brightness) {
    final color = brightness == Brightness.dark ? Colors.white : const Color(0xFF111111);

    TextStyle _t(double size, FontWeight weight, {double? letter, Color? c}) => TextStyle(
          fontFamily: _family,
          package: 'core',
          fontSize: size,
          fontWeight: weight,
          letterSpacing: letter,
          color: c ?? color,
          height: 1.2,
        );

    return TextTheme(
      displayLarge:   _t(40, FontWeight.w800, letter: -0.5),
      displayMedium:  _t(32, FontWeight.w800),
      displaySmall:   _t(28, FontWeight.w700),
      headlineLarge:  _t(26, FontWeight.w700),
      headlineMedium: _t(22, FontWeight.w700),
      headlineSmall:  _t(18, FontWeight.w700),
      titleLarge:     _t(18, FontWeight.w600),
      titleMedium:    _t(16, FontWeight.w600),
      titleSmall:     _t(14, FontWeight.w600),
      bodyLarge:      _t(16, FontWeight.w400),
      bodyMedium:     _t(14, FontWeight.w400),
      bodySmall:      _t(12, FontWeight.w400),
      labelLarge:     _t(14, FontWeight.w600),
      labelMedium:    _t(12, FontWeight.w600),
      labelSmall:     _t(11, FontWeight.w500),
    );
  }
}
