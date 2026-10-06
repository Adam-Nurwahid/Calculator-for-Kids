// lib/logic/calculator_umum_logic.dart
//
// Extended calculator logic for the "Kalkulator Umum" screen.
//
// Supports:
//   - Basic: +, -, *, /, (, )
//   - Percentage: %  (evaluated as /100)
//   - Power: ^
//   - Trigonometry: sin, cos, tan   (with DEG / RAD mode)
//   - Logarithm:    log, ln
//   - Square root:  √
//
// Grammar (EBNF):
//   expr    = term   ( ( '+' | '-' ) term   )*
//   term    = unary  ( ( '*' | '/' | '%' ) unary )*
//   unary   = '-' unary | power          // unary minus binds LOOSER than ^
//   power   = primary ( '^' unary )?     // right-associative: 2^3^2 = 2^9
//   primary = NUMBER | fn '(' expr ')' | '(' expr ')' | CONST
//   fn      = 'sin' | 'cos' | 'tan' | 'log' | 'ln' | '√'
//   CONST   = 'π' | 'e'

import 'dart:math' as math;

// ---------------------------------------------------------------------------
// Angle mode
// ---------------------------------------------------------------------------

enum AngleMode { deg, rad }

// ---------------------------------------------------------------------------
// Result type  (mirror of the Anak version for API consistency)
// ---------------------------------------------------------------------------

sealed class UmumResult {
  const UmumResult();
}

final class UmumSuccess extends UmumResult {
  const UmumSuccess(this.value);
  final num value;

  String get display {
    if (value.isNaN) return 'NaN';
    if (value.isInfinite) return value > 0 ? '∞' : '-∞';
    if (value is int || value == value.truncate()) {
      return value.truncate().toString();
    }
    // Up to 10 decimal places; collapse float noise (e.g. sin(180°) ≈ 1e-16)
    // to a clean integer string instead of "0.0".
    final d = double.parse(value.toStringAsFixed(10));
    if (d == d.truncate()) return d.truncate().toString();
    return d.toString();
  }
}

final class UmumError extends UmumResult {
  const UmumError(this.message);
  final String message;
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

UmumResult evaluateUmum(String expression, {AngleMode mode = AngleMode.deg}) {
  if (expression.trim().isEmpty) {
    return const UmumError('Masukkan ekspresi');
  }

  // Normalise display glyphs → parser-friendly ASCII/Unicode
  final normalised = expression
      .replaceAll('×', '*')
      .replaceAll('÷', '/')
      .replaceAll(',', '.')   // decimal comma → dot
      .replaceAll(' ', '');

  try {
    final parser = _UmumParser(normalised, mode);
    final result = parser.parseExpr();
    if (!parser.isAtEnd) {
      return const UmumError('Ekspresi tidak valid');
    }
    if (result.isNaN) return const UmumError('Tak terdefinisi');
    if (result.isInfinite) return const UmumError('Tak hingga (∞)');
    return UmumSuccess(result);
  } on _DivByZero {
    return const UmumError('Bagi dengan nol!');
  } on _ParseEx catch (e) {
    return UmumError(e.msg);
  } catch (_) {
    return const UmumError('Ekspresi tidak valid');
  }
}

// ---------------------------------------------------------------------------
// Input-guard (used by the UI to prevent nonsensical button sequences)
// ---------------------------------------------------------------------------

/// Returns true if appending [token] to [expr] is a valid move.
bool canAppendUmum(String expr, String token) {
  final last = expr.isEmpty ? '' : expr[expr.length - 1];
  final isOp = _isOp(token);
  final isDigit = _isDigitToken(token);
  final isFn = _isFn(token);

  if (expr.isEmpty) {
    return isDigit || token == '(' || isFn || token == 'π' || token == 'e';
  }

  if (isOp) {
    // Cannot follow another operator, an opening paren, or a function name
    return !_isOp(last) && last != '(' && !_isFn(last);
  }

  if (isDigit) {
    return last != ')' && last != 'π' && last != 'e';
  }

  if (token == '(') {
    return _isOp(last) || last == '(' || isFn;
  }

  if (token == ')') {
    return _parenBalance(expr) > 0 && !_isOp(last) && last != '(';
  }

  if (isFn || token == 'π' || token == 'e') {
    return _isOp(last) || last == '(' || expr.isEmpty;
  }

  return true;
}

/// True when [s] is a single ASCII digit (replaces a per-call RegExp).
bool _isDigitToken(String s) =>
    s.length == 1 && _isDigitCode(s.codeUnitAt(0));

bool _isDigitCode(int c) => c >= 0x30 && c <= 0x39; // '0'..'9'

/// Open-minus-close parenthesis count in a single pass (no list allocation).
int _parenBalance(String s) {
  var n = 0;
  for (var i = 0; i < s.length; i++) {
    final c = s.codeUnitAt(i);
    if (c == 0x28) {
      n++; // (
    } else if (c == 0x29) {
      n--; // )
    }
  }
  return n;
}

bool _isOp(String ch) =>
    ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == '^' || ch == '%';

bool _isFn(String s) =>
    s == 'sin' || s == 'cos' || s == 'tan' || s == 'log' || s == 'ln' || s == '√';

// ---------------------------------------------------------------------------
// Internal exceptions
// ---------------------------------------------------------------------------

class _ParseEx implements Exception {
  const _ParseEx(this.msg);
  final String msg;
}

class _DivByZero implements Exception {}

// ---------------------------------------------------------------------------
// Recursive-descent parser
// ---------------------------------------------------------------------------

const List<String> _kFunctions = ['sin', 'cos', 'tan', 'log', 'ln'];

class _UmumParser {
  _UmumParser(this._src, this._mode);

