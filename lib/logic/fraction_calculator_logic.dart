// lib/logic/fraction_calculator_logic.dart

enum FractionMode { simple, mixed }

enum FractionSlot {
  f1Whole,
  f1Num,
  f1Den,
  f2Whole,
  f2Num,
  f2Den,
}

class Fraction {
  final int numerator;
  final int denominator;

  const Fraction(this.numerator, this.denominator);

  static int gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a == 0 ? 1 : a;
  }

  /// Simplifies the fraction to lowest terms.
  Fraction simplify() {
    if (denominator == 0) return this;
    int n = numerator;
    int d = denominator;
    if (d < 0) {
      n = -n;
      d = -d;
    }
    final g = gcd(n, d);
    return Fraction(n ~/ g, d ~/ g);
  }

  /// Creates a Fraction from whole, numerator, and denominator.
  factory Fraction.fromMixed(int whole, int num, int den) {
    if (den == 0) return Fraction(0, 0);
    final isNegative = whole < 0 || (whole == 0 && num < 0);
    final absWhole = whole.abs();
    final absNum = num.abs();
    final absDen = den.abs();
    final totalNum = absWhole * absDen + absNum;
    return Fraction(isNegative ? -totalNum : totalNum, absDen);
  }

  /// Converts an improper fraction to mixed representation tuple:
  /// (whole, remainderNumerator, denominator)
  (int whole, int remNum, int den) toMixedParts() {
    final simplified = simplify();
    if (simplified.denominator == 0) return (0, 0, 0);
    final w = simplified.numerator ~/ simplified.denominator;
    final rem = (simplified.numerator % simplified.denominator).abs();
    return (w, rem, simplified.denominator);
  }

  Fraction add(Fraction other) {
    if (denominator == 0 || other.denominator == 0) return const Fraction(0, 0);
    final n = numerator * other.denominator + other.numerator * denominator;
    final d = denominator * other.denominator;
    return Fraction(n, d).simplify();
  }

  Fraction subtract(Fraction other) {
    if (denominator == 0 || other.denominator == 0) return const Fraction(0, 0);
    final n = numerator * other.denominator - other.numerator * denominator;
    final d = denominator * other.denominator;
    return Fraction(n, d).simplify();
  }

  Fraction multiply(Fraction other) {
    if (denominator == 0 || other.denominator == 0) return const Fraction(0, 0);
    final n = numerator * other.numerator;
    final d = denominator * other.denominator;
    return Fraction(n, d).simplify();
  }

  Fraction divide(Fraction other) {
    if (denominator == 0 || other.denominator == 0 || other.numerator == 0) {
      return const Fraction(0, 0);
    }
    final n = numerator * other.denominator;
    final d = denominator * other.numerator;
    return Fraction(n, d).simplify();
  }

  double toDouble() {
    if (denominator == 0) return 0.0;
    return numerator / denominator;
  }

  /// Formatted text representation for display (e.g., "2 1/2", "3/4", "5")
  String toFormattedString({bool preferMixed = true}) {
    if (denominator == 0) return 'Tidak terdefinisi';
    final s = simplify();
    if (s.denominator == 1) {
      return '${s.numerator}';
    }
    if (s.numerator == 0) {
      return '0';
    }

    if (preferMixed && s.numerator.abs() > s.denominator) {
      final (w, rem, d) = s.toMixedParts();
      if (w != 0 && rem != 0) {
        return '$w $rem/$d';
      }
    }
    return '${s.numerator}/${s.denominator}';
  }
}

class FractionCalculatorState {
  FractionMode mode;
  FractionSlot activeSlot;

  String f1Whole;
  String f1Num;
  String f1Den;

  String op; // '+', '-', '×', '÷'

  String f2Whole;
  String f2Num;
  String f2Den;

  String? errorMessage;

  FractionCalculatorState({
    this.mode = FractionMode.simple,
    this.activeSlot = FractionSlot.f1Num,
    this.f1Whole = '',
    this.f1Num = '',
    this.f1Den = '',
    this.op = '+',
    this.f2Whole = '',
    this.f2Num = '',
    this.f2Den = '',
    this.errorMessage,
  });

  void setMode(FractionMode newMode) {
    mode = newMode;
    if (mode == FractionMode.simple) {
      if (activeSlot == FractionSlot.f1Whole) activeSlot = FractionSlot.f1Num;
      if (activeSlot == FractionSlot.f2Whole) activeSlot = FractionSlot.f2Num;
    } else {
      if (activeSlot == FractionSlot.f1Num && f1Whole.isEmpty) {
        activeSlot = FractionSlot.f1Whole;
      }
    }
  }

  void clearAll() {
    f1Whole = '';
    f1Num = '';
    f1Den = '';
    f2Whole = '';
    f2Num = '';
    f2Den = '';
    op = '+';
    errorMessage = null;
    activeSlot = mode == FractionMode.mixed ? FractionSlot.f1Whole : FractionSlot.f1Num;
  }

