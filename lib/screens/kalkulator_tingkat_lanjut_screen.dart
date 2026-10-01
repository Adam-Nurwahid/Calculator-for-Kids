import 'package:calculator_kids/screens/square_root_calculator_screen.dart';
import 'package:calculator_kids/screens/trigonometry_calculator_screen.dart';
import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'deg_rad_calculator_screen.dart';
import 'fraction_calculator_screen.dart';
import 'logarithm_calculator_screen.dart';
import 'power_calculator_screen.dart';
import 'percent_conversion_screen.dart';

class KalkulatorTingkatLanjutScreen extends StatefulWidget {
  const KalkulatorTingkatLanjutScreen({super.key});

  @override
  State<KalkulatorTingkatLanjutScreen> createState() =>
      _KalkulatorTingkatLanjutScreenState();
}

class _KalkulatorTingkatLanjutScreenState
    extends State<KalkulatorTingkatLanjutScreen> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDark ? const Color(0xFF121212) : const Color(0xFFFFFBE7);
    final textTitleColor = _isDark ? Colors.white : const Color(0xFF1A1A1A);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;

    final crossAxisCount = isDesktop ? 4 : (isTablet ? 4 : (isLandscape ? 4 : 3));
    final maxContainerWidth = isDesktop ? 800.0 : (isTablet ? 720.0 : double.infinity);

    final items = [
      _AdvancedItem(
        imagePath: 'assets/ic_cal_advance/ic_pecahan.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FractionCalculatorScreen(isDarkInit: _isDark),
            ),
          );
        },
      ),
      _AdvancedItem(
        imagePath: 'assets/ic_cal_advance/ic_pangkat.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PowerCalculatorScreen(isDarkInit: _isDark),
            ),
          );
        },
      ),
      _AdvancedItem(
        imagePath: 'assets/ic_cal_advance/ic_persent.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PercentConversionScreen(isDarkInit: _isDark),
            ),
          );
        },
      ),
      _AdvancedItem(
        imagePath: 'assets/ic_cal_advance/ic_trigonometri.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TrigonometryCalculatorScreen(isDarkInit: _isDark),
            ),
          );
        },
      ),
      _AdvancedItem(
        imagePath: 'assets/ic_cal_advance/ic_logaritma.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LogarithmCalculatorScreen(isDarkInit: _isDark),
            ),
          );
        },
      ),
      _AdvancedItem(
        imagePath: 'assets/ic_cal_advance/ic_akar.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SquareRootCalculatorScreen(isDarkInit: _isDark),
            ),
          );
        },
      ),
      _AdvancedItem(
        imagePath: 'assets/ic_cal_advance/ic_deg_rad.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DegRadCalculatorScreen(isDarkInit: _isDark),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textTitleColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kalkulator Tingkat Lanjut',
          style: TextStyle(
            color: textTitleColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: textTitleColor,
            ),
            onPressed: () => setState(() => _isDark = !_isDark),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContainerWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: isLandscape ? 0.95 : 0.85,
                ),
                itemBuilder: (context, index) {
                  return _AdvancedCard(item: items[index]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdvancedItem {
  final String imagePath;
  final VoidCallback onTap;

  const _AdvancedItem({
    required this.imagePath,
    required this.onTap,
  });
}

class _AdvancedCard extends StatefulWidget {
  final _AdvancedItem item;

  const _AdvancedCard({
    required this.item,
  });

  @override
  State<_AdvancedCard> createState() => _AdvancedCardState();
}

class _AdvancedCardState extends State<_AdvancedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0.93,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _ctrl,
        child: GestureDetector(
          onTapDown: (_) => _ctrl.reverse(),
          onTapUp: (_) {
            _ctrl.forward();
            widget.item.onTap();
          },
          onTapCancel: () => _ctrl.forward(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              widget.item.imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}