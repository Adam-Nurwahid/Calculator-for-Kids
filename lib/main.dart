import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_fonts.dart';
import 'screens/mode_selection_screen.dart';
import 'screens/level_selection_screen.dart';
import 'screens/kalkulator_anak_screen.dart';
import 'screens/kalkulator_umum_screen.dart';

// Rumus feature — menu & container screens
import 'screens/rumus/rumus_menu_screen.dart';
import 'screens/rumus/detail/anak/basic_formulas_screen.dart';
import 'screens/rumus/detail/umum1/advanced_formulas_screen.dart';
import 'screens/rumus/detail/geometri/geometry_formulas_screen.dart';

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
        '/kalkulator-umum': (context) => const KalkulatorUmumScreen(),

        // ── Rumus menu ──────────────────────────────────────────────────
        '/rumus': (context) => const RumusMenuScreen(),

        // ── Rumus Category 1: Operasi Dasar ─────────────────────────────
        '/rumus/anak/penjumlahan':  (context) => const BasicFormulasScreen(initialIndex: 0),
        '/rumus/anak/pengurangan':  (context) => const BasicFormulasScreen(initialIndex: 1),
        '/rumus/anak/perkalian':    (context) => const BasicFormulasScreen(initialIndex: 2),
        '/rumus/anak/pembagian':    (context) => const BasicFormulasScreen(initialIndex: 3),
        '/rumus/anak/tanda-kurung': (context) => const BasicFormulasScreen(initialIndex: 4),
        '/rumus/anak/aljabar':      (context) => const BasicFormulasScreen(initialIndex: 5),

        // ── Rumus Category 2: Geometri & Matematika Menengah ──────────────
        '/rumus/geometri/bangun-datar':(context) => const GeometryFormulasScreen(initialIndex: 0),
        '/rumus/geometri/bangun-ruang':(context) => const GeometryFormulasScreen(initialIndex: 1),
        '/rumus/geometri/pecahan':     (context) => const GeometryFormulasScreen(initialIndex: 2),
        '/rumus/geometri/pangkat':     (context) => const GeometryFormulasScreen(initialIndex: 3),
        '/rumus/geometri/konversi-persen':(context) => const GeometryFormulasScreen(initialIndex: 4),
        '/rumus/geometri/akar-kuadrat':(context) => const GeometryFormulasScreen(initialIndex: 5),

        // ── Rumus Category 3: Matematika Tingkat Lanjut ──────────────────
        '/rumus/umum1/trigonometri':(context) => const AdvancedFormulasScreen(initialIndex: 0),
        '/rumus/umum1/deg-rad':     (context) => const AdvancedFormulasScreen(initialIndex: 1),
        '/rumus/umum1/logaritma':   (context) => const AdvancedFormulasScreen(initialIndex: 2),
        '/rumus/umum1/peluang':     (context) => const AdvancedFormulasScreen(initialIndex: 3),
        '/rumus/umum1/statistika':  (context) => const AdvancedFormulasScreen(initialIndex: 4),
        '/rumus/umum1/barisan-deret':(context) => const AdvancedFormulasScreen(initialIndex: 5),

        // ── Legacy / Alias Routes ─────────────────────────────────────────
        '/rumus/umum1/pecahan':        (context) => const GeometryFormulasScreen(initialIndex: 2),
        '/rumus/umum1/pangkat':        (context) => const GeometryFormulasScreen(initialIndex: 3),
        '/rumus/umum1/konversi-persen':(context) => const GeometryFormulasScreen(initialIndex: 4),
        '/rumus/umum1/aljabar':        (context) => const BasicFormulasScreen(initialIndex: 5),
        '/rumus/umum1/akar-kuadrat':   (context) => const GeometryFormulasScreen(initialIndex: 5),
        '/rumus/geometri/trigonometri':(context) => const AdvancedFormulasScreen(initialIndex: 0),
        '/rumus/geometri/deg-rad':     (context) => const AdvancedFormulasScreen(initialIndex: 1),
        '/rumus/anak/bangun-datar':    (context) => const GeometryFormulasScreen(initialIndex: 0),
        '/rumus/umum2/bangun-ruang':   (context) => const GeometryFormulasScreen(initialIndex: 1),
        '/rumus/umum2/trigonometri':   (context) => const AdvancedFormulasScreen(initialIndex: 0),
        '/rumus/umum2/logaritma':      (context) => const AdvancedFormulasScreen(initialIndex: 2),
        '/rumus/umum2/akar-kuadrat':   (context) => const GeometryFormulasScreen(initialIndex: 5),
        '/rumus/umum2/deg-rad':        (context) => const AdvancedFormulasScreen(initialIndex: 1),
        '/rumus/umum2/barisan-deret':  (context) => const AdvancedFormulasScreen(initialIndex: 5),
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
