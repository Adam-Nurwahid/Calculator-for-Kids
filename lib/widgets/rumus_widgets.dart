// lib/widgets/rumus_widgets.dart
//
// Shared UI primitives and redesigned widgets for the "Rumus" (formula learning) feature.
// All Rumus detail pages import from here to stay DRY and visually consistent.

import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Design Tokens
// ---------------------------------------------------------------------------

const kRumusOrange = AppColors.rumusHeaderBg;
const kRumusOrangeDark = AppColors.accentOrangeDark;
const kRumusBg = AppColors.screenBg;
const kRumusTextDark = AppColors.textTitle;
const kRumusTextMuted = AppColors.textDescription;
const kTipsBg = Color(0xFFFFFBE7);
const kTipsBorder = Colors.black87;
const kFormulaBg = Color(0xFFE3F2FD);
const kFormulaBorder = Color(0xFF1E88E5);
const kDivider = AppColors.tipBoxBorder;

// ---------------------------------------------------------------------------
// Top Header Banner & Navigation Bar (RumusHeader)
// ---------------------------------------------------------------------------

class NavOpData {
  const NavOpData({
    required this.label,
    required this.symbol,
    required this.color,
    required this.route,
  });

  final String label;
  final String symbol;
  final Color color;
  final String route;
}

/// Top Header Banner + Quick-Navigation Category Bar.
class RumusHeader extends StatefulWidget {
  const RumusHeader({
    super.key,
    this.title = 'Matematika Tingkat\nDasar',
    this.activeOpIndex,
    this.showNav = true,
    this.onOpTabSelected,
    this.navItems,
  });

  final String title;
  final int? activeOpIndex;
  final bool showNav;
  final ValueChanged<int>? onOpTabSelected;
  final List<NavOpData>? navItems;

  static const List<NavOpData> _defaultNavItems = [
    NavOpData(
      label: 'Penjumlahan',
      symbol: '+',
      color: AppColors.rumusAddColor,
      route: '/rumus/anak/penjumlahan',
    ),
    NavOpData(
      label: 'Pengurangan',
      symbol: '−',
      color: AppColors.rumusSubColor,
      route: '/rumus/anak/pengurangan',
    ),
    NavOpData(
      label: 'Perkalian',
      symbol: '×',
      color: AppColors.rumusMulColor,
      route: '/rumus/anak/perkalian',
    ),
    NavOpData(
      label: 'Pembagian',
      symbol: '÷',
      color: AppColors.rumusDivColor,
      route: '/rumus/anak/pembagian',
    ),
    NavOpData(
      label: 'Tanda Kurung',
      symbol: '( )',
      color: AppColors.rumusBracketColor,
      route: '/rumus/anak/tanda-kurung',
    ),
    NavOpData(
      label: 'Bangun Datar',
      symbol: '📐',
      color: AppColors.rumusShapesColor,
      route: '/rumus/anak/bangun-datar',
    ),
  ];

  @override
  State<RumusHeader> createState() => _RumusHeaderState();
}

class _RumusHeaderState extends State<RumusHeader> {
  late final ScrollController _scrollController;

