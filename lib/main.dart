import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_fonts.dart';
import 'screens/mode_selection_screen.dart';
import 'screens/level_selection_screen.dart';
import 'screens/kalkulator_anak_screen.dart';

// Rumus feature — menu
import 'screens/rumus/rumus_menu_screen.dart';

// Rumus — Anak tier detail pages
import 'screens/rumus/detail/anak/penjumlahan_screen.dart';
import 'screens/rumus/detail/anak/pengurangan_screen.dart';
import 'screens/rumus/detail/anak/perkalian_screen.dart';
import 'screens/rumus/detail/anak/pembagian_screen.dart';
import 'screens/rumus/detail/anak/tanda_kurung_screen.dart';
import 'screens/rumus/detail/anak/bangun_datar_screen.dart';

// Rumus — Umum 1 tier detail pages
import 'screens/rumus/detail/umum1/pecahan_screen.dart';
import 'screens/rumus/detail/umum1/pangkat_screen.dart';
import 'screens/rumus/detail/umum1/konversi_persen_screen.dart';
import 'screens/rumus/detail/umum1/peluang_screen.dart';
import 'screens/rumus/detail/umum1/aljabar_screen.dart';
import 'screens/rumus/detail/umum1/statistika_screen.dart';

// Rumus — Umum 2 tier detail pages
import 'screens/rumus/detail/umum2/bangun_ruang_screen.dart';
import 'screens/rumus/detail/umum2/trigonometri_screen.dart';
import 'screens/rumus/detail/umum2/logaritma_screen.dart';
import 'screens/rumus/detail/umum2/akar_kuadrat_screen.dart';
import 'screens/rumus/detail/umum2/deg_rad_screen.dart';
import 'screens/rumus/detail/umum2/barisan_deret_screen.dart';

void main() {
  runApp(const KalkulatorKidsApp());
}

class KalkulatorKidsApp extends StatelessWidget {
  const KalkulatorKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Anak',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: '/',
      routes: {
        // ── Root: goes straight to mode selection (no splash/start screen) ─
        '/': (context) => const ModeSelectionScreen(),
        '/level': (context) => const LevelSelectionScreen(),
        '/kalkulator-anak': (context) => const KalkulatorAnakScreen(),

        // ── Rumus menu ──────────────────────────────────────────────────
        '/rumus': (context) => const RumusMenuScreen(),

        // ── Rumus Anak tier ─────────────────────────────────────────────
        '/rumus/anak/penjumlahan':  (context) => const PenjumlahanScreen(),
        '/rumus/anak/pengurangan':  (context) => const PenguranganScreen(),
        '/rumus/anak/perkalian':    (context) => const PerkalianScreen(),
        '/rumus/anak/pembagian':    (context) => const PembagianScreen(),
        '/rumus/anak/tanda-kurung': (context) => const TandaKurungScreen(),
        '/rumus/anak/bangun-datar': (context) => const BangunDatarScreen(),

        // ── Rumus Umum 1 tier ────────────────────────────────────────────
        '/rumus/umum1/pecahan':        (context) => const PecahanScreen(),
        '/rumus/umum1/pangkat':        (context) => const PangkatScreen(),
        '/rumus/umum1/konversi-persen':(context) => const KonversiPersenScreen(),
        '/rumus/umum1/peluang':        (context) => const PeluangScreen(),
        '/rumus/umum1/aljabar':        (context) => const AljabarScreen(),
        '/rumus/umum1/statistika':     (context) => const StatistikaScreen(),

        // ── Rumus Umum 2 tier ────────────────────────────────────────────
        '/rumus/umum2/bangun-ruang':   (context) => const BangunRuangScreen(),
        '/rumus/umum2/trigonometri':   (context) => const TrigonometriScreen(),
        '/rumus/umum2/logaritma':      (context) => const LogaritmaScreen(),
        '/rumus/umum2/akar-kuadrat':   (context) => const AkarKuadratScreen(),
        '/rumus/umum2/deg-rad':        (context) => const DegRadScreen(),
        '/rumus/umum2/barisan-deret':  (context) => const BarisanDeretScreen(),
      },
    );
  }

  ThemeData _buildTheme() {
    // Apply Fredoka One globally via google_fonts textTheme so every Text widget
    // inherits it automatically. Individual screens can still override per-widget.
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.calcBackground,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.screenBg,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
    return base.copyWith(
      textTheme: AppFonts.textTheme.apply(
        bodyColor: AppColors.textTitle,
        displayColor: AppColors.textTitle,
      ),
    );
  }
}
