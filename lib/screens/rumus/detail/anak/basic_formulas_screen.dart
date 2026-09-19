// lib/screens/rumus/detail/anak/basic_formulas_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/rumus_widgets.dart';
import 'penjumlahan_screen.dart';
import 'pengurangan_screen.dart';
import 'perkalian_screen.dart';
import 'pembagian_screen.dart';
import 'tanda_kurung_screen.dart';
import 'bangun_datar_screen.dart';

class BasicFormulasScreen extends StatefulWidget {
  const BasicFormulasScreen({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<BasicFormulasScreen> createState() => _BasicFormulasScreenState();
}

class _BasicFormulasScreenState extends State<BasicFormulasScreen> {
  late final PageController _pageController;
  late int _currentIndex;

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
        duration: const Duration(milliseconds: 350),
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
          // Fixed Top Header & Category Navigation Bar
          RumusHeader(
            title: 'Matematika Tingkat\nDasar',
            activeOpIndex: _currentIndex,
            showNav: true,
            onOpTabSelected: _onTabSelected,
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
                PenjumlahanScreen(),
                PenguranganScreen(),
                PerkalianScreen(),
                PembagianScreen(),
                TandaKurungScreen(),
                BangunDatarScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
