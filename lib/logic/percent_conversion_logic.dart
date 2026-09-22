// lib/logic/percent_conversion_logic.dart

import 'dart:math' as math;
import 'fraction_calculator_logic.dart';

enum ConversionUnit { persen, desimal, pecahan }

extension ConversionUnitExtension on ConversionUnit {
  String get label {
    switch (this) {
      case ConversionUnit.persen:
        return 'Persen';
      case ConversionUnit.desimal:
        return 'Desimal';
      case ConversionUnit.pecahan:
        return 'Pecahan';
    }
  }

  String get symbol {
    switch (this) {
      case ConversionUnit.persen:
        return '%';
      case ConversionUnit.desimal:
      case ConversionUnit.pecahan:
        return '';
    }
  }
}

class PercentConversionState {
  ConversionUnit fromUnit;
  ConversionUnit toUnit;

  String rawInput;
  String? errorMessage;

  PercentConversionState({
    this.fromUnit = ConversionUnit.persen,
    this.toUnit = ConversionUnit.desimal,
    this.rawInput = '',
    this.errorMessage,
  });

  void setFromUnit(ConversionUnit unit) {
    fromUnit = unit;
  }

  void setToUnit(ConversionUnit unit) {
    toUnit = unit;
  }

  void swapUnits() {
    final currentRes = calculateResult();
    final temp = fromUnit;
    fromUnit = toUnit;
    toUnit = temp;

    if (currentRes != null && currentRes.isSuccess && currentRes.ratioValue != null) {
      final ratio = currentRes.ratioValue!;
      if (fromUnit == ConversionUnit.persen) {
        rawInput = formatNumber(ratio * 100.0);
      } else {
        rawInput = formatNumber(ratio);
      }
    }
  }

  void clearAll() {
    rawInput = '';
    errorMessage = null;
  }

  void backspace() {
    errorMessage = null;
    if (rawInput.isNotEmpty) {
      rawInput = rawInput.substring(0, rawInput.length - 1);
    }
  }

  void inputDigit(String val) {
    errorMessage = null;

    if (val == '-') {
      if (rawInput.startsWith('-')) {
        rawInput = rawInput.substring(1);
      } else {
        rawInput = '-$rawInput';
      }
    } else if (val == ',') {
      if (!rawInput.contains(',')) {
        if (rawInput.isEmpty || rawInput == '-') {
          rawInput += '0,';
        } else {
          rawInput += ',';
        }
      }
    } else if (val == '00') {
      if (rawInput.isEmpty || rawInput == '0') {
        rawInput = '0';
      } else if (rawInput == '-') {
        rawInput = '-0';
      } else {
        rawInput += '00';
      }
    } else {
      if (rawInput == '0') {
        rawInput = val;
      } else if (rawInput == '-0') {
        rawInput = '-$val';
      } else {
        rawInput += val;
      }
    }
  }

  PercentConversionResult? calculateResult() {
    if (rawInput.isEmpty || rawInput == '-') {
      return null;
    }

    final numVal = double.tryParse(rawInput.replaceAll(',', '.'));
    if (numVal == null) {
      return const PercentConversionResult.error('Input tidak valid');
    }

    double ratio;
    if (fromUnit == ConversionUnit.persen) {
      ratio = numVal / 100.0;
    } else {
      ratio = numVal;
    }

    if (ratio.isNaN || ratio.isInfinite) {
      return const PercentConversionResult.error('Hasil tidak terdefinisi');
    }

    if (toUnit == ConversionUnit.persen) {
      final pVal = ratio * 100.0;
      final formatted = '${formatNumber(pVal)}%';
      return PercentConversionResult.success(
        formattedResult: formatted,
        ratioValue: ratio,
      );
    } else if (toUnit == ConversionUnit.desimal) {
      final formatted = formatNumber(ratio);
      return PercentConversionResult.success(
        formattedResult: formatted,
        ratioValue: ratio,
      );
    } else if (toUnit == ConversionUnit.pecahan) {
      final frac = doubleToFraction(ratio);
      final formatted = frac.toFormattedString(preferMixed: true);
      return PercentConversionResult.success(
        formattedResult: formatted,
        fraction: frac,
        ratioValue: ratio,
      );
    }

    return null;
  }

  static Fraction doubleToFraction(double val) {
    if (val == 0) return const Fraction(0, 1);
    final sign = val < 0 ? -1 : 1;
    final absVal = val.abs();

    if (absVal == absVal.truncateToDouble() && absVal < 1e12) {
      return Fraction(sign * absVal.toInt(), 1);
    }

    final str = absVal.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '');
    final decPlaces = str.contains('.') ? str.split('.')[1].length : 0;
    final mult = math.pow(10, decPlaces).toInt();
    final num = (absVal * mult).round();
    final den = mult;
    return Fraction(sign * num, den).simplify();
  }

  static String formatNumber(double val) {
    if (val.truncateToDouble() == val && val.abs() < 1e15) {
      return val.toInt().toString();
    }

    String str = val.toStringAsFixed(8);
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0+$'), '');
      str = str.replaceAll(RegExp(r'\.$'), '');
    }
    return str.replaceAll('.', ',');
  }
}

class PercentConversionResult {
  final String? formattedResult;
  final Fraction? fraction;
  final double? ratioValue;
  final String? error;

  const PercentConversionResult.success({
    required this.formattedResult,
    this.fraction,
    this.ratioValue,
  }) : error = null;

  const PercentConversionResult.error(this.error)
      : formattedResult = null,
        fraction = null,
        ratioValue = null;

  bool get isSuccess => error == null && formattedResult != null;
  bool get isError => error != null;
}
