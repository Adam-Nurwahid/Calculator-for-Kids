// lib/logic/power_calculator_logic.dart

import 'dart:math';

enum PowerMode { square, custom }

enum PowerSlot { base, exponent }

class PowerCalculatorState {
  PowerMode mode;
  PowerSlot activeSlot;

  String baseInput;
  String exponentInput;

  String? errorMessage;

  PowerCalculatorState({
    this.mode = PowerMode.square,
    this.activeSlot = PowerSlot.base,
    this.baseInput = '',
    this.exponentInput = '',
    this.errorMessage,
  });

  void setMode(PowerMode newMode) {
    mode = newMode;
    if (mode == PowerMode.square) {
      activeSlot = PowerSlot.base;
    }
  }

  void selectSlot(PowerSlot slot) {
    if (mode == PowerMode.square && slot == PowerSlot.exponent) {
      return;
    }
    activeSlot = slot;
  }

  void clearAll() {
    baseInput = '';
    exponentInput = '';
    errorMessage = null;
    activeSlot = PowerSlot.base;
  }

  void backspace() {
    errorMessage = null;
    if (activeSlot == PowerSlot.base) {
      if (baseInput.isNotEmpty) {
        baseInput = baseInput.substring(0, baseInput.length - 1);
      }
    } else if (activeSlot == PowerSlot.exponent) {
      if (exponentInput.isNotEmpty) {
        exponentInput = exponentInput.substring(0, exponentInput.length - 1);
      } else {
        activeSlot = PowerSlot.base;
      }
    }
  }

  void inputDigit(String val) {
    errorMessage = null;
    if (mode == PowerMode.square && activeSlot == PowerSlot.exponent) {
      activeSlot = PowerSlot.base;
    }

    String current = activeSlot == PowerSlot.base ? baseInput : exponentInput;

    if (val == '-') {
      if (current.startsWith('-')) {
        current = current.substring(1);
      } else {
        current = '-$current';
      }
    } else if (val == ',') {
      if (!current.contains(',')) {
        if (current.isEmpty || current == '-') {
          current += '0,';
        } else {
          current += ',';
        }
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

    if (activeSlot == PowerSlot.base) {
      baseInput = current;
    } else {
      exponentInput = current;
    }
  }

  PowerResult? calculateResult() {
    final expStr = mode == PowerMode.square ? '2' : exponentInput;

    if (baseInput.isEmpty || expStr.isEmpty) {
      return null;
    }

    final baseNum = double.tryParse(baseInput.replaceAll(',', '.'));
    final expNum = double.tryParse(expStr.replaceAll(',', '.'));

    if (baseNum == null || expNum == null) {
      return const PowerResult.error('Input tidak valid');
    }

    if (baseNum == 0 && expNum == 0) {
      return const PowerResult.error('0 pangkat 0 tidak terdefinisi');
    }

    if (baseNum < 0 && (expNum.truncateToDouble() != expNum)) {
      return const PowerResult.error('Basis negatif dengan eksponen desimal tidak terdefinisi');
    }

    final resNum = pow(baseNum, expNum).toDouble();

    if (resNum.isNaN) {
      return const PowerResult.error('Hasil tidak terdefinisi');
    }

    if (resNum.isInfinite) {
      return const PowerResult.error('Hasil melebihi batas (overflow)');
    }

    final formatted = formatResult(resNum);
    return PowerResult.success(resNum, formatted);
  }

  static String formatResult(double val) {
    if (val.truncateToDouble() == val && val.abs() < 1e15) {
      return val.toInt().toString();
    }

    String str = val.toStringAsFixed(8);
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0+$'), '');
      str = str.replaceAll(RegExp(r'\.$'), '');
    }
    return str;
  }
}

class PowerResult {
  final double? value;
  final String? formattedValue;
  final String? error;

  const PowerResult.success(this.value, this.formattedValue) : error = null;
  const PowerResult.error(this.error)
      : value = null,
        formattedValue = null;

  bool get isSuccess => error == null && formattedValue != null;
  bool get isError => error != null;
}
