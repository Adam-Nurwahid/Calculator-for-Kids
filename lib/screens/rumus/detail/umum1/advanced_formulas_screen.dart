// lib/screens/rumus/detail/umum1/advanced_formulas_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/rumus_widgets.dart';
import '../umum2/trigonometri_screen.dart';
import '../umum2/deg_rad_screen.dart';
import '../umum2/logaritma_screen.dart';
import 'peluang_screen.dart';
import 'statistika_screen.dart';
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
      icon: Icons.view_in_ar,
      color: Color(0xFFFF7043),
      route: '/rumus/geometri/bangun-ruang',
    ),
    NavOpData(
      label: 'Trigonometri',
      icon: Icons.change_history_rounded,
      color: Color(0xFF3F51B5),
      route: '/rumus/umum1/trigonometri',
    ),
    NavOpData(
      label: 'Logaritma',
      symbol: 'log',
      color: Color(0xFF673AB7),
      route: '/rumus/umum1/logaritma',
    ),
    NavOpData(
      label: 'Akar Kuadrat',
      symbol: '√x',
      color: Color(0xFF00BFA5),
      route: '/rumus/geometri/akar-kuadrat',
    ),
    NavOpData(
      label: 'Deg/Rad',
      symbol: '°/rad',
      color: Color(0xFF8D6E63),
      route: '/rumus/umum1/deg-rad',
    ),
    NavOpData(
      label: 'Barisan & Deret',
      symbol: 'Σ',
      color: Color(0xFFFF8F00),
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
