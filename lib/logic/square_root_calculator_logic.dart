// lib/logic/square_root_calculator_logic.dart
//
// Logic for "Kalkulator Akar Kuadrat".
//
// Two tabs:
//   • √  — square root. Argument is a free expression, reusing the shared
//          parser's own `√` prefix operator (e.g. typing "25" → √25;
//          typing "(25+11)" → √(25+11) since `√` binds to the next primary,
//          just like on paper).
//   • ⁿ√ — nth root: two plain-number slots (index n & radicand y), same
//          interaction pattern as the Pangkat/Logaritma-basis-custom slots.

import 'dart:math' as math;

import 'calculator_umum_logic.dart';

export 'calculator_umum_logic.dart' show UmumResult, UmumSuccess, UmumError;

/// Which tab is selected.
enum RootFn { sqrt, nth }

extension RootFnX on RootFn {
  String get label => switch (this) {
    RootFn.sqrt => '√',
    RootFn.nth => 'ⁿ√',
  };
}

/// Which slot is active while in [RootFn.nth] mode.
///
/// Named `n` / `value` rather than `index` / `value` because every Dart
/// enum already has a built-in instance getter called `index` (its ordinal
/// position) — reusing that name for a value would clash with it.
enum RootSlot { n, value }

class RootCalculatorState {
  RootFn fn;

  /// Argument for `√` mode — a free-form expression, e.g. "25" or "(25+11)".
  String innerExpression;

  /// Index (n) & radicand (y) slots, used only in [RootFn.nth] mode.
  String indexInput;
  String valueInput;
  RootSlot activeSlot;

  RootCalculatorState({
    this.fn = RootFn.sqrt,
    this.innerExpression = '',
    this.indexInput = '',
    this.valueInput = '',
    this.activeSlot = RootSlot.value,
  });

  bool get isNth => fn == RootFn.nth;

  void selectFn(RootFn newFn) => fn = newFn;

  // ── √ (expression) mode ──────────────────────────────────────────────────

  /// What the big display shows for `√`, e.g. "√25" or "√(25+11)".
  String get displayExpression {
    final pretty = innerExpression
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll('.', ',');
    return '√$pretty';
  }

  static String _normalize(String token) => switch (token) {
    '×' => '*',
    '÷' => '/',
    ',' => '.',
    _ => token,
  };

  bool canAppendArg(String token) => canAppendUmum(innerExpression, _normalize(token));

  void appendArg(String token) {
    final normalized = _normalize(token);
    if (!canAppendUmum(innerExpression, normalized)) return;
    innerExpression += normalized;
  }

  /// Evaluate `√innerExpression` using the shared parser's own `√` operator.
  UmumResult? evaluateExpr() {
    if (innerExpression.trim().isEmpty) return null;
    return evaluateUmum('√$innerExpression');
  }

  // ── ⁿ√ (nth root) mode ───────────────────────────────────────────────────

  void selectSlot(RootSlot slot) => activeSlot = slot;

  void clearAll() {
    innerExpression = '';
    indexInput = '';
    valueInput = '';
    activeSlot = RootSlot.value;
  }

  void backspace() {
    if (!isNth) {
      if (innerExpression.isNotEmpty) {
        innerExpression = innerExpression.substring(0, innerExpression.length - 1);
      }
      return;
    }
    if (activeSlot == RootSlot.value) {
      if (valueInput.isNotEmpty) {
        valueInput = valueInput.substring(0, valueInput.length - 1);
      } else {
        activeSlot = RootSlot.n;
      }
    } else {
      if (indexInput.isNotEmpty) {
        indexInput = indexInput.substring(0, indexInput.length - 1);
      }
    }
  }

  /// Digit/decimal/sign input for the active slot (ⁿ√ mode only).
  void inputSlotDigit(String val) {
    String current = activeSlot == RootSlot.n ? indexInput : valueInput;

    if (val == '-') {
      current = current.startsWith('-') ? current.substring(1) : '-$current';
    } else if (val == ',') {
      if (!current.contains(',')) {
        current += current.isEmpty || current == '-' ? '0,' : ',';
      }
    } else if (val == '00') {
      if (current.isEmpty || current == '0') {
        current = '0';
      } else if (current == '-') {
        current = '-0';
      } else {
        current += '00';
      }
    } else {
      if (current == '0') {
        current = val;
      } else if (current == '-0') {
        current = '-$val';
      } else {
        current += val;
      }
    }

    if (activeSlot == RootSlot.n) {
      indexInput = current;
    } else {
      valueInput = current;
    }
  }

  /// Evaluate `ⁿ√value` = value^(1/n).
  UmumResult? evaluateNth() {
    if (indexInput.isEmpty || valueInput.isEmpty) return null;

    final n = double.tryParse(indexInput.replaceAll(',', '.'));
    final value = double.tryParse(valueInput.replaceAll(',', '.'));

    if (n == null || value == null) {
      return const UmumError('Input tidak valid');
    }
    if (n == 0) {
      return const UmumError('Indeks akar tidak boleh 0');
    }
    if (value < 0) {
      final isOddInteger = n == n.roundToDouble() && n.round().isOdd;
      if (!isOddInteger) {
        return const UmumError('Akar genap dari bilangan negatif');
      }
      final result = -math.pow(-value, 1 / n).toDouble();
      return UmumSuccess(result);
    }

    final result = math.pow(value, 1 / n).toDouble();
    if (result.isNaN || result.isInfinite) {
      return const UmumError('Hasil tidak terdefinisi');
    }
    return UmumSuccess(result);
  }

  /// Live/final evaluation for whichever mode is active.
  UmumResult? evaluate() => isNth ? evaluateNth() : evaluateExpr();
}