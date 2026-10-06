import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/calculator_umum_logic.dart';
import '../utils/responsive.dart';
import '../widgets/calc_responsive_container.dart';
import 'kalkulator_tingkat_lanjut_screen.dart';

/// Kalkulator Umum — full-featured calculator with:
///   • Light / Dark mode toggle
///   • History panel
///   • Basic ops (+, -, ×, ÷)
///   • Parentheses  ( )
///   • Percentage %
///   • DEG / RAD mode
///   • Live result preview
///   • Fully responsive for phones, tablets, and desktop/web with keyboard input
class KalkulatorUmumScreen extends StatefulWidget {
  const KalkulatorUmumScreen({super.key});

  @override
  State<KalkulatorUmumScreen> createState() => _KalkulatorUmumScreenState();
}

/// Snapshot of what the display shows. Value equality lets [ValueNotifier]
/// skip no-op updates, so keypresses rebuild only the display subtree.
@immutable
class _DisplayState {
  const _DisplayState(this.expression, this.result, this.isError);
  final String expression;
  final String result;
  final bool isError;

  @override
  bool operator ==(Object other) =>
      other is _DisplayState &&
      other.expression == expression &&
      other.result == result &&
      other.isError == isError;

  @override
  int get hashCode => Object.hash(expression, result, isError);
}

/// True if [s] contains an ASCII digit or '(' (replaces a per-keypress RegExp).
bool _startsFreshExpression(String s) {
  for (var i = 0; i < s.length; i++) {
    final c = s.codeUnitAt(i);
    if ((c >= 0x30 && c <= 0x39) || c == 0x28) return true;
  }
  return false;
}

/// History is capped so it can't grow without bound in a long session.
const int _kMaxHistory = 50;

