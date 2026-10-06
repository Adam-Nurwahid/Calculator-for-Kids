import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/calculator_logic.dart';
import '../utils/responsive.dart';
import '../widgets/calc_responsive_container.dart';

/// Screen Kalkulator Anak — fully responsive for phones, tablets, and desktop/web.
class KalkulatorAnakScreen extends StatefulWidget {
  const KalkulatorAnakScreen({super.key});

  @override
  State<KalkulatorAnakScreen> createState() => _KalkulatorAnakScreenState();
}

/// Immutable snapshot of everything the display needs.
///
/// Value equality lets [ValueNotifier] skip notifications when nothing visible
/// changed, so a keypress rebuilds only the display — not the whole screen.
@immutable
class _CalcState {
  const _CalcState({
    this.expression = '',
    this.result = '',
    this.isError = false,
  });

  final String expression;
  final String result;
  final bool isError;

  @override
  bool operator ==(Object other) =>
      other is _CalcState &&
      other.expression == expression &&
      other.result == result &&
      other.isError == isError;

  @override
  int get hashCode => Object.hash(expression, result, isError);
}

/// True if [s] contains at least one ASCII digit (replaces a per-keypress RegExp).
bool _containsDigit(String s) {
  for (var i = 0; i < s.length; i++) {
    final c = s.codeUnitAt(i);
    if (c >= 0x30 && c <= 0x39) return true;
  }
  return false;
}