  void backspace() {
    errorMessage = null;
    switch (activeSlot) {
      case FractionSlot.f1Whole:
        if (f1Whole.isNotEmpty) {
          f1Whole = f1Whole.substring(0, f1Whole.length - 1);
        }
        break;
      case FractionSlot.f1Num:
        if (f1Num.isNotEmpty) {
          f1Num = f1Num.substring(0, f1Num.length - 1);
        } else if (mode == FractionMode.mixed) {
          activeSlot = FractionSlot.f1Whole;
        }
        break;
      case FractionSlot.f1Den:
        if (f1Den.isNotEmpty) {
          f1Den = f1Den.substring(0, f1Den.length - 1);
        } else {
          activeSlot = FractionSlot.f1Num;
        }
        break;
      case FractionSlot.f2Whole:
        if (f2Whole.isNotEmpty) {
          f2Whole = f2Whole.substring(0, f2Whole.length - 1);
        } else {
          activeSlot = FractionSlot.f1Den;
        }
        break;
      case FractionSlot.f2Num:
        if (f2Num.isNotEmpty) {
          f2Num = f2Num.substring(0, f2Num.length - 1);
        } else if (mode == FractionMode.mixed) {
          activeSlot = FractionSlot.f2Whole;
        } else {
          activeSlot = FractionSlot.f1Den;
        }
        break;
      case FractionSlot.f2Den:
        if (f2Den.isNotEmpty) {
          f2Den = f2Den.substring(0, f2Den.length - 1);
        } else {
          activeSlot = FractionSlot.f2Num;
        }
        break;
    }
  }

  void inputDigit(String val) {
    errorMessage = null;
    switch (activeSlot) {
      case FractionSlot.f1Whole:
        f1Whole += val;
        break;
      case FractionSlot.f1Num:
        f1Num += val;
        break;
      case FractionSlot.f1Den:
        f1Den += val;
        break;
      case FractionSlot.f2Whole:
        f2Whole += val;
        break;
      case FractionSlot.f2Num:
        f2Num += val;
        break;
      case FractionSlot.f2Den:
        f2Den += val;
        break;
    }
  }

  void selectSlot(FractionSlot slot) {
    if (mode == FractionMode.simple &&
        (slot == FractionSlot.f1Whole || slot == FractionSlot.f2Whole)) {
      return;
    }
    activeSlot = slot;
  }

  void setOperator(String newOp) {
    op = newOp;
    // Auto advance active slot to second fraction if first fraction has inputs
    if (activeSlot == FractionSlot.f1Whole ||
        activeSlot == FractionSlot.f1Num ||
        activeSlot == FractionSlot.f1Den) {
      activeSlot = mode == FractionMode.mixed ? FractionSlot.f2Whole : FractionSlot.f2Num;
    }
  }

  Fraction? getFraction1() {
    final w = int.tryParse(f1Whole) ?? 0;
    final n = int.tryParse(f1Num) ?? (f1Whole.isNotEmpty && mode == FractionMode.mixed ? 0 : null);
    final d = int.tryParse(f1Den) ?? 1;

    if (n == null) return null;
    if (d == 0) return null;

    if (mode == FractionMode.mixed) {
      return Fraction.fromMixed(w, n, d);
    } else {
      return Fraction(n, d);
    }
  }

  Fraction? getFraction2() {
    final w = int.tryParse(f2Whole) ?? 0;
    final n = int.tryParse(f2Num) ?? (f2Whole.isNotEmpty && mode == FractionMode.mixed ? 0 : null);
    final d = int.tryParse(f2Den) ?? 1;

    if (n == null) return null;
    if (d == 0) return null;

    if (mode == FractionMode.mixed) {
      return Fraction.fromMixed(w, n, d);
    } else {
      return Fraction(n, d);
    }
  }

  FractionResult? calculateResult() {
    final frac1 = getFraction1();
    final frac2 = getFraction2();

    if (frac1 == null || frac2 == null) {
      return null;
    }

    if (frac1.denominator == 0 || frac2.denominator == 0) {
      return FractionResult.error('Penyebut tidak boleh 0');
    }

    Fraction res;
    switch (op) {
      case '+':
        res = frac1.add(frac2);
        break;
      case '-':
        res = frac1.subtract(frac2);
        break;
      case '×':
      case '*':
        res = frac1.multiply(frac2);
        break;
      case '÷':
      case '/':
        if (frac2.numerator == 0) {
          return FractionResult.error('Pembagian dengan 0');
        }
        res = frac1.divide(frac2);
        break;
      default:
        res = frac1.add(frac2);
    }

    return FractionResult.success(res);
  }
}

class FractionResult {
  final Fraction? fraction;
  final String? error;

  const FractionResult.success(this.fraction) : error = null;
  const FractionResult.error(this.error) : fraction = null;

  bool get isSuccess => fraction != null;
  bool get isError => error != null;
}
