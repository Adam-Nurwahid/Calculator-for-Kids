// Calculator logic for the "Kalkulator Anak" (Kids Calculator) screen.
//
// Implements a hand-written recursive-descent parser that evaluates
// arithmetic expressions with +, -, *, / and parentheses, following
// standard order of operations (PEMDAS/BODMAS).
//
// Why a custom parser instead of a pub.dev package like `math_expressions`?
// - Zero extra dependencies — no pubspec.yaml changes needed.
// - Full control over kid-friendly error messages in Bahasa Indonesia.
// - ~100 lines of pure Dart — trivially testable in isolation.
// - Exposes only the four basic operations appropriate for "Anak" level.
//
// Grammar (EBNF):
//   expr   = term   ( ( '+' | '-' ) term   )*
//   term   = factor ( ( '*' | '/' ) factor )*
//   factor = NUMBER | '(' expr ')' | '-' factor


// ---------------------------------------------------------------------------
// Result type
// ---------------------------------------------------------------------------

/// Sealed result returned by [evaluateExpression].
sealed class CalcResult {
  const CalcResult();
}

/// A successful calculation with a numeric [value].
final class CalcSuccess extends CalcResult {
  const CalcSuccess(this.value);
  final num value;

  /// Returns a display string: integer when the value is whole, decimal otherwise.
  String get display {
    if (value is int || value == value.truncate()) {
      return value.truncate().toString();
    }
    // Round to 2 decimal places max for readability
    return double.parse(value.toStringAsFixed(2)).toString();
  }
}

/// A calculation that failed, carrying a kid-friendly [message].
final class CalcError extends CalcResult {
  const CalcError(this.message);
  final String message;
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/// Evaluates an arithmetic [expression] string.
///
/// Accepts `×` and `÷` as aliases for `*` and `/`.
/// Returns [CalcSuccess] or [CalcError].
CalcResult evaluateExpression(String expression) {
  if (expression.trim().isEmpty) {
    return const CalcError('Masukkan angka dulu ya! 😊');
  }

  // Normalize display operators to ASCII
  final normalized = expression
      .replaceAll('×', '*')
      .replaceAll('÷', '/')
      .replaceAll(' ', '');

  try {
    final parser = _Parser(normalized);
    final result = parser.parseExpr();

    // Ensure we consumed the entire input
    if (!parser.isAtEnd) {
      return const CalcError('Ekspresi tidak lengkap 🤔');
    }

    return CalcSuccess(result);
  } on _DivisionByZeroException {
    return const CalcError('Oops! Tidak bisa bagi nol 😅');
  } on _ParseException catch (e) {
    return CalcError(e.message);
  } catch (_) {
    return const CalcError('Ada yang salah, coba lagi! 🤔');
  }
}

// ---------------------------------------------------------------------------
// Input validation helpers (used by the UI to guard button presses)
// ---------------------------------------------------------------------------

/// Returns `true` if appending [token] to [expression] is a valid move.
///
/// Prevents:
///  - Two operators in a row (e.g. "3++")
///  - Leading operator (except minus for negation, which we disallow for kids)
///  - Operator immediately after open paren
///  - Number immediately after close paren (implicit multiplication not shown)
bool canAppendToken(String expression, String token) {
  final last = expression.isEmpty ? '' : expression[expression.length - 1];
  final isOperator = _isOperatorChar(token);
  final isDigit = RegExp(r'\d').hasMatch(token);
  final isOpenParen = token == '(';
  final isCloseParen = token == ')';

  if (expression.isEmpty) {
    // Only digits or '(' allowed at start
    return isDigit || isOpenParen;
  }

  if (isOperator) {
    // Can't place operator after another operator, or after '('
    return !_isOperatorChar(last) && last != '(';
  }

  if (isDigit) {
    // Can't place digit right after ')'
    return last != ')';
  }

  if (isOpenParen) {
    // '(' can follow an operator or another '('
    return _isOperatorChar(last) || last == '(';
  }

  if (isCloseParen) {
    // ')' must have a matching '(' and can't follow an operator or '('
    final opens = expression.split('(').length - 1;
    final closes = expression.split(')').length - 1;
    return opens > closes && !_isOperatorChar(last) && last != '(';
  }

  return true;
}

bool _isOperatorChar(String ch) => ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == '×' || ch == '÷';

// ---------------------------------------------------------------------------
// Internal parser
// ---------------------------------------------------------------------------

class _ParseException implements Exception {
  const _ParseException(this.message);
  final String message;
}

class _DivisionByZeroException implements Exception {}

class _Parser {
  _Parser(this._input);

  final String _input;
  int _pos = 0;

  bool get isAtEnd => _pos >= _input.length;
  String get _current => isAtEnd ? '' : _input[_pos];

  // expr = term ( ('+' | '-') term )*
  num parseExpr() {
    var result = _parseTerm();

    while (!isAtEnd && (_current == '+' || _current == '-')) {
      final op = _current;
      _pos++;
      final right = _parseTerm();
      result = op == '+' ? result + right : result - right;
    }

    return result;
  }

  // term = factor ( ('*' | '/') factor )*
  num _parseTerm() {
    var result = _parseFactor();

    while (!isAtEnd && (_current == '*' || _current == '/')) {
      final op = _current;
      _pos++;
      final right = _parseFactor();
      if (op == '/') {
        if (right == 0) throw _DivisionByZeroException();
        result = result / right;
      } else {
        result = result * right;
      }
    }

    return result;
  }

  // factor = NUMBER | '(' expr ')' | '-' factor
  num _parseFactor() {
    _skipWhitespace();

    if (isAtEnd) {
      throw const _ParseException('Ekspresi tidak lengkap 🤔');
    }

    // Unary minus (kids mode: limited, but handle gracefully)
    if (_current == '-') {
      _pos++;
      return -_parseFactor();
    }

    // Parenthesised sub-expression
    if (_current == '(') {
      _pos++; // consume '('
      final result = parseExpr();
      if (isAtEnd || _current != ')') {
        throw const _ParseException('Kurung tutup ketinggalan! 🤔');
      }
      _pos++; // consume ')'
      return result;
    }

    // Number literal
    if (RegExp(r'\d').hasMatch(_current)) {
      return _parseNumber();
    }

    throw _ParseException('Karakter tidak dikenal: "$_current" 😕');
  }

  num _parseNumber() {
    final start = _pos;
    while (!isAtEnd && RegExp(r'\d').hasMatch(_current)) {
      _pos++;
    }
    // Support decimal input (even though kids mode discourages it)
    if (!isAtEnd && _current == '.') {
      _pos++;
      while (!isAtEnd && RegExp(r'\d').hasMatch(_current)) {
        _pos++;
      }
      return double.parse(_input.substring(start, _pos));
    }
    return int.parse(_input.substring(start, _pos));
  }

  void _skipWhitespace() {
    while (!isAtEnd && _current == ' ') {
      _pos++;
    }
  }
}
