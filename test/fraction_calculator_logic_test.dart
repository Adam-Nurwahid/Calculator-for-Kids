import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_kids/logic/fraction_calculator_logic.dart';

void main() {
  group('Fraction Logic Tests', () {
    test('Simplification test', () {
      final f1 = const Fraction(4, 2).simplify();
      expect(f1.numerator, 2);
      expect(f1.denominator, 1);

      final f2 = const Fraction(6, 8).simplify();
      expect(f2.numerator, 3);
      expect(f2.denominator, 4);
    });

    test('Addition test', () {
      final f1 = const Fraction(1, 2);
      final f2 = const Fraction(1, 4);
      final res = f1.add(f2);
      expect(res.numerator, 3);
      expect(res.denominator, 4);
    });

    test('Subtraction test', () {
      final f1 = const Fraction(3, 4);
      final f2 = const Fraction(1, 2);
      final res = f1.subtract(f2);
      expect(res.numerator, 1);
      expect(res.denominator, 4);
    });

    test('Multiplication test', () {
      final f1 = const Fraction(2, 3);
      final f2 = const Fraction(3, 4);
      final res = f1.multiply(f2);
      expect(res.numerator, 1);
      expect(res.denominator, 2);
    });

    test('Division test', () {
      final f1 = const Fraction(1, 2);
      final f2 = const Fraction(1, 4);
      final res = f1.divide(f2);
      expect(res.numerator, 2);
      expect(res.denominator, 1);
    });

    test('Mixed number creation & formatting', () {
      final f = Fraction.fromMixed(1, 1, 2); // 1 + 1/2 = 3/2
      expect(f.numerator, 3);
      expect(f.denominator, 2);

      final formatted = f.toFormattedString(preferMixed: true);
      expect(formatted, '1 1/2');

      final (w, rem, den) = f.toMixedParts();
      expect(w, 1);
      expect(rem, 1);
      expect(den, 2);
    });

    test('FractionCalculatorState computation', () {
      final state = FractionCalculatorState();
      // 1/2 + 1/2
      state.f1Num = '1';
      state.f1Den = '2';
      state.op = '+';
      state.f2Num = '1';
      state.f2Den = '2';

      final res = state.calculateResult();
      expect(res?.isSuccess, true);
      expect(res?.fraction?.toFormattedString(), '1');
    });
  });
}
