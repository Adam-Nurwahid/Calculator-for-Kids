import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../utils/responsive.dart';

/// Screen where the child picks a difficulty level: Anak or Umum.
class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;
    final screenWidth = context.screenWidth;
    final isLandscape = context.isLandscape;

    return Scaffold(
      backgroundColor: AppColors.screenBg, // #FFFBE7 warm lemon-cream
      body: Stack(
        children: [
          // ── 1. cat_bg di bagian bawah layar ──────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: isLandscape ? screenHeight * 0.85 : screenHeight * 0.65,
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Image.asset(
                    'assets/cat_bg.png',
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // ── 2. Konten Foreground (Teks, Tombol, Footer) ─────────────────
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContainerWidth(screenWidth).clamp(0.0, 480.0),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Tombol Back (Kiri Atas)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                                  child: _BackCircleButton(
                                    onTap: () => Navigator.pop(context),
                                  ),
                                ),
                              ),

                              SizedBox(height: isLandscape ? 8 : 16),

                              // Judul (Tengah)
                              Text(
                                'Kalkulator\nEdukatif',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isLandscape ? 28 : 34,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2,
                                  color: AppColors.textTitle,
                                ),
                              ),

                              SizedBox(height: isLandscape ? 8 : 12),

                              // Subjudul (Tengah)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  'Pilih kategori belajar sesuai\ndengan levelmu!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isLandscape ? 13 : 15,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDescription,
                                  ),
                                ),
                              ),

                              const Spacer(),
                              SizedBox(height: isLandscape ? 16 : 24),

                              // ── Tombol Anak & Umum ─────────────────────────────
                              Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 240),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _PillButton(
                                        label: 'Anak',
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          '/kalkulator-anak',
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      _PillButton(
                                        label: 'Umum',
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          '/kalkulator-umum',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: isLandscape ? 24 : 60),

                              // ── Footer Hint ───────────────────────────────────────────
                              const Padding(
                                padding: EdgeInsets.only(bottom: 20, left: 24, right: 24),
                                child: Text(
                                  'Tenang, kamu bisa ubah ini\nkapan saja',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF632B00),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tombol Pil Krem / Putih Sesuai Desain ─────────────────────────────────────

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
            height: 52,
            decoration: BoxDecoration(
              color: _isHovered ? Colors.white : const Color(0xFFFFFBE7),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.08),
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
                  fontWeight: FontWeight.w800,
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

// ── Back Circle Button ───────────────────────────────────────────────────────

class _BackCircleButton extends StatefulWidget {
  const _BackCircleButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_BackCircleButton> createState() => _BackCircleButtonState();
}

class _BackCircleButtonState extends State<_BackCircleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.18 : 0.10),
                blurRadius: _isHovered ? 10 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textTitle,
            size: 22,
          ),
        ),
      ),
    );
  }
}