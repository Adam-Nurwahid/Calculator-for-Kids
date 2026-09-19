// lib/screens/rumus/detail/umum1/advanced_formulas_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/rumus_widgets.dart';
import 'pecahan_screen.dart';
import 'pangkat_screen.dart';
import 'konversi_persen_screen.dart';
import 'peluang_screen.dart';
import 'aljabar_screen.dart';
import 'statistika_screen.dart';
import '../umum2/bangun_ruang_screen.dart';

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
      label: 'Pecahan',
      symbol: '½',
      color: Color(0xFF4A9FE8),
      route: '/rumus/umum1/pecahan',
    ),
    NavOpData(
      label: 'Pangkat',
      symbol: 'xʸ',
      color: Color(0xFFFF5252),
      route: '/rumus/umum1/pangkat',
    ),
    NavOpData(
      label: 'Konversi Persen',
      symbol: '%',
      color: Color(0xFFD05CE3),
      route: '/rumus/umum1/konversi-persen',
    ),
    NavOpData(
      label: 'Peluang',
      symbol: '🎲',
      color: Color(0xFF5AC8FA),
      route: '/rumus/umum1/peluang',
    ),
    NavOpData(
      label: 'Aljabar',
      symbol: '📈',
      color: Color(0xFF4CD964),
      route: '/rumus/umum1/aljabar',
    ),
    NavOpData(
      label: 'Statistika',
      symbol: '📊',
      color: Color(0xFFFCA33B),
      route: '/rumus/umum1/statistika',
    ),
    NavOpData(
      label: 'Bangun Ruang',
      symbol: '🧊',
      color: Color(0xFFFF7043),
      route: '/rumus/umum2/bangun-ruang',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 6);
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
                PecahanScreen(),
                PangkatScreen(),
                KonversiPersenScreen(),
                PeluangScreen(),
                AljabarScreen(),
                StatistikaScreen(),
                BangunRuangScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
