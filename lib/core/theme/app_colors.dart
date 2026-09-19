// lib/core/theme/app_colors.dart
//
// Single source of truth for every color used in the Calculator for Kids app.
// All screens and widgets must import from here instead of hardcoding Color(0x…)
// or using default Flutter Material colors.

import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Kid Calculator Screen ("Kalkulator SD") ─────────────────────────────────

  /// Main yellow background of the calculator screen.
  static const Color calcBackground = Color(0xFFFFC800);

  /// Display screen background — slightly darker yellow.
  static const Color calcDisplayBg = Color(0xFFF2B705);

  /// Numbers / characters text — near-black for readability.
  static const Color calcTextDark = Color(0xFF1A1A1A);

  /// AC / backspace / expand "( )" buttons — green.
  static const Color calcButtonGreen = Color(0xFF4CD964);

  /// Operator buttons (÷ × − + =) — orange.
  static const Color calcButtonOrange = Color(0xFFF5A623);

  /// Operator button gradient end (optional second stop).
  static const Color calcButtonOrangeAlt = Color(0xFFF58220);

  /// Number buttons — white.
  static const Color calcButtonWhite = Color(0xFFFFFFFF);

  /// Cat mascot fur — darker orange.
  static const Color mascotFurDark = Color(0xFFE8933A);

  /// Mascot outfit / scarf — blue.
  static const Color mascotOutfitBlue = Color(0xFF29ABE2);

  /// Mascot face / paw — cream / peach.
  static const Color mascotSkin = Color(0xFFF5D5B8);

  // ── Basic Math Lesson Screens ("Matematika Tingkat Dasar") ──────────────────

  /// Top header background — warm orange.
  static const Color lessonHeaderBg = Color(0xFFFFB84D);

  /// Bottom nav / tab bar under header — dark charcoal.
  static const Color lessonNavBarBg = Color(0xFF3D3D3D);

  /// Main content area background — white.
  static const Color lessonContentBg = Color(0xFFFFFFFF);

  /// Addition "+" icon color.
  static const Color iconAddition = Color(0xFFFFB84D);

  /// Subtraction "−" icon color.
  static const Color iconSubtraction = Color(0xFFF2585C);

  /// Multiplication "×" icon color.
  static const Color iconMultiplication = Color(0xFFD65DB1);

  /// Division "÷" icon color.
  static const Color iconDivision = Color(0xFF4A9FE8);

  /// Numbered list bullets (1, 2, 3…) — orange.
  static const Color bulletNumber = Color(0xFFF5A623);

  /// Main heading text — near-black.
  static const Color textTitle = Color(0xFF1A1A1A);

  /// Description / body text — medium grey.
  static const Color textDescription = Color(0xFF666666);

  /// Border around tip / example boxes — light grey.
  static const Color tipBoxBorder = Color(0xFFDDDDDD);

  // ── Redesign Kids Math Formula Specific Colors ─────────────────────────────

  /// Top header background warm orange (#FFB042).
  static const Color rumusHeaderBg = Color(0xFFFFB042);

  /// Horizontal quick-nav dark slate container (#383B3E).
  static const Color rumusNavBg = Color(0xFF383B3E);

  /// Quick-nav Penjumlahan (+) squircle background (#FFB347).
  static const Color rumusAddColor = Color(0xFFFFB347);

  /// Quick-nav Pengurangan (-) squircle background (#FF5252).
  static const Color rumusSubColor = Color(0xFFFF5252);

  /// Quick-nav Perkalian (×) squircle background (#D05CE3).
  static const Color rumusMulColor = Color(0xFFD05CE3);

  /// Quick-nav Pembagian (÷) squircle background (#5AC8FA).
  static const Color rumusDivColor = Color(0xFF5AC8FA);

  /// Quick-nav Tanda Kurung ( ) squircle background (#4CD964).
  static const Color rumusBracketColor = Color(0xFF4CD964);

  /// Quick-nav Bangun Datar (📐) squircle background (#FF7043).
  static const Color rumusShapesColor = Color(0xFFFF7043);

  /// Numbered property circular badge (#FCA33B).
  static const Color rumusBadgeOrange = Color(0xFFFCA33B);


  // ── Shared / Navigation Screens ─────────────────────────────────────────────
  // (Inferred from the orange palette family for visual consistency)

  /// Warm lemon-cream background used on selection & navigation screens.
  static const Color screenBg = Color(0xFFFFFBE7);

  /// Primary orange accent — same as [lessonHeaderBg], aliased for clarity.
  static const Color accentOrange = Color(0xFFFFB84D);

  /// Darker orange for shadows, secondary elements, and pressed states.
  static const Color accentOrangeDark = Color(0xFFF5A623);

  /// White pill background for list-item buttons.
  static const Color pillBg = Color(0xFFFFFFFF);

  // ── Semantic colors (not part of the palette but needed for error states) ───

  /// Error/warning color — used for division-by-zero display text.
  static const Color errorText = Color(0xFFFF4444);
}
