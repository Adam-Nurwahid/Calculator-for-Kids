import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_kids/logic/percent_conversion_logic.dart';

void main() {
  group('Percent Conversion Logic Tests', () {
    test('Persen to Desimal (25% = 0,25)', () {
      final state = PercentConversionState(
        fromUnit: ConversionUnit.persen,
        toUnit: ConversionUnit.desimal,
      );
      state.inputDigit('2');
      state.inputDigit('5');
      final res = state.calculateResult();

      expect(res?.isSuccess, true);
      expect(res?.formattedResult, '0,25');
      expect(res?.ratioValue, 0.25);
    });

    test('Persen to Pecahan (25% = 1/4)', () {
      final state = PercentConversionState(
        fromUnit: ConversionUnit.persen,
        toUnit: ConversionUnit.pecahan,
      );
      state.inputDigit('2');
      state.inputDigit('5');
      final res = state.calculateResult();

      expect(res?.isSuccess, true);
      expect(res?.formattedResult, '1/4');
      expect(res?.fraction?.numerator, 1);
      expect(res?.fraction?.denominator, 4);
    });

    test('Desimal to Persen (0,5 = 50%)', () {
      final state = PercentConversionState(
        fromUnit: ConversionUnit.desimal,
        toUnit: ConversionUnit.persen,
      );
      state.inputDigit('0');
      state.inputDigit(',');
      state.inputDigit('5');
      final res = state.calculateResult();

      expect(res?.isSuccess, true);
      expect(res?.formattedResult, '50%');
      expect(res?.ratioValue, 0.5);
    });

    test('Desimal to Pecahan (0,5 = 1/2)', () {
      final state = PercentConversionState(
        fromUnit: ConversionUnit.desimal,
        toUnit: ConversionUnit.pecahan,
      );
      state.inputDigit('0');
      state.inputDigit(',');
      state.inputDigit('5');
      final res = state.calculateResult();

      expect(res?.isSuccess, true);
      expect(res?.formattedResult, '1/2');
    });

    test('Unit swapping (swapUnits)', () {
      final state = PercentConversionState(
        fromUnit: ConversionUnit.persen,
        toUnit: ConversionUnit.desimal,
      );
      state.inputDigit('2');
      state.inputDigit('5');
      expect(state.calculateResult()?.formattedResult, '0,25');

      // Swap Persen->Desimal to Desimal->Persen
      state.swapUnits();
      expect(state.fromUnit, ConversionUnit.desimal);
      expect(state.toUnit, ConversionUnit.persen);
      expect(state.rawInput, '0,25');
      expect(state.calculateResult()?.formattedResult, '25%');
    });

    test('Comma decimal and backspace handling', () {
      final state = PercentConversionState(
        fromUnit: ConversionUnit.persen,
        toUnit: ConversionUnit.desimal,
      );
      state.inputDigit('1');
      state.inputDigit('2');
      state.inputDigit(',');
      state.inputDigit(','); // Second comma should be rejected
      state.inputDigit('5');

      expect(state.rawInput, '12,5');
      expect(state.calculateResult()?.formattedResult, '0,125');

      state.backspace();
      expect(state.rawInput, '12,');

      state.clearAll();
      expect(state.rawInput, '');
      expect(state.calculateResult(), null);
    });
  });
}
