// lib/screens/rumus/detail/geometri/geometry_formulas_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/rumus_widgets.dart';
import '../umum1/pecahan_screen.dart';
import '../umum1/pangkat_screen.dart';
import '../umum1/konversi_persen_screen.dart';
import '../umum1/peluang_screen.dart';
import '../umum1/aljabar_screen.dart';
import '../umum1/statistika_screen.dart';

class GeometryFormulasScreen extends StatefulWidget {
  const GeometryFormulasScreen({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<GeometryFormulasScreen> createState() => _GeometryFormulasScreenState();
}

class _GeometryFormulasScreenState extends State<GeometryFormulasScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  static const List<NavOpData> _geometryNavItems = [
    NavOpData(
      label: 'Pecahan',
      assetPath: 'assets/ic_cal_advance/ic_pecahan2.png',
      route: '/rumus/geometri/pecahan',
    ),
    NavOpData(
      label: 'Pangkat',
      assetPath: 'assets/ic_cal_advance/ic_pangkat2.png',
      route: '/rumus/geometri/pangkat',
    ),
    NavOpData(
      label: 'Konversi Persen',
      assetPath: 'assets/ic_cal_advance/ic_persen.png',
      route: '/rumus/geometri/konversi-persen',
    ),
    NavOpData(
      label: 'Peluang',
      assetPath: 'assets/ic_cal_advance/ic_peluang.png',
      route: '/rumus/umum1/peluang',
    ),
    NavOpData(
      label: 'Aljabar',
      assetPath: 'assets/ic_cal_advance/ic_aljabar.png',
      route: '/rumus/anak/aljabar',
    ),
    NavOpData(
      label: 'Statistika',
      assetPath: 'assets/ic_cal_advance/ic_statistika.png',
      route: '/rumus/umum1/statistika',
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
          // Fixed Top Header Banner & Category Selector Bar
          RumusHeader(
            title: ' Matematika Tingkat Lanjut',
            activeOpIndex: _currentIndex,
            showNav: true,
            onOpTabSelected: _onTabSelected,
            navItems: _geometryNavItems,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