  List<NavOpData> get _items => widget.navItems ?? RumusHeader._defaultNavItems;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToActiveTab();
    });
  }

  @override
  void didUpdateWidget(RumusHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeOpIndex != widget.activeOpIndex) {
      _scrollToActiveTab();
    }
  }

  void _scrollToActiveTab() {
    if (widget.activeOpIndex == null || !_scrollController.hasClients) return;
    const double itemWidth = 72.0;
    final double targetOffset = (widget.activeOpIndex! * itemWidth) - 100;
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double clampedOffset = targetOffset.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Header Banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            left: 20,
            right: 20,
            bottom: widget.showNav ? 28 : 20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.rumusHeaderBg,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Color(0x20000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black87,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Main Banner Text
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: 'Fredoka One',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        // Horizontal Quick-Navigation Category Bar
        if (widget.showNav)
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.rumusNavBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isActive = index == widget.activeOpIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _NavOpButton(
                        data: item,
                        isActive: isActive,
                        onTap: () {
                          if (widget.onOpTabSelected != null) {
                            widget.onOpTabSelected!(index);
                          } else if (!isActive) {
                            Navigator.pushReplacementNamed(context, item.route);
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _NavOpButton extends StatelessWidget {
  const _NavOpButton({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  final NavOpData data;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(16),
              border: isActive
                  ? Border.all(color: Colors.white, width: 2.5)
                  : Border.all(color: Colors.transparent, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: data.color.withValues(alpha: isActive ? 0.6 : 0.3),
                  blurRadius: isActive ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    data.symbol,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: data.symbol.length > 2 ? 18 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen Title & Subtitle (RumusTopicHeader)
// ---------------------------------------------------------------------------

class RumusTopicHeader extends StatelessWidget {
  const RumusTopicHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Fredoka One',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF666666),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Numbered Rules / Characteristics (NumberedPropertyItem / SifatItem)
// ---------------------------------------------------------------------------

class NumberedPropertyItem extends StatelessWidget {
  const NumberedPropertyItem({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    this.example,
  });

  final int number;
  final String title;
  final String description;
  final String? example;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amber/Orange Circular Badge (#FCA33B)
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 2, right: 12),
            decoration: const BoxDecoration(
              color: AppColors.rumusBadgeOrange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Fredoka One',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
                if (example != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      example!,
                      style: const TextStyle(
                        fontFamily: 'Fredoka One',
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Backward compatibility alias for SifatItem
typedef SifatItem = NumberedPropertyItem;

// ---------------------------------------------------------------------------
// Math Calculation Displays
// ---------------------------------------------------------------------------

/// Stacked vertical arithmetic display (+ - ×)
class VerticalMathCalculation extends StatelessWidget {
  const VerticalMathCalculation({
    super.key,
    required this.topNumber,
    required this.bottomNumber,
    required this.operator,
    required this.resultNumber,
    this.note,
  });

  final String topNumber;
  final String bottomNumber;
  final String operator;
  final String resultNumber;
  final String? note;

  @override
  Widget build(BuildContext context) {
    const styleNum = TextStyle(
      fontFamily: 'Fredoka One',
      fontSize: 26,
      letterSpacing: 2,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(topNumber, style: styleNum),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$operator  ',
                        style: const TextStyle(
                          fontFamily: 'Fredoka One',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.rumusHeaderBg,
                        ),
                      ),
                      Text(bottomNumber, style: styleNum),
                    ],
                  ),
                  Container(
                    width: 110,
                    height: 2.5,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.black87,
                  ),
                  Text(
                    resultNumber,
                    style: styleNum.copyWith(
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 10),
            Text(
              note!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Backward compatibility alias for VerticalCalcExample
class VerticalCalcExample extends StatelessWidget {
  const VerticalCalcExample({
    super.key,
    required this.top,
    required this.operator,
    required this.bottom,
    required this.result,
  });

  final String top;
  final String operator;
  final String bottom;
  final String result;

  @override
  Widget build(BuildContext context) {
    return VerticalMathCalculation(
      topNumber: top,
      bottomNumber: bottom,
      operator: operator,
      resultNumber: result,
    );
  }
}

/// Division step-by-step layout
class DivisionStepWidget extends StatelessWidget {
  const DivisionStepWidget({
    super.key,
    required this.dividend,
    required this.divisor,
    required this.quotient,
    required this.steps,
  });

  final String dividend;
  final String divisor;
  final String quotient;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$dividend ÷ $divisor = $quotient',
            style: const TextStyle(
              fontFamily: 'Fredoka One',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Langkah-langkah Porogapit:',
            style: TextStyle(
              fontFamily: 'Fredoka One',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(steps.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.rumusBadgeOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Fredoka One',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Bracket evaluation step-by-step layout
class BracketStepWidget extends StatelessWidget {
  const BracketStepWidget({
    super.key,
    required this.expression,
    required this.steps,
  });

  final String expression;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expression,
            style: const TextStyle(
              fontFamily: 'Fredoka One',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.rumusHeaderBg,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (index) {
            final isLast = index == steps.length - 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.arrow_right_rounded,
                      color: AppColors.rumusHeaderBg, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontFamily: 'Fredoka One',
                      fontSize: isLast ? 18 : 15,
                      color: isLast ? const Color(0xFF2E7D32) : Colors.black87,
                      fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom Tips Card (RumusTipsCard)
// ---------------------------------------------------------------------------

class RumusTipsCard extends StatelessWidget {
  const RumusTipsCard({
    super.key,
    required this.tipText,
    this.title = 'Tips:',
  });

  final String tipText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBE7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black87, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Fredoka One',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            tipText,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Backward compatibility alias for TipsBox
class TipsBox extends StatelessWidget {
  const TipsBox({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return RumusTipsCard(tipText: text);
  }
}

// ---------------------------------------------------------------------------
// RumusScaffold Wrapper
// ---------------------------------------------------------------------------

class RumusScaffold extends StatelessWidget {
  const RumusScaffold({
    super.key,
    required this.tierLabel,
    required this.topicTitle,
    this.mascotEmoji = '📚',
    required this.body,
    this.headerExtra,
    this.activeOpIndex,
    this.showOpNav = false,
  });

  final String tierLabel;
  final String topicTitle;
  final String mascotEmoji;
  final Widget body;
  final Widget? headerExtra;
  final int? activeOpIndex;
  final bool showOpNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kRumusBg,
      body: Column(
        children: [
          if (showOpNav || headerExtra != null)
            RumusHeader(
              title: tierLabel,
              activeOpIndex: activeOpIndex,
              showNav: true,
            )
          else
            // Fallback Header for non-operator screens (or custom tier)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                color: AppColors.rumusHeaderBg,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.black87,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tierLabel,
                    style: const TextStyle(
                      fontFamily: 'Fredoka One',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Other Shared Components
// ---------------------------------------------------------------------------

class OperatorTabRow extends StatelessWidget {
  const OperatorTabRow({
    super.key,
    required this.operators,
    required this.routes,
  });

  final List<String> operators;
  final List<String> routes;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class MateriPillButton extends StatefulWidget {
  const MateriPillButton({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  State<MateriPillButton> createState() => _MateriPillButtonState();
}

class _MateriPillButtonState extends State<MateriPillButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
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
          widget.onTap();
        },
        onTapCancel: () => _ctrl.forward(),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: kRumusTextDark,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: kRumusOrange,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? kRumusOrange : kRumusOrange.withValues(alpha: 0.30),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class NavArrows extends StatelessWidget {
  const NavArrows({
    super.key,
    required this.onLeft,
    required this.onRight,
    this.leftEnabled = true,
    this.rightEnabled = true,
    this.center,
  });

  final VoidCallback onLeft;
  final VoidCallback onRight;
  final bool leftEnabled;
  final bool rightEnabled;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ArrowButton(
          icon: Icons.arrow_back_ios_rounded,
          enabled: leftEnabled,
          onTap: onLeft,
        ),
        ?center,
        _ArrowButton(
          icon: Icons.arrow_forward_ios_rounded,
          enabled: rightEnabled,
          onTap: onRight,
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled ? kRumusOrange : kRumusOrange.withValues(alpha: 0.30),
          shape: BoxShape.circle,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: kRumusOrangeDark.withValues(alpha: 0.30),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Fredoka One',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class ContohBox extends StatelessWidget {
  const ContohBox({super.key, required this.title, required this.content});
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✏️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Fredoka One',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kRumusOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}

class FormulaCard extends StatelessWidget {
  const FormulaCard({
    super.key,
    required this.label,
    required this.formula,
  });

  final String label;
  final String formula;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kFormulaBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kFormulaBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: kFormulaBorder,
              fontFamily: 'Fredoka One',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formula,
            style: const TextStyle(
              fontFamily: 'Fredoka One',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kRumusTextDark,
            ),
          ),
        ],
      ),
    );
  }
}

class ShapeCard extends StatelessWidget {
  const ShapeCard({
    super.key,
    required this.name,
    required this.definition,
    required this.illustration,
    required this.formulas,
  });

  final String name;
  final String definition;
  final Widget illustration;
  final List<FormulaCard> formulas;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: kRumusOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: 'Fredoka One',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            definition,
            style: const TextStyle(
              fontSize: 13,
              color: kRumusTextMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Center(child: illustration),
          const SizedBox(height: 12),
          ...formulas,
        ],
      ),
    );
  }
}

class RumusTopicDefinition extends StatelessWidget {
  const RumusTopicDefinition({
    super.key,
    required this.emoji,
    required this.title,
    required this.definition,
  });

  final String emoji;
  final String title;
  final String definition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kRumusTextDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  definition,
                  style: const TextStyle(
                    fontSize: 13,
                    color: kRumusTextMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label  ',
            style: const TextStyle(
              color: kRumusTextMuted,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Fredoka One',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: kRumusTextDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
