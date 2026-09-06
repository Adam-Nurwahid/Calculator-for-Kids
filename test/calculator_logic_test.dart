import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_kids/logic/calculator_logic.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Basic arithmetic
  // ---------------------------------------------------------------------------

  group('Basic operations', () {
    test('Addition: 2 + 3 = 5', () {
      final r = evaluateExpression('2+3');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '5');
    });

    test('Subtraction: 10 - 4 = 6', () {
      final r = evaluateExpression('10-4');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '6');
    });

    test('Multiplication with × symbol: 3 × 4 = 12', () {
      final r = evaluateExpression('3×4');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '12');
    });

    test('Multiplication with * symbol: 3 * 4 = 12', () {
      final r = evaluateExpression('3*4');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '12');
    });

    test('Division with ÷ symbol: 8 ÷ 2 = 4', () {
      final r = evaluateExpression('8÷2');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '4');
    });

    test('Division with / symbol: 8 / 2 = 4', () {
      final r = evaluateExpression('8/2');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '4');
    });

    test('Single number: 42 = 42', () {
      final r = evaluateExpression('42');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '42');
    });
  });

  // ---------------------------------------------------------------------------
  // Order of operations
  // ---------------------------------------------------------------------------

  group('Order of operations', () {
    test('2 + 3 × 4 = 14 (multiplication before addition)', () {
      final r = evaluateExpression('2+3×4');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '14');
    });

    test('10 - 2 × 3 = 4', () {
      final r = evaluateExpression('10-2×3');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '4');
    });

    test('12 ÷ 4 + 1 = 4', () {
      final r = evaluateExpression('12÷4+1');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '4');
    });
  });

  // ---------------------------------------------------------------------------
  // Parentheses
  // ---------------------------------------------------------------------------

  group('Parentheses', () {
    test('(2 + 3) × 4 = 20', () {
      final r = evaluateExpression('(2+3)×4');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '20');
    });

    test('(10 - 4) × (2 + 1) = 18', () {
      final r = evaluateExpression('(10-4)×(2+1)');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '18');
    });

    test('Nested parens: ((2 + 3)) = 5', () {
      final r = evaluateExpression('((2+3))');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '5');
    });
  });

  // ---------------------------------------------------------------------------
  // Division by zero
  // ---------------------------------------------------------------------------

  group('Division by zero', () {
    test('5 ÷ 0 → CalcError', () {
      final r = evaluateExpression('5÷0');
      expect(r, isA<CalcError>());
      expect((r as CalcError).message, contains('bagi nol'));
    });

    test('(3 + 2) ÷ 0 → CalcError', () {
      final r = evaluateExpression('(3+2)÷0');
      expect(r, isA<CalcError>());
    });

    test('0 ÷ 0 → CalcError', () {
      final r = evaluateExpression('0÷0');
      expect(r, isA<CalcError>());
    });
  });

  // ---------------------------------------------------------------------------
  // Invalid / edge-case expressions
  // ---------------------------------------------------------------------------

  group('Invalid expressions', () {
    test('Empty string → CalcError', () {
      final r = evaluateExpression('');
      expect(r, isA<CalcError>());
    });

    test('Whitespace only → CalcError', () {
      final r = evaluateExpression('   ');
      expect(r, isA<CalcError>());
    });

    test('Unmatched open paren (3+4 → CalcError', () {
      final r = evaluateExpression('(3+4');
      expect(r, isA<CalcError>());
    });

    test('Expression ending with operator 3+ → CalcError', () {
      final r = evaluateExpression('3+');
      expect(r, isA<CalcError>());
    });
  });

  // ---------------------------------------------------------------------------
  // Integer display formatting
  // ---------------------------------------------------------------------------

  group('Display formatting', () {
    test('Whole-number division displays without decimal: 9 ÷ 3 → "3"', () {
      final r = evaluateExpression('9÷3');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '3');
    });

    test('Non-whole division shows decimal: 7 ÷ 2 → "3.5"', () {
      final r = evaluateExpression('7÷2');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '3.5');
    });

    test('Large whole result: 100 × 100 → "10000"', () {
      final r = evaluateExpression('100×100');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).display, '10000');
    });
  });

  // ---------------------------------------------------------------------------
  // canAppendToken validation
  // ---------------------------------------------------------------------------

  group('canAppendToken input guard', () {
    test('Empty expression accepts digit', () {
      expect(canAppendToken('', '5'), isTrue);
    });

    test('Empty expression rejects operator', () {
      expect(canAppendToken('', '+'), isFalse);
    });

    test('After digit accepts operator', () {
      expect(canAppendToken('3', '+'), isTrue);
    });

    test('After operator rejects another operator', () {
      expect(canAppendToken('3+', '+'), isFalse);
      expect(canAppendToken('3+', '×'), isFalse);
    });

    test('After close paren rejects digit (no implicit multiply)', () {
      expect(canAppendToken('(3+2)', '5'), isFalse);
    });

    test('After close paren accepts operator', () {
      expect(canAppendToken('(3+2)', '+'), isTrue);
    });

    test('Close paren with no open paren is rejected', () {
      expect(canAppendToken('3', ')'), isFalse);
    });

    test('Close paren with matching open paren is accepted', () {
      expect(canAppendToken('(3+2', ')'), isTrue);
    });
  });
}
