// lib/core/theme/app_fonts.dart
//
// Centralized font helpers using local "GothamRounded" font asset.

import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const String fontFamily = 'GothamRounded';

  /// Returns a [TextStyle] using GothamRounded, merged with the given properties.
  static TextStyle gothamRounded({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  /// A [TextTheme] pre-applied with GothamRounded.
  static TextTheme get textTheme => const TextTheme().apply(
        fontFamily: fontFamily,
      );
}

