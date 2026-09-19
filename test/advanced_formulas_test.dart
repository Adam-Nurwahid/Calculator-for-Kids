import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_kids/screens/rumus/detail/umum1/advanced_formulas_screen.dart';

void main() {
  testWidgets('AdvancedFormulasScreen loads 7 category tabs and allows navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AdvancedFormulasScreen(initialIndex: 0),
      ),
    );
    await tester.pumpAndSettle();

    // Verify category tabs are present in RumusHeader
    expect(find.text('Pecahan'), findsWidgets);
    expect(find.text('Pangkat'), findsWidgets);
    expect(find.text('Konversi Persen'), findsWidgets);
    expect(find.text('Peluang'), findsWidgets);
    expect(find.text('Aljabar'), findsWidgets);
    expect(find.text('Statistika'), findsWidgets);
    expect(find.text('Bangun Ruang'), findsWidgets);

    // Tap index 1 (Pangkat)
    await tester.tap(find.text('Pangkat').first);
    await tester.pumpAndSettle();
    expect(find.text('Pangkat (Eksponen)'), findsOneWidget);

    // Tap index 3 (Peluang)
    await tester.tap(find.text('Peluang').first);
    await tester.pumpAndSettle();
    expect(find.text('Peluang (Probabilitas)'), findsOneWidget);

    // Tap index 6 (Bangun Ruang)
    await tester.tap(find.text('Bangun Ruang').first);
    await tester.pumpAndSettle();
    expect(find.text('Kubus'), findsOneWidget);
  });
}
