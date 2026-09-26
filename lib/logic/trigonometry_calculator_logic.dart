// lib/logic/trigonometry_calculator_logic.dart
//
// Logic for "Kalkulator Trigonometri".
//
// The user first picks a function (Sin / Cos / Tan), then builds the
// argument as a normal arithmetic expression — e.g. picking "Cos" and
// typing "60 + 30" produces the full expression `Cos(60 + 30)`.
//
// Rather than re-implementing a parser, this reuses the exact same
// recursive-descent expression engine already built for
// `calculator_umum_logic.dart` (operators, parentheses, %, decimals, DEG/RAD
// conversion for sin/cos/tan, …). We simply wrap the user's raw input with
// `fn( … )` before handing it to `evaluateUmum`.

import 'calculator_umum_logic.dart';

export 'calculator_umum_logic.dart' show AngleMode, UmumResult, UmumSuccess, UmumError;

/// Which trig function is currently selected on the Sin / Cos / Tan tabs.
enum TrigFn { sin, cos, tan }

extension TrigFnX on TrigFn {
  /// Token understood by the underlying parser ('sin' | 'cos' | 'tan').
  String get key => switch (this) {
        TrigFn.sin => 'sin',
        TrigFn.cos => 'cos',
        TrigFn.tan => 'tan',
      };

  /// Capitalised label shown on the tab and in the display, e.g. "Cos".
  String get label => switch (this) {
        TrigFn.sin => 'Sin',
        TrigFn.cos => 'Cos',
        TrigFn.tan => 'Tan',
      };
}

/// Mutable state for the trigonometry calculator screen.
///
/// Only the *argument* of the trig function is tracked as raw input
/// (`innerExpression`); the chosen function is wrapped around it purely for
/// display and evaluation, so the UI never has to juggle "sin(" / ")" as
/// literal characters the user could accidentally delete.
class TrigCalculatorState {
  TrigFn fn;
  String innerExpression;
  AngleMode angleMode;

  TrigCalculatorState({
    this.fn = TrigFn.cos,
    this.innerExpression = '',
    this.angleMode = AngleMode.deg,
  });

  /// What the big display shows, e.g. "Cos(60 + 30)".
  ///
  /// [innerExpression] is stored with canonical ASCII operators (`*`, `/`,
  /// `.`) so the shared parser's guards work correctly (see [append]); here
  /// we swap them back to the glyphs the user actually taps.
  String get displayExpression {
    final pretty = innerExpression
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll('.', ',');
    return '${fn.label}($pretty)';
  }

  void selectFn(TrigFn newFn) => fn = newFn;

  void toggleAngleMode() {
    angleMode = angleMode == AngleMode.deg ? AngleMode.rad : AngleMode.deg;
  }

  void clearAll() => innerExpression = '';

  void backspace() {
    if (innerExpression.isEmpty) return;
    innerExpression = innerExpression.substring(0, innerExpression.length - 1);
  }

  /// Maps a keypad glyph to the ASCII token the shared parser understands.
  static String _normalize(String token) => switch (token) {
        '×' => '*',
        '÷' => '/',
        ',' => '.',
        _ => token,
      };

  /// Whether [token] may be appended right now (blocks e.g. "++" or ")(" ).
  bool canAppend(String token) => canAppendUmum(innerExpression, _normalize(token));

  /// Appends [token] to the argument if it keeps the expression well formed.
  void append(String token) {
    final normalized = _normalize(token);
    if (!canAppendUmum(innerExpression, normalized)) return;
    innerExpression += normalized;
  }

  /// Live or final evaluation of `Fn(innerExpression)`.
  ///
  /// Returns null while the argument is still empty, so the caller can
  /// choose to show a blank/placeholder result instead of an error.
  UmumResult? evaluate() {
    if (innerExpression.trim().isEmpty) return null;
    return evaluateUmum('${fn.key}($innerExpression)', mode: angleMode);
  }
}