  final String _src;
  final AngleMode _mode;
  int _pos = 0;

  bool get isAtEnd => _pos >= _src.length;
  String get _cur => isAtEnd ? '' : _src[_pos];

  // expr = term ( ('+' | '-') term )*
  double parseExpr() {
    var result = _parseTerm();
    while (!isAtEnd && (_cur == '+' || _cur == '-')) {
      final op = _cur;
      _pos++;
      final right = _parseTerm();
      result = op == '+' ? result + right : result - right;
    }
    return result;
  }

  // term = unary ( ('*' | '/' | '%') unary )*
  double _parseTerm() {
    var result = _parseUnary();
    while (!isAtEnd && (_cur == '*' || _cur == '/' || _cur == '%')) {
      final op = _cur;
      _pos++;
      final right = _parseUnary();
      if (op == '/') {
        if (right == 0) throw _DivByZero();
        result = result / right;
      } else if (op == '%') {
        result = result * right / 100;
      } else {
        result = result * right;
      }
    }
    return result;
  }

  // unary = '-' unary | power
  // Unary minus binds looser than '^', so -2^2 = -(2^2) = -4.
  double _parseUnary() {
    _skip();
    if (!isAtEnd && _cur == '-') {
      _pos++;
      return -_parseUnary();
    }
    return _parsePower();
  }

  // power = primary ( '^' unary )?
  // Right-associative: 2^3^2 = 2^(3^2) = 512, and 2^-1 is allowed.
  double _parsePower() {
    final base = _parsePrimary();
    _skip();
    if (!isAtEnd && _cur == '^') {
      _pos++;
      final exp = _parseUnary();
      return math.pow(base, exp).toDouble();
    }
    return base;
  }

  // primary = NUMBER | CONST | fn '(' expr ')' | '(' expr ')' | '√' primary
  double _parsePrimary() {
    _skip();
    if (isAtEnd) throw const _ParseEx('Ekspresi tidak lengkap');

    // π constant
    if (_cur == 'π') {
      _pos++;
      return math.pi;
    }

    // e constant
    if (_cur == 'e') {
      // peek ahead: could be start of 'e' inside a number? No — we normalise
      // numbers before calling the parser. So a bare 'e' = Euler's number.
      _pos++;
      return math.e;
    }

    // √ (square root) as prefix operator
    if (_cur == '√') {
      _pos++;
      final v = _parsePrimary();
      if (v < 0) throw const _ParseEx('Akar dari bilangan negatif');
      return math.sqrt(v);
    }

    // Named functions: sin, cos, tan, log, ln
    for (final fn in _kFunctions) {
      if (_src.startsWith(fn, _pos)) {
        _pos += fn.length;
        _skip();
        if (isAtEnd || _cur != '(') throw _ParseEx('Fungsi $fn perlu ( … )');
        _pos++; // consume '('
        final arg = parseExpr();
        _skip();
        if (isAtEnd || _cur != ')') throw _ParseEx('Kurung tutup "$fn" tidak ada');
        _pos++; // consume ')'
        return _applyFn(fn, arg);
      }
    }

    // Parenthesised sub-expression
    if (_cur == '(') {
      _pos++;
      final v = parseExpr();
      _skip();
      if (isAtEnd || _cur != ')') throw const _ParseEx('Kurung penutup tidak ditemukan');
      _pos++;
      return v;
    }

    // Number literal
    final c = _src.codeUnitAt(_pos);
    if (_isDigitCode(c) || c == 0x2E /* . */) {
      return _parseNumber();
    }

    throw _ParseEx('Karakter tidak dikenal: "$_cur"');
  }

  double _applyFn(String fn, double arg) {
    final rad = _mode == AngleMode.deg ? arg * math.pi / 180 : arg;
    return switch (fn) {
      'sin' => math.sin(rad),
      'cos' => math.cos(rad),
      'tan' => math.cos(rad).abs() < 1e-12
          ? throw const _ParseEx('tan tidak terdefinisi')
          : math.tan(rad),
      'log' => (arg <= 0)
          ? throw const _ParseEx('log perlu argumen positif')
          : math.log(arg) / math.ln10,
      'ln'  => (arg <= 0)
          ? throw const _ParseEx('ln perlu argumen positif')
          : math.log(arg),
      _     => throw _ParseEx('Fungsi tidak dikenal: $fn'),
    };
  }

  double _parseNumber() {
    final start = _pos;
    while (!isAtEnd && _isDigitCode(_src.codeUnitAt(_pos))) { _pos++; }
    if (!isAtEnd && _cur == '.') {
      _pos++;
      while (!isAtEnd && _isDigitCode(_src.codeUnitAt(_pos))) { _pos++; }
    }
    return double.parse(_src.substring(start, _pos));
  }

  void _skip() {
    while (!isAtEnd && _cur == ' ') { _pos++; }
  }
}
