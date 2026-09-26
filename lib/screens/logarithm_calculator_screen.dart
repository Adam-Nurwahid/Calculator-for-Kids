// lib/screens/logarithm_calculator_screen.dart
//
// "Kalkulator Logaritma" — reachable from the Logaritma tile on the
// Kalkulator Tingkat Lanjut menu (and from the Logaritma rumus page).
//
//   • log  → base-10 logarithm, argument typed as a free expression
//            (e.g. "log" + "100+900" → log(100 + 900)).
//   • ln   → natural logarithm, same idea as `log`.
//   • logₓ → custom base: tap the small base box or the value box to make
//            it active, then type plain numbers into it (like the Pangkat
//            calculator's base/exponent slots).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/logarithm_calculator_logic.dart';

class LogarithmCalculatorScreen extends StatefulWidget {
  final bool isDarkInit;

  const LogarithmCalculatorScreen({
    super.key,
    this.isDarkInit = false,
  });

  @override
  State<LogarithmCalculatorScreen> createState() =>
      _LogarithmCalculatorScreenState();
}

class _LogarithmCalculatorScreenState extends State<LogarithmCalculatorScreen> {
  late bool _isDark;
  final _state = LogCalculatorState();
  bool _showHistory = false;
  final List<_LogHistoryEntry> _history = [];