class _KalkulatorAnakScreenState extends State<KalkulatorAnakScreen>
    with TickerProviderStateMixin {
  String _expression = '';
  String _result = '';
  bool _isError = false;
  bool _justEvaluated = false;

  /// Only the display listens to this. The button grid is built once per
  /// layout change and is NOT rebuilt on keypresses.
  final ValueNotifier<_CalcState> _calc = ValueNotifier(const _CalcState());

  // Star-burst animation (repaints via the painter's `repaint:` listenable,
  // no setState / widget rebuild involved)
  late final AnimationController _starCtrl;
  late final Animation<double> _starAnim;
  late final _StarBurstPainter _starPainter = _StarBurstPainter(_starAnim);

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
      if (status == AnimationStatus.completed) _starCtrl.reset();
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
    _calc.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Logika Tombol
  // ---------------------------------------------------------------------------

  void _onButton(String value) {
    HapticFeedback.lightImpact();
    _handleInput(value);
    _calc.value = _CalcState(
      expression: _expression,
      result: _result,
      isError: _isError,
    );
  }

  void _handleInput(String value) {
    if (_justEvaluated && _containsDigit(value)) {
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
      _result = r.display;
      _isError = false;
      _justEvaluated = true;
      _starCtrl.forward(from: 0);
    } else if (r is CalcError) {
      _result = r.message;
      _isError = true;
      _justEvaluated = false;
      _shakeCtrl.forward(from: 0);
    }
  }

  // ---------------------------------------------------------------------------
  // Tampilan Layar (Responsive Build)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.isLandscape;

    return Scaffold(
      backgroundColor: const Color(0xFFFDCB35), // Warna kuning cerah dasar kalkulator
      body: CalcResponsiveContainer(
        backgroundColor: const Color(0xFFFDCB35),
        maxWidth: 480,
        onKeyInput: _onButton,
        child: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompactHeight = constraints.maxHeight < 680;
                  final isCompact = isLandscape || isCompactHeight;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildTopBar(context),
                              SizedBox(height: isCompact ? 8 : 20),
                              SizedBox(
                                height: isCompact ? 130 : 160,
                                child: _buildDisplayWithMascot(compactMode: isCompact),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: isCompact ? 10 : 16),
                            child: _buildButtonGrid(context, compactMode: isCompact),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Star-burst overlay: always mounted, isolated on its own layer,
              // paints nothing while the animation is idle.
              Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: CustomPaint(painter: _starPainter),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black87,
              size: 26,
            ),
          ),

          // Theme pill & title indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Kalkulator SD',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayWithMascot({required bool compactMode}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Maskot Kucing Baca Buku ─────────────────────────────
        Positioned(
          top: compactMode ? -35 : -55,
          left: 24,
          child: Image.asset(
            'assets/membaca_buku_belajar_1.png',
            height: compactMode ? 42 : 55,
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
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: compactMode ? 8 : 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5B800),
                  borderRadius: BorderRadius.circular(22),
                ),
                // Only this subtree rebuilds on each keypress.
                child: ValueListenableBuilder<_CalcState>(
                  valueListenable: _calc,
                  builder: (context, s, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ekspresi perhitungan
                      FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          s.expression.isEmpty ? '0' : s.expression,
                          style: TextStyle(
                            fontSize: compactMode ? 36 : 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: compactMode ? 4 : 8),

                      // Hasil / Error
                      FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          s.result,
                          style: TextStyle(
                            fontSize: compactMode ? 22 : 28,
                            fontWeight: FontWeight.bold,
                            color: s.isError
                                ? Colors.red.shade900
                                : const Color(0xFF6B587B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonGrid(BuildContext context, {required bool compactMode}) {
    final vGap = compactMode ? 6.0 : 10.0;

    // Button diameter is computed ONCE here instead of in a LayoutBuilder
    // inside every one of the 20 buttons (same formula as before).
    final width = Responsive.widthOf(context).clamp(280.0, 480.0);
    final raw = (width - 32 - 36) / 4;
    final size = compactMode ? raw.clamp(42.0, 56.0) : raw.clamp(44.0, 68.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, compactMode ? 12 : 20),
      child: Column(
        children: [
          _buildRow(['⤢', 'AC', '⌫', '÷'], [
            _BtnStyle.green,
            _BtnStyle.green,
            _BtnStyle.green,
            _BtnStyle.orange,
          ], size),
          SizedBox(height: vGap),
          _buildRow(['7', '8', '9', '×'], [
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.orange,
          ], size),
          SizedBox(height: vGap),
          _buildRow(['4', '5', '6', '-'], [
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.orange,
          ], size),
          SizedBox(height: vGap),
          _buildRow(['1', '2', '3', '+'], [
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.orange,
          ], size),
          SizedBox(height: vGap),
          _buildRow(['0', '00', ',', '='], [
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.white,
            _BtnStyle.coral,
          ], size),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> labels, List<_BtnStyle> styles, double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(labels.length, (i) {
        return _CalcRoundButton(
          label: labels[i],
          style: styles[i],
          size: size,
          onTap: () => _onButton(labels[i]),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Tombol Bulat — StatelessWidget, no per-button AnimationController /
// MouseRegion setState. Press + hover feedback comes from InkResponse.
// ---------------------------------------------------------------------------

enum _BtnStyle { white, green, orange, coral }

class _CalcRoundButton extends StatelessWidget {
  const _CalcRoundButton({
    required this.label,
    required this.style,
    required this.size,
    required this.onTap,
  });

  final String label;
  final _BtnStyle style;
  final double size;
  final VoidCallback onTap;

  static const List<BoxShadow> _shadow = [
    BoxShadow(
      color: Color(0x0F000000), // black @ ~6%
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  Color get _bgColor => switch (style) {
        _BtnStyle.white => const Color(0xFFFAFAFA),
        _BtnStyle.green => const Color(0xFF28C734),
        _BtnStyle.orange => const Color(0xFFFB9403),
        _BtnStyle.coral => const Color(0xFFFF6F37),
      };

  Color get _textColor =>
      style == _BtnStyle.white ? Colors.black : Colors.black87;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: _shadow,
        ),
        child: Material(
          color: _bgColor,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkResponse(
            onTap: onTap,
            containedInkWell: true,
            customBorder: const CircleBorder(),
            // InkRipple is cheaper than Material 3's default InkSparkle
            // (which runs a fragment shader) on low-end GPUs.
            splashFactory: InkRipple.splashFactory,
            hoverColor: const Color(0x14000000),
            highlightColor: const Color(0x14000000),
            splashColor: const Color(0x1F000000),
            // Keep keyboard focus on CalcResponsiveContainer's Focus node.
            canRequestFocus: false,
            child: Center(child: _buildLabel()),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    final iconSize = (size * 0.42).clamp(18.0, 26.0);
    final fontBase = (size * 0.46).clamp(18.0, 28.0);

    if (label == '⌫') {
      return Icon(Icons.backspace_outlined, color: Colors.black87, size: iconSize);
    }
    if (label == '⤢') {
      return Icon(Icons.open_in_full_rounded, color: Colors.black87, size: iconSize * 0.9);
    }
    return Text(
      label,
      style: TextStyle(
        fontSize: label.length > 1 ? fontBase * 0.8 : fontBase,
        color: _textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Animasi Confetti Bintang (Unchanged)
// ---------------------------------------------------------------------------

class _StarBurstPainter extends CustomPainter {
  /// Repaints whenever [anim] ticks (no widget rebuild needed).
  _StarBurstPainter(this.anim) : super(repaint: anim);

  final Animation<double> anim;

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

  /// Star of radius 1, built once and scaled per particle with canvas.scale().
  static final Path _unitStar = _buildUnitStar();

  /// One shared Paint instead of 40 allocations per frame.
  static final Paint _paint = Paint()..style = PaintingStyle.fill;

  static Path _buildUnitStar() {
    final path = Path();
    const points = 5;
    const innerRatio = 0.45;
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? 1.0 : innerRatio;
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
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final progress = anim.value;
    if (progress <= 0 || progress >= 1) return; // idle: draw nothing

    final cx = size.width / 2;
    final cy = size.height * 0.4;
    final fade = 1.0 - progress;

    for (final p in _particles) {
      final dist = p.speed * progress;
      final dx = cx + math.cos(p.angle) * dist;
      final dy = cy + math.sin(p.angle) * dist + 200 * progress * progress;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(p.rotationSpeed * progress * math.pi);
      canvas.scale(p.size * (1 - progress * 0.3));
      _paint.color = p.color.withValues(alpha: fade);
      canvas.drawPath(_unitStar, _paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_StarBurstPainter old) => old.anim != anim;
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