class _KalkulatorUmumScreenState extends State<KalkulatorUmumScreen>
    with TickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  String _expression = '';
  String _result = '';
  bool _isError = false;
  bool _justEvaluated = false;
  bool _isDark = false;
  AngleMode _angleMode = AngleMode.deg;
  bool _showHistory = false;
  final List<_HistoryEntry> _history = [];

  // ── Animation controllers ─────────────────────────────────────────────────
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  /// Display listens to this; the button grid does not rebuild per keypress.
  final ValueNotifier<_DisplayState> _calc =
      ValueNotifier(const _DisplayState('', '', false));

  @override
  void initState() {
    super.initState();

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
    _shakeCtrl.dispose();
    _calc.dispose();
    super.dispose();
  }

  // ── Colours (theme-aware) ────────────────────────────────────────────────

  Color get _bgColor => _isDark ? const Color(0xFF0A0A0A) : const Color(0xFFFFFFFF);
  Color get _exprColor => _isDark ? Colors.white : Colors.black;
  Color get _resultColor => _isDark ? const Color(0xFF888888) : const Color(0xFF999999);
  Color get _btnNumBg =>
      _isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F0F0);
  Color get _btnNumFg => _isDark ? Colors.white : Colors.black;
  Color get _btnSpecBg =>
      _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
  Color get _btnSpecFg => _isDark ? Colors.white : Colors.black87;
  static const Color _kOrange = Color(0xFFFB9403);

  // ── Button press logic ────────────────────────────────────────────────────

  void _onButton(String value) {
    HapticFeedback.lightImpact();
    _handleInput(value);
    _publish();
  }

  void _publish() {
    _calc.value = _DisplayState(_expression, _result, _isError);
  }

  void _handleInput(String value) {
    // After "=" pressed, a new digit starts a fresh expression
    if (_justEvaluated && _startsFreshExpression(value)) {
      _expression = value;
      _result = '';
      _isError = false;
      _justEvaluated = false;
      return;
    }
    _justEvaluated = false;

    switch (value) {
      case 'AC':
      case 'C':
        _expression = '';
        _result = '';
        _isError = false;
        return;

      case '⌫':
        if (_expression.isNotEmpty) {
          // Remove last multi-char token (sin, cos, tan, log, ln)
          const fns = ['sin', 'cos', 'tan', 'log', 'ln'];
          bool removed = false;
          for (final fn in fns) {
            if (_expression.endsWith(fn)) {
              _expression =
                  _expression.substring(0, _expression.length - fn.length);
              removed = true;
              break;
            }
          }
          if (!removed) {
            _expression = _expression.substring(0, _expression.length - 1);
          }
          _isError = false;
          _updateLive();
        }
        return;

      case '=':
        _evaluate();
        return;

      case ',':
        if (_canAppend('.')) {
          _expression += '.';
          _isError = false;
          _updateLive();
        }
        return;

      case '00':
        if (_expression.isNotEmpty && _canAppend('0')) {
          _expression += '00';
          _isError = false;
          _updateLive();
        }
        return;

      default:
        if (_canAppend(value)) {
          // Functions need an auto '(' after them
          _expression += value;
          if (['sin', 'cos', 'tan', 'log', 'ln', '√'].contains(value)) {
            _expression += '(';
          }
          _isError = false;
          _updateLive();
        }
    }
  }

  /// DEG <-> RAD. Also re-evaluates, so the preview never shows a result
  /// computed in the previous angle mode.
  void _toggleAngleMode() {
    setState(() {
      _angleMode =
          _angleMode == AngleMode.deg ? AngleMode.rad : AngleMode.deg;
    });
    if (_expression.isNotEmpty) {
      _updateLive();
      _publish();
    }
  }

  bool _canAppend(String token) => canAppendUmum(_expression, token);

  void _updateLive() {
    final r = evaluateUmum(_expression, mode: _angleMode);
    if (r is UmumSuccess) {
      _result = r.display;
      _isError = false;
    } else {
      _result = '';
    }
  }

  // Mutates state only; the caller (_onButton) publishes it. No nested setState.
  void _evaluate() {
    if (_expression.isEmpty) return;
    final r = evaluateUmum(_expression, mode: _angleMode);
    if (r is UmumSuccess) {
      _history.insert(0, _HistoryEntry(_expression, r.display));
      if (_history.length > _kMaxHistory) _history.removeLast();
      _result = r.display;
      _isError = false;
      _justEvaluated = true;
    } else if (r is UmumError) {
      _result = r.message;
      _isError = true;
      _shakeCtrl.forward(from: 0);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.isLandscape;

    return Scaffold(
      backgroundColor: _bgColor,
      body: CalcResponsiveContainer(
        backgroundColor: _bgColor,
        maxWidth: 480,
        onKeyInput: _onButton,
        child: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompactHeight = constraints.maxHeight < 540;

                  if (isLandscape || isCompactHeight) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            _buildTopBar(),
                            const SizedBox(height: 4),
                            SizedBox(
                              height: 120,
                              child: _buildDisplay(),
                            ),
                            const SizedBox(height: 8),
                            _buildButtonGrid(),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 8),
                      Expanded(child: _buildDisplay()),
                      _buildButtonGrid(),
                    ],
                  );
                },
              ),

              // History overlay
              if (_showHistory) _buildHistoryPanel(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ─ Light / Dark toggle pill ─
          GestureDetector(
            onTap: () => setState(() => _isDark = !_isDark),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sun
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: !_isDark ? Colors.black87 : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 16,
                      color: !_isDark ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 2),
                  // Moon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: _isDark ? Colors.white : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.nightlight_round,
                      size: 16,
                      color: _isDark ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─ Right icons ─
          Row(
            children: [
              // History
              _IconBtn(
                icon: Icons.history_rounded,
                color: _isDark ? Colors.white : Colors.black87,
                onTap: () => setState(() => _showHistory = !_showHistory),
              ),
              const SizedBox(width: 4),
              // Advanced Operations Menu
              _IconBtn(
                icon: Icons.tune_rounded,
                color: _isDark ? Colors.white : Colors.black87,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KalkulatorTingkatLanjutScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              // Back to level selection
              _IconBtn(
                icon: Icons.grid_view_rounded,
                color: _isDark ? Colors.white : Colors.black87,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Display area ───────────────────────────────────────────────────────────

  Widget _buildDisplay() {
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (context, child) {
        final dx = _isError
            ? math.sin(_shakeAnim.value * math.pi * 6) *
            10 *
            (1 - _shakeAnim.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ValueListenableBuilder<_DisplayState>(
          valueListenable: _calc,
          builder: (context, d, _) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Expression
              FittedBox(
                alignment: Alignment.centerRight,
                fit: BoxFit.scaleDown,
                child: Text(
                  d.expression.isEmpty ? '0' : d.expression,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: _exprColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Live result / answer
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: d.result.isEmpty
                    ? const SizedBox(height: 28, key: ValueKey('empty'))
                    : FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          d.result,
                          key: ValueKey(d.result),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: d.isError ? Colors.redAccent : _resultColor,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ── Button grid ────────────────────────────────────────────────────────────

  Widget _buildButtonGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Column(
        children: [
          _buildRow([
            const _Btn('⤢', _BtnKind.spec),
            const _Btn('AC', _BtnKind.spec),
            const _Btn('⌫', _BtnKind.spec),
            const _Btn('%', _BtnKind.spec),
            const _Btn('÷', _BtnKind.op),
          ]),
          _gap(),
          _buildRow([
            const _Btn('(', _BtnKind.spec),
            const _Btn('7', _BtnKind.num),
            const _Btn('8', _BtnKind.num),
            const _Btn('9', _BtnKind.num),
            const _Btn('×', _BtnKind.op),
          ]),
          _gap(),
          _buildRow([
            const _Btn(')', _BtnKind.spec),
            const _Btn('4', _BtnKind.num),
            const _Btn('5', _BtnKind.num),
            const _Btn('6', _BtnKind.num),
            const _Btn('-', _BtnKind.op),
          ]),
          _gap(),
          _buildRow([
            _Btn(_angleMode == AngleMode.deg ? 'DEG' : 'RAD',
                _BtnKind.angleSel),
            const _Btn('1', _BtnKind.num),
            const _Btn('2', _BtnKind.num),
            const _Btn('3', _BtnKind.num),
            const _Btn('+', _BtnKind.op),
          ]),
          _gap(),
          _buildLastRow(),
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 8);

  Widget _buildRow(List<_Btn> btns) {
    return Row(
      children: btns.map((b) => _buildBtnWidget(b)).toList(),
    );
  }

  Widget _buildLastRow() {
    return Row(
      children: [
        _buildBtnWidget(const _Btn('00', _BtnKind.num)),
        _buildBtnWidget(const _Btn('0', _BtnKind.num)),
        _buildBtnWidget(const _Btn(',', _BtnKind.num)),
        // Flexible span for '=' matching layout grid
        Expanded(
          flex: 2,
          child: _buildEqualBtn(),
        ),
      ],
    );
  }

  Widget _buildBtnWidget(_Btn b) {
    final bg = _btnBg(b.kind);
    final fg = _btnFg(b.kind);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: _CalcButton(
            label: b.label,
            bgColor: bg,
            fgColor: fg,
            onTap: () {
              if (b.label == '⤢') return;
              if (b.label == 'DEG' || b.label == 'RAD') {
                _toggleAngleMode();
                return;
              }
              _onButton(b.label);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEqualBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Height matches a single standard 1:1 circle button width
          final h = (constraints.maxWidth - 6) / 2;
          return SizedBox(
            height: h,
            child: _CalcEqualButton(onTap: () => _onButton('=')),
          );
        },
      ),
    );
  }

  Color _btnBg(_BtnKind kind) {
    return switch (kind) {
      _BtnKind.num => _btnNumBg,
      _BtnKind.spec => _btnSpecBg,
      _BtnKind.op => _kOrange,
      _BtnKind.angleSel => _isDark
          ? const Color(0xFF3A3A3A)
          : const Color(0xFFD8D8D8),
    };
  }

  Color _btnFg(_BtnKind kind) {
    return switch (kind) {
      _BtnKind.num => _btnNumFg,
      _BtnKind.spec => _btnSpecFg,
      _BtnKind.op => Colors.white,
      _BtnKind.angleSel => _isDark ? Colors.white : Colors.black87,
    };
  }

  // ── History panel ──────────────────────────────────────────────────────────

  Widget _buildHistoryPanel() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showHistory = false),
        child: Container(
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Absorb taps on panel
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.6,
              ),
              decoration: BoxDecoration(
                color: _isDark ? const Color(0xFF1C1C1C) : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Riwayat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _exprColor,
                        ),
                      ),
                      if (_history.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() {
                            _history.clear();
                          }),
                          child: const Text(
                            'Hapus semua',
                            style: TextStyle(
                              fontSize: 14,
                              color: _kOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_history.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'Belum ada riwayat',
                          style: TextStyle(color: _resultColor),
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _history.length,
                        separatorBuilder: (context, idx) => Divider(
                          color: _isDark
                              ? const Color(0xFF2A2A2A)
                              : const Color(0xFFEEEEEE),
                          height: 1,
                        ),
                        itemBuilder: (_, i) {
                          final e = _history[i];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              e.expression,
                              style: TextStyle(color: _resultColor, fontSize: 15),
                            ),
                            subtitle: Text(
                              '= ${e.result}',
                              style: TextStyle(
                                color: _exprColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _expression = e.result;
                                _result = '';
                                _isError = false;
                                _justEvaluated = true;
                                _showHistory = false;
                              });
                              _publish();
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class _HistoryEntry {
  const _HistoryEntry(this.expression, this.result);
  final String expression;
  final String result;
}

// ---------------------------------------------------------------------------
// Button descriptor
// ---------------------------------------------------------------------------

enum _BtnKind { num, spec, op, angleSel }

class _Btn {
  const _Btn(this.label, this.kind);
  final String label;
  final _BtnKind kind;
}

// ---------------------------------------------------------------------------
// Individual calculator button (ink feedback + hover; no per-button controller)
// ---------------------------------------------------------------------------

class _CalcButton extends StatelessWidget {
  const _CalcButton({
    required this.label,
    required this.bgColor,
    required this.fgColor,
    required this.onTap,
  });

  final String label;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback onTap;

  static const List<BoxShadow> _shadow = [
    BoxShadow(
      color: Color(0x12000000), // black @ ~7%
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: _shadow,
      ),
      child: Material(
        color: bgColor,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkResponse(
          onTap: onTap,
          containedInkWell: true,
          customBorder: const CircleBorder(),
          splashFactory: InkRipple.splashFactory, // cheaper than InkSparkle
          hoverColor: const Color(0x26FFFFFF),
          highlightColor: const Color(0x14000000),
          splashColor: const Color(0x1F000000),
          canRequestFocus: false, // keep focus on the keyboard-input node
          child: Center(child: _buildLabel()),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    if (label == '⌫') {
      return Icon(Icons.backspace_outlined, color: fgColor, size: 22);
    }
    if (label == '⤢') {
      return Icon(Icons.open_in_full_rounded, color: fgColor, size: 20);
    }
    return Text(
      label,
      style: TextStyle(
        fontSize: label.length > 2 ? 15 : (label.length > 1 ? 19 : 24),
        color: fgColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CalcEqualButton extends StatelessWidget {
  const _CalcEqualButton({required this.onTap});
  final VoidCallback onTap;

  static const Color _orange = Color(0xFFFB9403);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        shadows: [
          BoxShadow(
            color: Color(0x66FB9403), // orange @ 40%
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: _orange,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkResponse(
          onTap: onTap,
          containedInkWell: true,
          customBorder: const StadiumBorder(),
          splashFactory: InkRipple.splashFactory,
          hoverColor: const Color(0x26FFFFFF),
          highlightColor: const Color(0x14000000),
          splashColor: const Color(0x1FFFFFFF),
          canRequestFocus: false,
          child: const Center(
            child: Text(
              '=',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small icon button (top-bar with hover effect)
// ---------------------------------------------------------------------------

class _IconBtn extends StatefulWidget {
  const _IconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered ? widget.color.withValues(alpha: 0.12) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, color: widget.color, size: 24),
        ),
      ),
    );
  }
}