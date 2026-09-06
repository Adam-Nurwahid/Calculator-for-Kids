// lib/widgets/rumus_widgets.dart
//
// Shared UI primitives for the "Rumus" (formula learning) feature.
// All Rumus detail pages import from here to stay DRY and visually
// consistent.  No external packages — Flutter SDK only.

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Design tokens
// ---------------------------------------------------------------------------

/// Primary orange used for header cards and accent elements.
const kRumusOrange = Color(0xFFE07B54);

/// Darker orange for shadows / secondary elements.
const kRumusOrangeDark = Color(0xFFBF5A38);

/// Screen background.
const kRumusBg = Color(0xFFF5F5F5);

/// Dark text color.
const kRumusTextDark = Color(0xFF37474F);

/// Muted / subtitle text.
const kRumusTextMuted = Color(0xFF78909C);

/// Tips box background.
const kTipsBg = Color(0xFFFFF8E1);

/// Tips box border.
const kTipsBorder = Color(0xFFFFB300);

/// Formula card background.
const kFormulaBg = Color(0xFFE3F2FD);

/// Formula card border.
const kFormulaBorder = Color(0xFF1E88E5);

/// Section divider.
const kDivider = Color(0xFFE0E0E0);

// ---------------------------------------------------------------------------
// RumusScaffold — page wrapper with orange header card
// ---------------------------------------------------------------------------

/// A full-page scaffold used by every Rumus detail screen.
///
/// Shows an orange rounded header containing [mascotEmoji], [tierLabel], and
/// [topicTitle].  The [body] scrolls underneath.
class RumusScaffold extends StatelessWidget {
  const RumusScaffold({
    super.key,
    required this.tierLabel,
    required this.topicTitle,
    this.mascotEmoji = '📚',
    required this.body,
    this.headerExtra,
  });

  /// e.g. "Matematika Tingkat Dasar"
  final String tierLabel;

  /// e.g. "Penjumlahan"
  final String topicTitle;

  /// Emoji shown at top of orange header.
  final String mascotEmoji;

  /// Content scrolled below the header.
  final Widget body;

  /// Optional widget injected at bottom of header (e.g. OperatorTabRow).
  final Widget? headerExtra;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kRumusBg,
      body: Column(
        children: [
          // ── Orange header card ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: kRumusOrange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Mascot + tier label row
                Row(
                  children: [
                    Text(mascotEmoji,
                        style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tierLabel,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontFamily: 'Fredoka One',
                            ),
                          ),
                          Text(
                            topicTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontFamily: 'Fredoka One',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (headerExtra != null) ...[
                  const SizedBox(height: 16),
                  headerExtra!,
                ],
              ],
            ),
          ),
          // ── Scrollable body ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OperatorTabRow — 4 operator icon shortcuts (arithmetic pages only)
// ---------------------------------------------------------------------------

/// A row of 4 pill-shaped operator shortcut buttons.
/// Only used on arithmetic detail pages (Penjumlahan, Pengurangan, etc.).
class OperatorTabRow extends StatelessWidget {
  const OperatorTabRow({
    super.key,
    required this.operators,
    required this.routes,
  });

  /// Display labels, e.g. ['+', '−', '×', '÷']
  final List<String> operators;

  /// Corresponding named routes to push.
  final List<String> routes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(operators.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _OperatorTab(
            label: operators[i],
            onTap: () {
              // Replace current route to avoid deep stack for operator tabs
              Navigator.pushReplacementNamed(context, routes[i]);
            },
          ),
        );
      }),
    );
  }
}

class _OperatorTab extends StatefulWidget {
  const _OperatorTab({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_OperatorTab> createState() => _OperatorTabState();
}

class _OperatorTabState extends State<_OperatorTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.9,
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
          width: 52,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Fredoka One',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MateriPillButton — pill button for topic list in the menu
// ---------------------------------------------------------------------------

/// White pill-shaped button with an emoji icon, label, and chevron arrow.
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

// ---------------------------------------------------------------------------
// PageDots — pagination indicator
// ---------------------------------------------------------------------------

/// Animated pagination dots showing current page out of [total].
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

// ---------------------------------------------------------------------------
// NavArrows — left/right navigation arrows
// ---------------------------------------------------------------------------

/// A row with a left arrow, optional center widget, and right arrow.
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
        if (center != null) center!,
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

// ---------------------------------------------------------------------------
// SectionTitle
// ---------------------------------------------------------------------------

/// Bold section heading used inside detail pages.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Fredoka One',
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: kRumusTextDark,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SifatItem — numbered property list item
// ---------------------------------------------------------------------------

/// A single entry in the "Sifat" (properties) numbered list.
class SifatItem extends StatelessWidget {
  const SifatItem({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    this.example,
  });

  final int number;
  final String title;
  final String description;

  /// Optional short worked example shown in a light grey box.
  final String? example;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 2, right: 10),
            decoration: const BoxDecoration(
              color: kRumusOrange,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kRumusTextDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: kRumusTextMuted,
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
                        fontSize: 14,
                        color: kRumusTextDark,
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

// ---------------------------------------------------------------------------
// ContohBox — worked example container
// ---------------------------------------------------------------------------

/// A white card that presents a worked numeric example.
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

// ---------------------------------------------------------------------------
// FormulaCard — highlighted formula display
// ---------------------------------------------------------------------------

/// A blue-tinted card for displaying a named formula.
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

// ---------------------------------------------------------------------------
// TipsBox — amber "Tips" section
// ---------------------------------------------------------------------------

/// An amber-bordered tips box shown at the bottom of detail pages.
class TipsBox extends StatelessWidget {
  const TipsBox({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kTipsBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kTipsBorder, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tips!',
                  style: TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF57F17),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6D4C41),
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

// ---------------------------------------------------------------------------
// ShapeCard — shape name + illustration + formula cards (Bangun Datar/Ruang)
// ---------------------------------------------------------------------------

/// A white card presenting one geometric shape with an illustration and formulas.
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
          // Name badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          // Illustration centered
          Center(child: illustration),
          const SizedBox(height: 12),
          ...formulas,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// VerticalCalcExample — vertical arithmetic layout
// ---------------------------------------------------------------------------

/// Displays a vertical arithmetic example (e.g. column addition/subtraction).
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
    const numStyle = TextStyle(
      fontFamily: 'Fredoka One',
      fontSize: 24,
      color: kRumusTextDark,
    );
    const lineStyle = TextStyle(
      fontFamily: 'Fredoka One',
      fontSize: 24,
      color: kRumusOrange,
    );

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(top, style: numStyle),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$operator  ', style: lineStyle),
              Text(bottom, style: numStyle),
            ],
          ),
          Container(
            width: 80,
            height: 2,
            color: kRumusTextDark,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
          Text(result,
              style: numStyle.copyWith(
                color: const Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// RumusTopicDefinition — topic title + one-line definition
// ---------------------------------------------------------------------------

/// Shows the topic emoji, title, and a short one-line definition.
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

// ---------------------------------------------------------------------------
// InfoRow — simple key: value row
// ---------------------------------------------------------------------------

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
