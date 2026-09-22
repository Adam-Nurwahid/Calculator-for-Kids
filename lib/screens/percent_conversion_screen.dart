import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/percent_conversion_logic.dart';

class PercentConversionScreen extends StatefulWidget {
  final bool isDarkInit;

  const PercentConversionScreen({
    super.key,
    this.isDarkInit = false,
  });

  @override
  State<PercentConversionScreen> createState() =>
      _PercentConversionScreenState();
}

class _PercentConversionScreenState extends State<PercentConversionScreen> {
  late bool _isDark;
  late PercentConversionState _calcState;
  bool _showHistory = false;
  final List<_ConversionHistoryEntry> _history = [];

  static const Color _kOrange = Color(0xFFFB9403);

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkInit;
    _calcState = PercentConversionState();
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
          _calcState.clearAll();
          break;

        case '⌫':
          _calcState.backspace();
          break;

        case '=':
          _evaluate();
          break;

        case '-':
        case ',':
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '00':
          _calcState.inputDigit(val);
          break;

        default:
          // Ignore unsupported keys like '(', ')', '%', '⤢', '÷', '×', '+'
          break;
      }
    });
  }

  void _evaluate() {
    final res = _calcState.calculateResult();
    if (res != null) {
      if (res.isSuccess && res.formattedResult != null) {
        final inputStr = _calcState.rawInput.isEmpty ? '0' : _calcState.rawInput;
        final fromSuffix = _calcState.fromUnit.symbol.isNotEmpty
            ? _calcState.fromUnit.symbol
            : '';
        final expr = '$inputStr$fromSuffix (${_calcState.fromUnit.label} → ${_calcState.toUnit.label})';
        final resStr = res.formattedResult!;

        setState(() {
          _history.insert(0, _ConversionHistoryEntry(expr, resStr));
        });
      } else if (res.isError) {
        setState(() {
          _calcState.errorMessage = res.error;
        });
      }
    }
  }

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
                _buildSelectorRow(),
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

  // ── App Bar Header ────────────────────────────────────────────────────────
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
                'Konversi',
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
              // History button
              IconButton(
                icon: Icon(Icons.history_rounded, color: _textColor),
                onPressed: () => setState(() => _showHistory = !_showHistory),
              ),
              const SizedBox(width: 4),
              // Theme Toggle
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

  // ── Unit Selector Row ─────────────────────────────────────────────────────
  Widget _buildSelectorRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // From Unit Selector
          Expanded(
            child: _buildUnitDropdown(
              unit: _calcState.fromUnit,
              onSelected: (u) => setState(() => _calcState.setFromUnit(u)),
            ),
          ),

          const SizedBox(width: 8),

          // Swap Button
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _calcState.swapUnits();
              });
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _cardBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isDark ? const Color(0xFF444444) : Colors.black87,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.swap_horiz_rounded,
                size: 22,
                color: _textColor,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // To Unit Selector
          Expanded(
            child: _buildUnitDropdown(
              unit: _calcState.toUnit,
              onSelected: (u) => setState(() => _calcState.setToUnit(u)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitDropdown({
    required ConversionUnit unit,
    required ValueChanged<ConversionUnit> onSelected,
  }) {
    return PopupMenuButton<ConversionUnit>(
      onSelected: onSelected,
      color: _cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      itemBuilder: (context) => ConversionUnit.values
          .map(
            (u) => PopupMenuItem<ConversionUnit>(
              value: u,
              child: Text(
                u.label,
                style: TextStyle(
                  color: _textColor,
                  fontWeight: u == unit ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isDark ? const Color(0xFF444444) : Colors.black87,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              unit.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: _textColor,
            ),
          ],
        ),
      ),
    );
  }

  // ── Display Area ──────────────────────────────────────────────────────────
  Widget _buildDisplayArea() {
    final res = _calcState.calculateResult();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main Input display box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isDark ? 0.3 : 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _calcState.rawInput.isEmpty ? '0' : _calcState.rawInput,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _calcState.rawInput.isEmpty
                        ? _subTextColor.withValues(alpha: 0.4)
                        : _textColor,
                  ),
                ),
                if (_calcState.fromUnit.symbol.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      _calcState.fromUnit.symbol,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _kOrange,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Output Result Display Box
          _buildResultDisplay(res),
        ],
      ),
    );
  }

  Widget _buildResultDisplay(PercentConversionResult? res) {
    if (_calcState.errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _calcState.errorMessage!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (res == null || !res.isSuccess || res.formattedResult == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        alignment: Alignment.centerRight,
        child: Text(
          '= ...',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: _subTextColor.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    final formatted = res.formattedResult!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _kOrange.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hasil / Result',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _subTextColor,
            ),
          ),
          Text(
            '= $formatted',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: _kOrange,
            ),
          ),
        ],
      ),
    );
  }

  // ── Keypad Grid ───────────────────────────────────────────────────────────
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

    final bg = isOp ? _kOrange : (isSpec ? _btnSpecBg : _btnNumBg);
    final fg = isOp ? Colors.white : (isSpec ? _btnSpecFg : _btnNumFg);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AspectRatio(
          aspectRatio: 1.25,
          child: _KeypadButton(
            label: label,
            bgColor: bg,
            fgColor: fg,
            onTap: () => _onKeypad(label),
          ),
        ),
      ),
    );
  }

  // ── History Overlay Panel ─────────────────────────────────────────────────
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
                        'Riwayat Konversi',
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
                          'Belum ada riwayat hitungan konversi',
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
          child: Center(
            child: _buildLabel(),
          ),
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

class _ConversionHistoryEntry {
  final String expression;
  final String result;

  const _ConversionHistoryEntry(this.expression, this.result);
}
