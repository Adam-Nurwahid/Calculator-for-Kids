// lib/screens/rumus/detail/umum1/advanced_formulas_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/rumus_widgets.dart';
import '../umum2/trigonometri_screen.dart';
import '../umum2/deg_rad_screen.dart';
import '../umum2/logaritma_screen.dart';
import '../umum2/barisan_deret_screen.dart';
import '../umum2/bangun_ruang_screen.dart';
import '../umum2/akar_kuadrat_screen.dart';

class AdvancedFormulasScreen extends StatefulWidget {
  const AdvancedFormulasScreen({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<AdvancedFormulasScreen> createState() => _AdvancedFormulasScreenState();
}

class _AdvancedFormulasScreenState extends State<AdvancedFormulasScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  static const List<NavOpData> _advancedNavItems = [
    NavOpData(
      label: 'Bangun Ruang',
      assetPath: 'assets/ic_cal_advance/ic_bangun_ruang.png',
      route: '/rumus/geometri/bangun-ruang',
    ),
    NavOpData(
      label: 'Trigonometri',
      assetPath: 'assets/ic_cal_advance/ic_trigonometri2.png',
      route: '/rumus/umum1/trigonometri',
    ),
    NavOpData(
      label: 'Logaritma',
      assetPath: 'assets/ic_cal_advance/ic_logaritma2.png',
      route: '/rumus/umum1/logaritma',
    ),
    NavOpData(
      label: 'Akar Kuadrat',
      assetPath: 'assets/ic_cal_advance/ic_akar2.png',
      route: '/rumus/geometri/akar-kuadrat',
    ),
    NavOpData(
      label: 'Deg/Rad',
      assetPath: 'assets/ic_cal_advance/ic_rad.png',
      route: '/rumus/umum1/deg-rad',
    ),
    NavOpData(
      label: 'Barisan & Deret',
      assetPath: 'assets/ic_cal_advance/ic_baris.png',
      route: '/rumus/umum1/barisan-deret',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 5);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: Column(
        children: [
          // Fixed Top Banner & Category Navigation Bar
          RumusHeader(
            title: 'Matematika Tingkat\nLanjut',
            activeOpIndex: _currentIndex,
            showNav: true,
            onOpTabSelected: _onTabSelected,
            navItems: _advancedNavItems,
          ),

          // Scrollable Content area with PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: const [
                BangunRuangScreen(),
                TrigonometriScreen(),
                LogaritmaScreen(),
                AkarKuadratScreen(),
                DegRadScreen(),
                BarisanDeretScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
