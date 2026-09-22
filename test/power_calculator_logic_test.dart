import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_kids/logic/power_calculator_logic.dart';

void main() {
  group('Power Logic Tests', () {
    test('Square calculation (3² = 9)', () {
      final state = PowerCalculatorState(mode: PowerMode.square);
      state.inputDigit('3');
      final res = state.calculateResult();
      expect(res?.isSuccess, true);
      expect(res?.value, 9.0);
      expect(res?.formattedValue, '9');
    });

    test('Custom power calculation (3⁴ = 81)', () {
      final state = PowerCalculatorState(mode: PowerMode.custom);
      state.selectSlot(PowerSlot.base);
      state.inputDigit('3');
      state.selectSlot(PowerSlot.exponent);
      state.inputDigit('4');
      final res = state.calculateResult();
      expect(res?.isSuccess, true);
      expect(res?.value, 81.0);
      expect(res?.formattedValue, '81');
    });

    test('Negative base calculation ((-3)² = 9, (-3)³ = -27)', () {
      final stateSq = PowerCalculatorState(mode: PowerMode.square);
      stateSq.inputDigit('-');
      stateSq.inputDigit('3');
      final resSq = stateSq.calculateResult();
      expect(resSq?.isSuccess, true);
      expect(resSq?.value, 9.0);
      expect(resSq?.formattedValue, '9');

      final stateCube = PowerCalculatorState(mode: PowerMode.custom);
      stateCube.selectSlot(PowerSlot.base);
      stateCube.inputDigit('-');
      stateCube.inputDigit('3');
      stateCube.selectSlot(PowerSlot.exponent);
      stateCube.inputDigit('3');
      final resCube = stateCube.calculateResult();
      expect(resCube?.isSuccess, true);
      expect(resCube?.value, -27.0);
      expect(resCube?.formattedValue, '-27');
    });

    test('Decimal base calculation (2,5² = 6.25)', () {
      final state = PowerCalculatorState(mode: PowerMode.square);
      state.inputDigit('2');
      state.inputDigit(',');
      state.inputDigit('5');
      final res = state.calculateResult();
      expect(res?.isSuccess, true);
      expect(res?.value, 6.25);
      expect(res?.formattedValue, '6.25');
    });

    test('0^0 error case', () {
      final state = PowerCalculatorState(mode: PowerMode.custom);
      state.selectSlot(PowerSlot.base);
      state.inputDigit('0');
      state.selectSlot(PowerSlot.exponent);
      state.inputDigit('0');
      final res = state.calculateResult();
      expect(res?.isError, true);
      expect(res?.error, '0 pangkat 0 tidak terdefinisi');
    });

    test('Negative base with decimal exponent error case', () {
      final state = PowerCalculatorState(mode: PowerMode.custom);
      state.selectSlot(PowerSlot.base);
      state.inputDigit('-');
      state.inputDigit('4');
      state.selectSlot(PowerSlot.exponent);
      state.inputDigit('0');
      state.inputDigit(',');
      state.inputDigit('5');
      final res = state.calculateResult();
      expect(res?.isError, true);
      expect(res?.error, 'Basis negatif dengan eksponen desimal tidak terdefinisi');
    });

    test('PowerCalculatorState clearAll and backspace', () {
      final state = PowerCalculatorState(mode: PowerMode.custom);
      state.selectSlot(PowerSlot.base);
      state.inputDigit('1');
      state.inputDigit('2');
      state.backspace();
      expect(state.baseInput, '1');

      state.selectSlot(PowerSlot.exponent);
      state.inputDigit('3');
      state.clearAll();
      expect(state.baseInput, '');
      expect(state.exponentInput, '');
      expect(state.activeSlot, PowerSlot.base);
    });
  });
}
