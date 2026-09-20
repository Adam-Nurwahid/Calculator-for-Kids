import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_kids/screens/rumus/detail/umum1/advanced_formulas_screen.dart';

void main() {
  testWidgets('AdvancedFormulasScreen loads 6 category tabs and allows navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AdvancedFormulasScreen(initialIndex: 0),
      ),
    );
    await tester.pumpAndSettle();

    // Verify category tabs are present in RumusHeader
    expect(find.text('Trigonometri'), findsWidgets);
    expect(find.text('Deg/Rad'), findsWidgets);
    expect(find.text('Logaritma'), findsWidgets);
    expect(find.text('Peluang'), findsWidgets);
    expect(find.text('Statistika'), findsWidgets);
    expect(find.text('Barisan & Deret'), findsWidgets);

    // Tap index 0 (Trigonometri)
    await tester.tap(find.text('Trigonometri').first);
    await tester.pumpAndSettle();
    expect(find.text('📋 Definisi SOH-CAH-TOA'), findsOneWidget);

    // Tap index 3 (Peluang)
    await tester.tap(find.text('Peluang').first);
    await tester.pumpAndSettle();
    expect(find.text('Peluang (Probabilitas)'), findsOneWidget);

    // Tap index 2 (Logaritma)
    await tester.tap(find.text('Logaritma').first);
    await tester.pumpAndSettle();
    expect(find.text('Logaritma'), findsWidgets);
  });
}
