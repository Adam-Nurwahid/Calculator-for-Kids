import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Screen where the child picks a difficulty level: Anak or Umum.
class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.screenBg, // #FFFBE7 warm lemon-cream
      body: Stack(
        children: [
          // ── 1. cat_bg di bagian bawah layar ──────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            // Mengatur ketinggian agar pas dengan proporsi kucing dan cakarnya
            height: screenHeight * 0.65,
            child: Image.asset(
              'assets/cat_bg.png', // TODO: ISI PATH ASSET CAT BG DI SINI
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // ── 2. Konten Foreground (Teks, Tombol, Footer) ─────────────────
          SafeArea(
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

                const SizedBox(height: 16),

                // Judul (Tengah)
                const Center(
                  child: Text(
                    'Kalkulator\nEdukatif',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      color: AppColors.textTitle,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Subjudul (Tengah)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Pilih kategori belajar sesuai\ndengan levelmu!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDescription,
                    ),
                  ),
                ),

                const Spacer(),

                // ── Tombol Anak & Umum (Di antara cakar kucing) ─────────────
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
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
                        const SizedBox(height: 16),
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

                const SizedBox(height: 100),

                // ── Footer Hint ───────────────────────────────────────────
                const Padding(
                  padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
                  child: Text(
                    'Tenang, kamu bisa ubah ini\nkapan saja',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF632B00), // Cokelat tua kontras di atas oranye
                      height: 1.3,
                    ),
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
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBE7), // Warna krem/putih terang sesuai gambar
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
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
    );
  }
}

// ── Back Circle Button ───────────────────────────────────────────────────────

class _BackCircleButton extends StatelessWidget {
  const _BackCircleButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
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
    );
  }
}