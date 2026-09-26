// lib/logic/logarithm_calculator_logic.dart
//
// Logic for "Kalkulator Logaritma".
//
// Three tabs:
//   • log   — base-10 logarithm.  Argument is a full expression, e.g.
//             picking "log" and typing "100 + 900" → log(100 + 900).
//             Reuses the shared parser from calculator_umum_logic.dart.
//   • ln    — natural logarithm (base e). Same idea as `log`.
//   • logₓ  — custom base logaritma: log_b(y). Two plain-number slots
//             (base & value), same interaction pattern as the Pangkat
//             (power) calculator's base/exponent slots.

import 'dart:math' as math;

import 'calculator_umum_logic.dart';

export 'calculator_umum_logic.dart' show UmumResult, UmumSuccess, UmumError;

/// Which tab is selected.
enum LogFn { log10, ln, custom }

extension LogFnX on LogFn {
  String get label => switch (this) {
        LogFn.log10 => 'log',
        LogFn.ln => 'ln',
        LogFn.custom => 'logₓ',
      };
}

/// Which slot is active while in [LogFn.custom] mode.
enum LogSlot { base, value }

class LogCalculatorState {
  LogFn fn;

  /// Argument for `log` / `ln` modes — a free-form expression, e.g. "100+900".
  String argExpression;

  /// Base & value slots, used only in [LogFn.custom] mode.
  String baseInput;
  String valueInput;
  LogSlot activeSlot;

  LogCalculatorState({
    this.fn = LogFn.log10,
    this.argExpression = '',
    this.baseInput = '',
    this.valueInput = '',
    this.activeSlot = LogSlot.value,
  });

  bool get isCustom => fn == LogFn.custom;

  void selectFn(LogFn newFn) => fn = newFn;

  // ── log / ln (expression) mode ──────────────────────────────────────────

  /// What the big display shows for `log`/`ln`, e.g. "log(100 + 900)".
  String get displayExpression {
    final pretty = argExpression
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll('.', ',');
    return '${fn.label}($pretty)';
  }

  static String _normalize(String token) => switch (token) {
        '×' => '*',
        '÷' => '/',
        ',' => '.',
        _ => token,
      };

  bool canAppendArg(String token) => canAppendUmum(argExpression, _normalize(token));

  void appendArg(String token) {
    final normalized = _normalize(token);
    if (!canAppendUmum(argExpression, normalized)) return;
    argExpression += normalized;
  }

  /// Evaluate `log(argExpression)` or `ln(argExpression)`.
  UmumResult? evaluateExpr() {
    if (argExpression.trim().isEmpty) return null;
    final fnKey = fn == LogFn.ln ? 'ln' : 'log';
    return evaluateUmum('$fnKey($argExpression)');
  }

  // ── logₓ (custom base) mode ─────────────────────────────────────────────

  void selectSlot(LogSlot slot) => activeSlot = slot;

  void clearAll() {
    argExpression = '';
    baseInput = '';
    valueInput = '';
    activeSlot = LogSlot.value;
  }

  void backspace() {
    if (!isCustom) {
      if (argExpression.isNotEmpty) {
        argExpression = argExpression.substring(0, argExpression.length - 1);
      }
      return;
    }
    if (activeSlot == LogSlot.value) {
      if (valueInput.isNotEmpty) {
        valueInput = valueInput.substring(0, valueInput.length - 1);
      } else {
        activeSlot = LogSlot.base;
      }
    } else {
      if (baseInput.isNotEmpty) {
        baseInput = baseInput.substring(0, baseInput.length - 1);
      }
    }
  }

  /// Digit/decimal/sign input for the active slot (logₓ mode only).
  void inputSlotDigit(String val) {
    String current = activeSlot == LogSlot.base ? baseInput : valueInput;

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

    if (activeSlot == LogSlot.base) {
      baseInput = current;
    } else {
      valueInput = current;
    }
  }

  /// Evaluate `log_base(value)` using the change-of-base formula.
  UmumResult? evaluateCustom() {
    if (baseInput.isEmpty || valueInput.isEmpty) return null;

    final base = double.tryParse(baseInput.replaceAll(',', '.'));
    final value = double.tryParse(valueInput.replaceAll(',', '.'));

    if (base == null || value == null) {
      return const UmumError('Input tidak valid');
    }
    if (base <= 0 || base == 1) {
      return const UmumError('Basis harus > 0 dan ≠ 1');
    }
    if (value <= 0) {
      return const UmumError('Angka harus positif');
    }

    final result = math.log(value) / math.log(base);
    if (result.isNaN || result.isInfinite) {
      return const UmumError('Hasil tidak terdefinisi');
    }
    return UmumSuccess(result);
  }

  /// Live/final evaluation for whichever mode is active.
  UmumResult? evaluate() => isCustom ? evaluateCustom() : evaluateExpr();
}
