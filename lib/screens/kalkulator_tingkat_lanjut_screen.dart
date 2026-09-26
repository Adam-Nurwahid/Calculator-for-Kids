import 'package:calculator_kids/screens/trigonometry_calculator_screen.dart';
import 'package:flutter/material.dart';

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
    final cardBgBase = _isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textTitleColor = _isDark ? Colors.white : const Color(0xFF1A1A1A);

    final items = [
      _AdvancedItem(
        title: 'Pecahan',
        symbol: '1/2',
        pastelBg: _isDark ? const Color(0xFF332005) : const Color(0xFFFFF3E0),
        accentColor: const Color(0xFFFF9800),
        icon: Icons.pie_chart_outline_rounded,
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
        title: 'Pangkat',
        symbol: 'xʸ',
        pastelBg: _isDark ? const Color(0xFF281033) : const Color(0xFFF3E5F5),
        accentColor: const Color(0xFFAB47BC),
        icon: Icons.superscript_rounded,
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
        title: 'Konversi Persen',
        symbol: '%',
        pastelBg: _isDark ? const Color(0xFF0D2533) : const Color(0xFFE1F5FE),
        accentColor: const Color(0xFF29B6F6),
        icon: Icons.percent_rounded,
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
        title: 'Trigonometri',
        symbol: 'sin',
        pastelBg: _isDark ? const Color(0xFF330C19) : const Color(0xFFFCE4EC),
        accentColor: const Color(0xFFEC407A),
        icon: Icons.waves_rounded,
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
        title: 'Logaritma',
        symbol: 'log',
        pastelBg: _isDark ? const Color(0xFF331010) : const Color(0xFFFFEBEE),
        accentColor: const Color(0xFFEF5350),
        icon: Icons.functions_rounded,
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
        title: 'Akar Kuadrat',
        symbol: '√',
        pastelBg: _isDark ? const Color(0xFF111733) : const Color(0xFFE8EAF6),
        accentColor: const Color(0xFF5C6BC0),
        icon: Icons.square_foot_rounded,
        onTap: () => _showComingSoon('Akar Kuadrat'),
      ),
      _AdvancedItem(
        title: 'DEG / RAD',
        symbol: 'π°',
        pastelBg: _isDark ? const Color(0xFF09282C) : const Color(0xFFE0F7FA),
        accentColor: const Color(0xFF26C6DA),
        icon: Icons.rotate_right_rounded,
        onTap: () => _showComingSoon('DEG / RAD'),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _AdvancedCard(
                item: item,
                cardBg: cardBgBase,
                textColor: textTitleColor,
              );
            },
          ),
        ),
      ),
    );
  }

  void _showComingSoon(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur $name akan segera hadir!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _AdvancedItem {
  final String title;
  final String symbol;
  final Color pastelBg;
  final Color accentColor;
  final IconData icon;
  final VoidCallback onTap;

  const _AdvancedItem({
    required this.title,
    required this.symbol,
    required this.pastelBg,
    required this.accentColor,
    required this.icon,
    required this.onTap,
  });
}

class _AdvancedCard extends StatefulWidget {
  final _AdvancedItem item;
  final Color cardBg;
  final Color textColor;

  const _AdvancedCard({
    required this.item,
    required this.cardBg,
    required this.textColor,
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
    return ScaleTransition(
      scale: _ctrl,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.reverse(),
        onTapUp: (_) {
          _ctrl.forward();
          widget.item.onTap();
        },
        onTapCancel: () => _ctrl.forward(),
        child: Container(
          decoration: BoxDecoration(
            color: widget.item.pastelBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.item.accentColor.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: widget.item.accentColor.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge / Symbol Box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.item.accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.item.symbol,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: widget.item.accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
