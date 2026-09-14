// lib/core/theme/app_fonts.dart
//
// Centralized font helpers using google_fonts.
//
// Font choice: "Fredoka" (google_fonts method: GoogleFonts.fredoka()).
// This is the variable-weight successor to "Fredoka One" and is visually
// identical at bold weights. The codebase previously referenced
// fontFamily: 'Fredoka One' as a string — that family is now served by
// the same underlying font file via google_fonts.
//
// Why google_fonts instead of a bundled .ttf?
//   – No font file needs to be downloaded and committed to the repo.
//   – google_fonts caches the font locally after the first run; subsequent
//     runs work fully offline.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppFonts {
  /// Returns a [TextStyle] using Fredoka, merged with the given properties.
  ///
  /// Usage:
  /// ```dart
  /// Text('Hello', style: AppFonts.fredoka(fontSize: 24, color: Colors.white))
  /// ```
  static TextStyle fredoka({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.fredoka(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  /// A [TextTheme] pre-applied with Fredoka.
  /// Pass this to [ThemeData.textTheme] in [MaterialApp] via
  /// [ThemeData.copyWith].
  static TextTheme get textTheme => GoogleFonts.fredokaTextTheme();
}
