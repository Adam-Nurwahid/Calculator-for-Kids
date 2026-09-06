import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/calculator_logic.dart';

/// The "Kalkulator Anak" (Kids Calculator) screen.
///
/// Features:
/// - Large, colorful, kid-friendly button grid (min 72×72 dp)
/// - Real-time expression display + computed result
/// - Input validation (blocks invalid sequences)
/// - Division-by-zero friendly error message
/// - Star-burst confetti animation on successful calculation
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
  // Button actions
  // ---------------------------------------------------------------------------

  void _onButton(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_justEvaluated && RegExp(r'\d').hasMatch(value)) {
        // Start fresh after a result if user types a number
        _expression = value;
        _result = '';
        _isError = false;
        _justEvaluated = false;
        return;
      }
      _justEvaluated = false;

      if (value == 'C') {
        _expression = '';
        _result = '';
        _isError = false;
        return;
      }

      if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
          _isError = false;
          // Update live result preview
          _updateLiveResult();
        }
        return;
      }

      if (value == '( )') {
        // Smart parenthesis: add '(' if unbalanced, else try ')'
        final opens = '('.allMatches(_expression).length;
        final closes = ')'.allMatches(_expression).length;
        final last = _expression.isEmpty ? '' : _expression[_expression.length - 1];
        if (opens == closes || last == '(' || _isOperator(last)) {
          if (canAppendToken(_expression, '(')) {
            _expression += '(';
          }
        } else {
          if (canAppendToken(_expression, ')')) {
            _expression += ')';
          }
        }
        _isError = false;
        _updateLiveResult();
        return;
      }

      if (value == '=') {
        _evaluate();
        return;
      }

      // Regular token
      if (canAppendToken(_expression, value)) {
        _expression += value;
        _isError = false;
        _updateLiveResult();
      }
    });
  }

  bool _isOperator(String ch) =>
      ch == '+' || ch == '-' || ch == '×' || ch == '÷';

  void _updateLiveResult() {
    // Show a live preview (greyed out) while typing
    final r = evaluateExpression(_expression);
    if (r is CalcSuccess) {
      _result = r.display;
      _isError = false;
    } else {
      // Don't show errors during live typing — just clear preview
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
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Solid background
          Container(
            color: const Color(0xFF263238),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(child: _buildDisplay()),
                _buildButtonGrid(),
              ],
            ),
          ),

          // Star-burst overlay
          if (_showStars)
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _starAnim,
                builder: (context, _) =>
                    CustomPaint(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '🧮 Kalkulator Anak',
            style: TextStyle(
              fontFamily: 'Fredoka One',
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplay() {
    return AnimatedBuilder(
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
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF37474F),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFF455A64),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Mascot hint when empty
            if (_expression.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🐱', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 8),
                      Text(
                        'Tekan angka untuk mulai!',
                        style: TextStyle(
                          color: Color(0xFF90A4AE),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _expression,
                      style: const TextStyle(
                        fontFamily: 'Fredoka One',
                        fontSize: 36,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            // Result / error line
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _result.isEmpty
                  ? const SizedBox(key: ValueKey('empty'), height: 36)
                  : Text(
                      key: ValueKey(_result),
                      _isError ? _result : '= $_result',
                      style: TextStyle(
                        fontFamily: 'Fredoka One',
                        fontSize: _isError ? 18 : 40,
                        color: _isError
                            ? const Color(0xFFFF7043)
                            : const Color(0xFF69F0AE),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Column(
        children: [
          _buildRow(['C', '( )', '⌫', '÷'], [
            _BtnStyle.clear,
            _BtnStyle.special,
            _BtnStyle.backspace,
            _BtnStyle.operator,
          ]),
          const SizedBox(height: 10),
          _buildRow(['7', '8', '9', '×'], [
            _BtnStyle.number,
            _BtnStyle.number,
            _BtnStyle.number,
            _BtnStyle.operator,
          ]),
          const SizedBox(height: 10),
          _buildRow(['4', '5', '6', '−'], [
            _BtnStyle.number,
            _BtnStyle.number,
            _BtnStyle.number,
            _BtnStyle.operator,
          ]),
          const SizedBox(height: 10),
          _buildRow(['1', '2', '3', '+'], [
            _BtnStyle.number,
            _BtnStyle.number,
            _BtnStyle.number,
            _BtnStyle.operator,
          ]),
          const SizedBox(height: 10),
          _buildLastRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> labels, List<_BtnStyle> styles) {
    return Row(
      children: List.generate(labels.length, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 5),
            child: _CalcButton(
              label: labels[i],
              style: styles[i],
              onTap: () => _onButton(
                // Normalize display chars to internal tokens
                labels[i] == '−' ? '-' : labels[i],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLastRow() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _CalcButton(
            label: '0',
            style: _BtnStyle.number,
            onTap: () => _onButton('0'),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: _CalcButton(
            label: '=',
            style: _BtnStyle.equals,
            onTap: () => _onButton('='),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Button styles
// ---------------------------------------------------------------------------

enum _BtnStyle { number, operator, equals, clear, backspace, special }

class _CalcButton extends StatefulWidget {
  const _CalcButton({
    required this.label,
    required this.style,
    required this.onTap,
  });

  final String label;
  final _BtnStyle style;
  final VoidCallback onTap;

  @override
  State<_CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<_CalcButton>
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
      case _BtnStyle.number:
        return const Color(0xFF37474F);
      case _BtnStyle.operator:
        return const Color(0xFFD4845A);
      case _BtnStyle.equals:
        return const Color(0xFF4CAF50);
      case _BtnStyle.clear:
        return const Color(0xFFBF5350);
      case _BtnStyle.backspace:
        return const Color(0xFFB8860B);
      case _BtnStyle.special:
        return const Color(0xFF546E7A);
    }
  }

  Color get _textColor {
    switch (widget.style) {
      case _BtnStyle.number:
        return Colors.white;
      default:
        return Colors.white;
    }
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
          height: 72,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
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
      return const Icon(Icons.backspace_rounded, color: Colors.white, size: 28);
    }
    return Text(
      widget.label,
      style: TextStyle(
        fontFamily: 'Fredoka One',
        fontSize: widget.label.length > 1 ? 22 : 28,
        color: _textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Star-burst confetti painter
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
    Color(0xFFFFD700), // gold
    Color(0xFFFF4081), // pink
    Color(0xFF40C4FF), // sky blue
    Color(0xFF69F0AE), // green
    Color(0xFFFF6D00), // orange
    Color(0xFFEA80FC), // purple
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
