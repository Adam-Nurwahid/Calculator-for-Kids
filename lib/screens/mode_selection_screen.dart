import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../utils/responsive.dart';

/// Home screen — shown immediately when the app starts.
/// Lets the child pick between "Rumus" (formula) and "Kalkulator" modes.
class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.isLandscape;
    final isDesktop = context.isDesktop;
    final screenWidth = context.screenWidth;
    final scale = context.scaleFactor;

    return Scaffold(
      backgroundColor: AppColors.screenBg, // #FFFBE7 warm lemon-cream
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // ── 1. Decorative Vectors (Responsive size & position) ───────────
          Positioned(
            top: -20 * scale,
            left: -20 * scale,
            child: IgnorePointer(
              child: Image.asset(
                'assets/vector.png',
                width: (isLandscape ? 120 : 170) * scale,
                height: (isLandscape ? 120 : 170) * scale,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: (isLandscape ? 40 : 80) * scale,
            right: -30 * scale,
            child: IgnorePointer(
              child: Image.asset(
                'assets/vector1.png',
                width: (isLandscape ? 90 : 130) * scale,
                height: (isLandscape ? 90 : 130) * scale,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // ── 2. Main Center Content (Constrained max width on Desktop/Tablet) ──
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContainerWidth(screenWidth).clamp(0.0, 480.0),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isLandscape ? 24 : 36,
                    vertical: isLandscape ? 12 : 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isLandscape ? 10 : 20),
                      // Title
                      Text(
                        'Pilih mode\nbelajar kamu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (isLandscape ? 26 : 34) * (isDesktop ? 0.95 : 1.0),
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                          color: AppColors.textTitle,
                        ),
                      ),
                      SizedBox(height: isLandscape ? 8 : 14),

                      // Subtitle
                      Text(
                        'Pilih fitur sesuai kebutuhanmu!\nTenang, kamu bisa ubah ini kapan saja',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (isLandscape ? 14 : 16) * (isDesktop ? 0.95 : 1.0),
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: isLandscape ? 24 : 38),

                      // Pill buttons
                      _PillButton(
                        label: 'Rumus',
                        onTap: () => Navigator.pushNamed(context, '/rumus'),
                      ),
                      SizedBox(height: isLandscape ? 12 : 16),
                      _PillButton(
                        label: 'Kalkulator',
                        onTap: () => Navigator.pushNamed(context, '/level'),
                      ),

                      // Bottom spacing so content clears cat mascot when scrolled
                      SizedBox(height: isLandscape ? 40 : 100),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── 3. Cat mascot pinned to bottom ───────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Image.asset(
                    'assets/cat_head.png',
                    width: double.infinity,
                    height: isLandscape ? 70 : null,
                    fit: isLandscape ? BoxFit.contain : BoxFit.fitWidth,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Orange pill button with press animation & hover support ──────────────────

class _PillButton extends StatefulWidget {
  const _PillButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      lowerBound: 0.95,
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
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ScaleTransition(
        scale: _ctrl,
        child: GestureDetector(
          onTapDown: (_) => _ctrl.reverse(),
          onTapUp: (_) {
            _ctrl.forward();
            widget.onTap();
          },
          onTapCancel: () => _ctrl.forward(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: _isHovered
                  ? const Color(0xFFFFB03B)
                  : const Color(0xFFFBA023),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isHovered ? 0.18 : 0.10),
                  blurRadius: _isHovered ? 12 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}