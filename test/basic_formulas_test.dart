import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_kids/screens/rumus/detail/anak/basic_formulas_screen.dart';

void main() {
  testWidgets('BasicFormulasScreen loads 6 category tabs and allows tab navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BasicFormulasScreen(initialIndex: 0),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 6 tabs are present in RumusHeader
    expect(find.text('Penjumlahan'), findsWidgets);
    expect(find.text('Pengurangan'), findsWidgets);
    expect(find.text('Perkalian'), findsWidgets);
    expect(find.text('Pembagian'), findsWidgets);
    expect(find.text('Tanda Kurung'), findsWidgets);
    expect(find.text('Aljabar'), findsWidgets);

    // Tap index 5 (Aljabar)
    await tester.tap(find.text('Aljabar').first);
    await tester.pumpAndSettle();

    // Verify Aljabar topic content is shown
    expect(find.text('Cabang matematika yang menggunakan simbol (variabel) untuk mewakili bilangan yang belum diketahui.'), findsOneWidget);
  });
}
