import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../logic/calculator_logic.dart';

/// Screen Kalkulator Anak sesuai desain UI.
class KalkulatorAnakScreen extends StatefulWidget {
  const KalkulatorAnakScreen({super.key});

  @override
  State<KalkulatorAnakScreen> createState() => _KalkulatorAnakScreenState();
}

class _KalkulatorAnakScreenState extends State<KalkulatorAnakScreen>
    with TickerProviderStateMixin {
  String _expression = '';
  String _result = '';
  bool _isError = false;
  bool _justEvaluated = false;

  // Star-burst animation
  late final AnimationController _starCtrl;
  late final Animation<double> _starAnim;
  bool _showStars = false;

  // Shake animation for error
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();

    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _starAnim = CurvedAnimation(parent: _starCtrl, curve: Curves.easeOut);
    _starCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) setState(() => _showStars = false);
        _starCtrl.reset();
      }
    });

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _starCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Logika Tombol
  // ---------------------------------------------------------------------------

  void _onButton(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_justEvaluated && RegExp(r'\d').hasMatch(value)) {
        _expression = value;
        _result = '';
        _isError = false;
        _justEvaluated = false;
        return;
      }
      _justEvaluated = false;

      // Reset total
      if (value == 'AC' || value == 'C') {
        _expression = '';
        _result = '';
        _isError = false;
        return;
      }

      // Hapus satu karakter
      if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
          _isError = false;
          _updateLiveResult();
        }
        return;
      }

      // Tombol koma
      if (value == ',') {
        if (canAppendToken(_expression, '.')) {
          _expression += '.';
          _isError = false;
          _updateLiveResult();
        }
        return;
      }

      // Tombol 00
      if (value == '00') {
        if (_expression.isNotEmpty && canAppendToken(_expression, '0')) {
          _expression += '00';
          _isError = false;
          _updateLiveResult();
        }
        return;
      }

      // Tombol Samadengan
      if (value == '=') {
        _evaluate();
        return;
      }

      // Token operator & angka reguler
      if (canAppendToken(_expression, value)) {
        _expression += value;
        _isError = false;
        _updateLiveResult();
      }
    });
  }

  void _updateLiveResult() {
    final r = evaluateExpression(_expression);
    if (r is CalcSuccess) {
      _result = r.display;
      _isError = false;
    } else {
      _result = '';
    }
  }

  void _evaluate() {
    if (_expression.isEmpty) return;
    final r = evaluateExpression(_expression);
    if (r is CalcSuccess) {
      setState(() {
        _result = r.display;
        _isError = false;
        _justEvaluated = true;
        _showStars = true;
      });
      _starCtrl.forward();
    } else if (r is CalcError) {
      setState(() {
        _result = (r).message;
        _isError = true;
        _justEvaluated = false;
      });
      _shakeCtrl.forward(from: 0);
    }
  }

  // ---------------------------------------------------------------------------
  // Tampilan Layar (Build)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDCB35), // Warna kuning cerah dasar kalkulator
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: 35), // Ruang ekstra untuk kepala kucing di atas
                SizedBox(
                  height: 180, // <-- ATUR TINGGI KOTAK DI SINI (misal: 160 - 190)
                  child: _buildDisplayWithMascot(),
                ),
                const Spacer(), // Mendorong tombol-tombol agar tetap rapi di bagian bawah layar
                _buildButtonGrid(),
              ],
            ),
          ),

          // Star-burst overlay
          if (_showStars)
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _starAnim,
                builder: (context, _) => CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _StarBurstPainter(_starAnim.value),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Toggle Dark/Light Mode Pill Button
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3AF00),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wb_sunny_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.nightlight_round,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),

          // History Icon
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.history_rounded,
              color: Colors.black87,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayWithMascot() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Maskot Kucing Baca Buku ─────────────────────────────
            Positioned(
              top: -55, // Mengatur agar kepala kucing muncul di atas kotak kuning
              left: 28,
              child: Image.asset(
                'assets/membaca_buku_belajar_1.png', // TODO: ISI PATH ASSET MASKOT KUCING BACA DI SINI
                height: 55,
                fit: BoxFit.contain,
              ),
            ),

            // ── Layar Kotak Display Kuning ──────────────────────────
            Positioned.fill(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedBuilder(
                  animation: _shakeAnim,
                  builder: (context, child) {
                    final shake = math.sin(_shakeAnim.value * math.pi * 6) *
                        (_isError ? 10 * (1 - _shakeAnim.value) : 0);
                    return Transform.translate(
                      offset: Offset(shake, 0),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5B800), // Kuning kotak display
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ekspresi perhitungan
                        FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _expression.isEmpty ? '0' : _expression,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Hasil / Error
                        Text(
                          _result.isEmpty
                              ? ''
                              : (_isError ? _result : _result),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _isError
                                ? Colors.red.shade900
                                : const Color(0xFF6B587B), // Ungu/abu-abu lembut sesuai gambar
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtonGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          _buildRow(['⤢', 'AC', '⌫', '÷'], [
            _BtnStyle.green,
            _BtnStyle.green,
            _BtnStyle.green,
            _BtnStyle.orange,
          ]),
          const SizedBox(height: 12),
          _buildRow(['7', '8', '9', '×'], [
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.orange,
          ]),
          const SizedBox(height: 12),
          _buildRow(['4', '5', '6', '-'], [
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.orange,
          ]),
          const SizedBox(height: 12),
          _buildRow(['1', '2', '3', '+'], [
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.orange,
          ]),
          const SizedBox(height: 12),
          _buildRow(['0', '00', ',', '='], [
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.coral, // Tombol samadengan oranye coral/salmon
          ]),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> labels, List<_BtnStyle> styles) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(labels.length, (i) {
        return _CalcRoundButton(
          label: labels[i],
          style: styles[i],
          onTap: () => _onButton(labels[i]),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Gaya Tombol Bulat Lingkaran
// ---------------------------------------------------------------------------

enum _BtnStyle { white, green, orange, coral }

class _CalcRoundButton extends StatefulWidget {
  const _CalcRoundButton({
    required this.label,
    required this.style,
    required this.onTap,
  });

  final String label;
  final _BtnStyle style;
  final VoidCallback onTap;

  @override
  State<_CalcRoundButton> createState() => _CalcRoundButtonState();
}

class _CalcRoundButtonState extends State<_CalcRoundButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0.90,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color get _bgColor {
    switch (widget.style) {
      case _BtnStyle.white:
        return const Color(0xFFFAFAFA);
      case _BtnStyle.green:
        return const Color(0xFF28C734);
      case _BtnStyle.orange:
        return const Color(0xFFFB9403);
      case _BtnStyle.coral:
        return const Color(0xFFFF6F37);
    }
  }

  Color get _textColor {
    switch (widget.style) {
      case _BtnStyle.white:
        return Colors.black;
      default:
        return Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tombol responsif berbentuk lingkaran sempurna
    final size = (MediaQuery.of(context).size.width - 32 - 36) / 4;

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
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _bgColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: _buildLabel(),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    if (widget.label == '⌫') {
      return const Icon(Icons.backspace_outlined, color: Colors.black87, size: 26);
    }
    if (widget.label == '⤢') {
      return const Icon(Icons.open_in_full_rounded, color: Colors.black87, size: 24);
    }
    return Text(
      widget.label,
      style: TextStyle(
        fontSize: widget.label.length > 1 ? 24 : 30,
        color: _textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Animasi Confetti Bintang
// ---------------------------------------------------------------------------

class _StarBurstPainter extends CustomPainter {
  _StarBurstPainter(this.progress);
  final double progress;

  static final _rng = math.Random(42);
  static final List<_Particle> _particles = List.generate(
    40,
    (_) => _Particle(
      angle: _rng.nextDouble() * 2 * math.pi,
      speed: 300 + _rng.nextDouble() * 400,
      color: _kColors[_rng.nextInt(_kColors.length)],
      size: 8 + _rng.nextDouble() * 10,
      rotationSpeed: (_rng.nextDouble() - 0.5) * 6,
    ),
  );

  static const _kColors = [
    Color(0xFFFFD700),
    Color(0xFFFF4081),
    Color(0xFF40C4FF),
    Color(0xFF69F0AE),
    Color(0xFFFF6D00),
    Color(0xFFEA80FC),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.4;
    final fade = (1.0 - progress).clamp(0.0, 1.0);

    for (final p in _particles) {
      final dist = p.speed * progress;
      final dx = cx + math.cos(p.angle) * dist;
      final dy = cy + math.sin(p.angle) * dist + 200 * progress * progress;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(p.rotationSpeed * progress * math.pi);

      final paint = Paint()
        ..color = p.color.withValues(alpha: fade)
        ..style = PaintingStyle.fill;

      _drawStar(canvas, paint, p.size * (1 - progress * 0.3));
      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double size) {
    final path = Path();
    const points = 5;
    const innerRatio = 0.45;
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? size : size * innerRatio;
      final a = (i * math.pi / points) - math.pi / 2;
      final x = r * math.cos(a);
      final y = r * math.sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarBurstPainter old) => old.progress != progress;
}

class _Particle {
  const _Particle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
    required this.rotationSpeed,
  });
  final double angle;
  final double speed;
  final Color color;
  final double size;
  final double rotationSpeed;
}