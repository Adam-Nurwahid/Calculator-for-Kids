import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_kids/screens/rumus/detail/geometri/geometry_formulas_screen.dart';

void main() {
  testWidgets('GeometryFormulasScreen loads 6 category tabs and allows navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GeometryFormulasScreen(initialIndex: 0),
      ),
    );
    await tester.pumpAndSettle();

    // Verify category tabs are present in RumusHeader
    expect(find.text('Bangun Datar'), findsWidgets);
    expect(find.text('Bangun Ruang'), findsWidgets);
    expect(find.text('Pecahan'), findsWidgets);
    expect(find.text('Pangkat'), findsWidgets);
    expect(find.text('Konversi Persen'), findsWidgets);
    expect(find.text('Akar Kuadrat'), findsWidgets);

    // Tap index 1 (Bangun Ruang)
    await tester.tap(find.text('Bangun Ruang').first);
    await tester.pumpAndSettle();
    expect(find.text('Kubus'), findsOneWidget);

    // Tap index 2 (Pecahan)
    await tester.tap(find.text('Pecahan').first);
    await tester.pumpAndSettle();
    expect(find.text('Pecahan Biasa'), findsOneWidget);
  });
}
