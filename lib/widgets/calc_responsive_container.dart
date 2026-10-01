import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/responsive.dart';

/// Callback when a hardware keyboard key is pressed for calculator inputs.
typedef CalculatorKeyHandler = void Function(String key);

/// Responsive container wrapper for calculator screens.
/// Features:
/// 1. Centers content in a ConstrainedBox on Desktop/Tablet screens.
/// 2. Listens to hardware keyboard events (digits, operators, Enter, Backspace, Escape).
/// 3. Ensures no RenderFlex overflow occurs on small height screens / landscape mode.
class CalcResponsiveContainer extends StatefulWidget {
  const CalcResponsiveContainer({
    super.key,
    required this.child,
    this.onKeyInput,
    this.maxWidth = 480,
    this.backgroundColor,
  });

  final Widget child;
  final CalculatorKeyHandler? onKeyInput;
  final double maxWidth;
  final Color? backgroundColor;

  @override
  State<CalcResponsiveContainer> createState() =>
      _CalcResponsiveContainerState();
}

class _CalcResponsiveContainerState extends State<CalcResponsiveContainer> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent || widget.onKeyInput == null) return;

    final key = event.logicalKey;
    final char = event.character;

    // Check Escape -> AC
    if (key == LogicalKeyboardKey.escape) {
      widget.onKeyInput!('AC');
      return;
    }

    // Check Backspace / Delete -> ⌫
    if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
      widget.onKeyInput!('⌫');
      return;
    }

    // Check Enter -> =
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      widget.onKeyInput!('=');
      return;
    }

    // Check characters first for shift combinations
    if (char != null && char.isNotEmpty) {
      if (RegExp(r'^[0-9]$').hasMatch(char)) {
        widget.onKeyInput!(char);
        return;
      }
      switch (char) {
        case '+':
          widget.onKeyInput!('+');
          return;
        case '-':
          widget.onKeyInput!('-');
          return;
        case '*':
        case 'x':
        case 'X':
          widget.onKeyInput!('×');
          return;
        case '/':
        case ':':
          widget.onKeyInput!('÷');
          return;
        case '=':
          widget.onKeyInput!('=');
          return;
        case ',':
        case '.':
          widget.onKeyInput!(',');
          return;
        case '%':
          widget.onKeyInput!('%');
          return;
        case '(':
          widget.onKeyInput!('(');
          return;
        case ')':
          widget.onKeyInput!(')');
          return;
      }
    }

    // Fallback based on logical keys
    if (key == LogicalKeyboardKey.numpadAdd || key == LogicalKeyboardKey.add) {
      widget.onKeyInput!('+');
    } else if (key == LogicalKeyboardKey.numpadSubtract || key == LogicalKeyboardKey.minus) {
      widget.onKeyInput!('-');
    } else if (key == LogicalKeyboardKey.numpadMultiply || key == LogicalKeyboardKey.asterisk) {
      widget.onKeyInput!('×');
    } else if (key == LogicalKeyboardKey.numpadDivide || key == LogicalKeyboardKey.slash) {
      widget.onKeyInput!('÷');
    } else if (key == LogicalKeyboardKey.period || key == LogicalKeyboardKey.comma || key == LogicalKeyboardKey.numpadDecimal) {
      widget.onKeyInput!(',');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        _handleKeyEvent(event);
        return KeyEventResult.ignored;
      },
      child: Container(
        color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        alignment: Alignment.center,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContainerWidth(screenWidth).clamp(0.0, widget.maxWidth),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
