// lib/screens/rumus/detail/geometri/geometry_formulas_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/rumus_widgets.dart';
import '../anak/bangun_datar_screen.dart';
import '../umum2/bangun_ruang_screen.dart';
import '../umum1/pecahan_screen.dart';
import '../umum1/pangkat_screen.dart';
import '../umum1/konversi_persen_screen.dart';
import '../umum2/akar_kuadrat_screen.dart';

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
      label: 'Bangun Datar',
      icon: Icons.crop_square_rounded,
      color: Color(0xFF00BCD4),
      route: '/rumus/geometri/bangun-datar',
    ),
    NavOpData(
      label: 'Bangun Ruang',
      icon: Icons.view_in_ar,
      color: Color(0xFFFF7043),
      route: '/rumus/geometri/bangun-ruang',
    ),
    NavOpData(
      label: 'Pecahan',
      symbol: '½',
      color: Color(0xFF4A9FE8),
      route: '/rumus/geometri/pecahan',
    ),
    NavOpData(
      label: 'Pangkat',
      symbol: 'xʸ',
      color: Color(0xFFFF5252),
      route: '/rumus/geometri/pangkat',
    ),
    NavOpData(
      label: 'Konversi Persen',
      symbol: '%',
      color: Color(0xFFD05CE3),
      route: '/rumus/geometri/konversi-persen',
    ),
    NavOpData(
      label: 'Akar Kuadrat',
      symbol: '√x',
      color: Color(0xFF00BFA5),
      route: '/rumus/geometri/akar-kuadrat',
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
            title: 'Geometri &\nMatematika Menengah',
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
                BangunDatarScreen(),
                BangunRuangScreen(),
                PecahanScreen(),
                PangkatScreen(),
                KonversiPersenScreen(),
                AkarKuadratScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
