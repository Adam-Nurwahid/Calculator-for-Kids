import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Home screen — shown immediately when the app starts.
/// Lets the child pick between "Rumus" (formula) and "Kalkulator" modes.
class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg, // #FFFBE7 warm lemon-cream
      body: Stack(
        clipBehavior: Clip.hardEdge, // Memotong vector yang keluar layar
        children: [
          // ── 1. Vector Biru Kiri Atas ─────────────────────────────
          Positioned(
            top: -30,
            left: -30,
            child: Image.asset(
              'assets/vector.png', // TODO: ISI PATH ASSET VECTOR BIRU KIRI DI SINI
              width: 170,
              height: 170,
              fit: BoxFit.contain,
            ),
          ),

          // ── 2. Vector Biru Kanan Atas / Tengah ───────────────────
          Positioned(
            top: 90,
            right: -45,
            child: Image.asset(
              'assets/vector1.png', // TODO: ISI PATH ASSET VECTOR BIRU KANAN DI SINI
              width: 130,
              height: 130,
              fit: BoxFit.contain,
            ),
          ),

          // ── 3. Main content: Title, Subtitle, & Buttons ───────────
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      'Pilih mode\nbelajar kamu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: Colors.black, // atau AppColors.textTitle
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Subtitle
                    Text(
                      'Pilih fitur sesuai kebutuhanmu!\nTenang, kamu bisa ubah ini\nkapan saja',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700, // atau AppColors.textDescription
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Pill buttons
                    _PillButton(
                      label: 'Rumus',
                      onTap: () => Navigator.pushNamed(context, '/rumus'),
                    ),
                    const SizedBox(height: 18),
                    _PillButton(
                      label: 'Kalkulator',
                      onTap: () => Navigator.pushNamed(context, '/level'),
                    ),
                    // Beri jarak bawah agar tombol tidak tertutup cat head
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),

          // ── 4. Cat mascot pinned to bottom (Match Parent Horizontal) ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/cat_head.png', // TODO: ISI PATH ASSET CAT HEAD DI SINI
              width: double.infinity,
              fit: BoxFit.fitWidth, // Memastikan gambar memenuhi lebar layar secara penuh
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Orange pill button ───────────────────────────────────────────────────────

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
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFBA023), // Warna oranye cerah sesuai desain
            borderRadius: BorderRadius.circular(28),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Di desain terlihat teks berwarna gelap/bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}