  static const Color _kOrange = Color(0xFFFB9403);

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkInit;
  }

  // ── Colors ────────────────────────────────────────────────────────────────
  Color get _bgColor => _isDark ? const Color(0xFF0A0A0A) : const Color(0xFFFFFBE7);
  Color get _cardBg => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _textColor => _isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _subTextColor => _isDark ? const Color(0xFFA0A0A0) : const Color(0xFF666666);
  Color get _btnNumBg => _isDark ? const Color(0xFF222222) : const Color(0xFFF2F2F7);
  Color get _btnNumFg => _isDark ? Colors.white : const Color(0xFF1C1C1E);
  Color get _btnSpecBg => _isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);
  Color get _btnSpecFg => _isDark ? Colors.white : const Color(0xFF1C1C1E);

  // ── Keypad handlers ───────────────────────────────────────────────────────
  void _onKeypad(String val) {
    HapticFeedback.lightImpact();
    setState(() {
      switch (val) {
        case 'AC':
          _state.clearAll();
          break;

        case '⌫':
          _state.backspace();
          break;

        case '=':
          _evaluate();
          break;

        default:
          if (_state.isCustom) {
            // Only digits, ',', '00', '-' make sense inside a plain slot.
            const allowed = {
              '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '00', ',', '-'
            };
            if (allowed.contains(val)) {
              _state.inputSlotDigit(val);
            }
            // '(', ')', '%', '+', '×', '÷' are ignored in logₓ mode.
          } else {
            _state.appendArg(val);
          }
          break;
      }
    });
  }

  void _evaluate() {
    final res = _state.evaluate();
    if (res == null || res is! UmumSuccess) return;

    final label = _state.isCustom
        ? 'log${_toSubscript(_state.baseInput)}(${_state.valueInput})'
        : _state.displayExpression;

    setState(() {
      _history.insert(0, _LogHistoryEntry(label, res.display));
    });
  }

  static const _subDigits = {
    '0': '₀', '1': '₁', '2': '₂', '3': '₃', '4': '₄',
    '5': '₅', '6': '₆', '7': '₇', '8': '₈', '9': '₉', '-': '₋',
  };

  String _toSubscript(String s) =>
      s.split('').map((c) => _subDigits[c] ?? c).join();

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 4),
                _buildFnTabs(),
                const SizedBox(height: 12),
                Expanded(child: _buildDisplayArea()),
                _buildKeypad(),
              ],
            ),
            if (_showHistory) _buildHistoryPanel(),
          ],
        ),
      ),
    );
  }

  // ── Top bar ──────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: _textColor),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'Logaritma',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.history_rounded, color: _textColor),
                onPressed: () => setState(() => _showHistory = !_showHistory),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => setState(() => _isDark = !_isDark),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: !_isDark ? Colors.white : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.wb_sunny_rounded,
                          size: 16,
                          color: !_isDark ? Colors.orange : Colors.grey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _isDark ? Colors.black : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.nightlight_round,
                          size: 16,
                          color: _isDark ? Colors.amber : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── log / ln / logₓ tabs ──────────────────────────────────────────────────
  Widget _buildFnTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: LogFn.values.map((fn) {
          final isSelected = _state.fn == fn;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _FnTabButton(
                label: fn.label,
                isSelected: isSelected,
                isDark: _isDark,
                onTap: () => setState(() => _state.selectFn(fn)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Display area ───────────────────────────────────────────────────────────
  Widget _buildDisplayArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _state.isCustom ? _buildCustomInput() : _buildExpressionInput(),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildLiveResult(_state.evaluate()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpressionInput() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Text(
        _state.displayExpression,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: _textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCustomInput() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'log',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: _textColor),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4, right: 4),
          child: _buildSlotBox(
            value: _state.baseInput,
            placeholder: 'x',
            slot: LogSlot.base,
            width: 44,
            height: 34,
            fontSize: 16,
          ),
        ),
        Text(
          '(',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: _textColor),
        ),
        _buildSlotBox(
          value: _state.valueInput,
          placeholder: 'y',
          slot: LogSlot.value,
          width: 90,
          height: 56,
          fontSize: 26,
        ),
        Text(
          ')',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: _textColor),
        ),
      ],
    );
  }

  Widget _buildSlotBox({
    required String value,
    required String placeholder,
    required LogSlot slot,
    required double width,
    required double height,
    required double fontSize,
  }) {
    final isActive = _state.activeSlot == slot;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _state.selectSlot(slot));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive
              ? _kOrange.withValues(alpha: 0.12)
              : (_isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF7F7FA)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? _kOrange
                : (_isDark ? const Color(0xFF3D3D3D) : const Color(0xFFE0E0E0)),
            width: isActive ? 2.2 : 1.2,
          ),
        ),
        child: Center(
          child: Text(
            value.isEmpty ? placeholder : value,
            style: TextStyle(
              fontSize: value.length > 5 ? (fontSize * 0.7) : fontSize,
              fontWeight: value.isEmpty ? FontWeight.normal : FontWeight.bold,
              color: value.isEmpty
                  ? _subTextColor.withValues(alpha: 0.4)
                  : (isActive ? _kOrange : _textColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveResult(UmumResult? res) {
    if (res == null) {
      return Text(
        '0',
        key: const ValueKey('empty'),
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: _subTextColor.withValues(alpha: 0.5),
        ),
      );
    }
    if (res is UmumError) {
      return Text(
        res.message,
        key: ValueKey(res.message),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.redAccent,
        ),
      );
    }
    final success = res as UmumSuccess;
    return Text(
      success.display,
      key: ValueKey(success.display),
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: _subTextColor,
      ),
    );
  }

  // ── Keypad grid ───────────────────────────────────────────────────────────
  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      decoration: BoxDecoration(
        color: _isDark ? const Color(0xFF141414) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildKeypadRow(['⤢', 'AC', '⌫', '%', '÷']),
          const SizedBox(height: 8),
          _buildKeypadRow(['(', '7', '8', '9', '×']),
          const SizedBox(height: 8),
          _buildKeypadRow([')', '4', '5', '6', '-']),
          const SizedBox(height: 8),
          _buildKeypadRow(['00', '1', '2', '3', '+']),
          const SizedBox(height: 8),
          _buildLastKeypadRow(),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      children: keys.map((k) => _buildKeyBtn(k)).toList(),
    );
  }

  Widget _buildLastKeypadRow() {
    return Row(
      children: [
        _buildKeyBtn('0'),
        _buildKeyBtn(','),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kOrange,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shadowColor: _kOrange.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => _onKeypad('='),
                child: const Text(
                  '=',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyBtn(String label) {
    final isOp = ['÷', '×', '+', '='].contains(label);
    final isSpec = ['AC', '⌫', '⤢', '%', '(', ')'].contains(label);
    // In logₓ mode, parentheses/operators/% are inert — dim them so it's
    // visually clear only the digits (and -) do anything.
    final isDisabledInCustom = _state.isCustom &&
        ['(', ')', '%', '+', '×', '÷'].contains(label);

    final bg = isOp ? _kOrange : (isSpec ? _btnSpecBg : _btnNumBg);
    final fg = isOp ? Colors.white : (isSpec ? _btnSpecFg : _btnNumFg);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AspectRatio(
          aspectRatio: 1.25,
          child: Opacity(
            opacity: isDisabledInCustom ? 0.35 : 1.0,
            child: _KeypadButton(
              label: label,
              bgColor: bg,
              fgColor: fg,
              onTap: () {
                if (label == '⤢') return;
                _onKeypad(label);
              },
            ),
          ),
        ),
      ),
    );
  }

  // ── History overlay panel ─────────────────────────────────────────────────
  Widget _buildHistoryPanel() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showHistory = false),
        child: Container(
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Absorb clicks
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: BoxDecoration(
                color: _isDark ? const Color(0xFF1C1C1C) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Riwayat Logaritma',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      if (_history.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() => _history.clear()),
                          child: const Text(
                            'Hapus semua',
                            style: TextStyle(
                              color: _kOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_history.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'Belum ada riwayat hitungan logaritma',
                          style: TextStyle(color: _subTextColor),
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _history.length,
                        separatorBuilder: (context, index) => Divider(
                          color: _isDark ? const Color(0xFF2C2C2E) : const Color(0xFFEEEEEE),
                        ),
                        itemBuilder: (context, i) {
                          final e = _history[i];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              e.expression,
                              style: TextStyle(color: _subTextColor, fontSize: 14),
                            ),
                            subtitle: Text(
                              '= ${e.result}',
                              style: TextStyle(
                                color: _textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
// log / ln / logₓ tab button
// ---------------------------------------------------------------------------

class _FnTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _FnTabButton({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  static const Color _kOrange = Color(0xFFFB9403);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? _kOrange
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? _kOrange
                : (isDark ? const Color(0xFF3D3D3D) : const Color(0xFFDDDDDD)),
            width: 1.4,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _kOrange.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual keypad button (press-scale animation)
// ---------------------------------------------------------------------------

class _KeypadButton extends StatefulWidget {
  final String label;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback onTap;

  const _KeypadButton({
    required this.label,
    required this.bgColor,
    required this.fgColor,
    required this.onTap,
  });

  @override
  State<_KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<_KeypadButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
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
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: _buildLabel()),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    if (widget.label == '⌫') {
      return Icon(Icons.backspace_outlined, color: widget.fgColor, size: 20);
    }
    if (widget.label == '⤢') {
      return Icon(Icons.open_in_full_rounded, color: widget.fgColor, size: 18);
    }
    return Text(
      widget.label,
      style: TextStyle(
        fontSize: widget.label.length > 2 ? 14 : 20,
        fontWeight: FontWeight.bold,
        color: widget.fgColor,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// History entry model
// ---------------------------------------------------------------------------

class _LogHistoryEntry {
  final String expression;
  final String result;

  const _LogHistoryEntry(this.expression, this.result);
}
