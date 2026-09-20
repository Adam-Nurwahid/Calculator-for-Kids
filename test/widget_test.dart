import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_kids/main.dart';

void main() {
  testWidgets('App launches and shows Mode Selection screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KalkulatorKidsApp());
    await tester.pump(const Duration(milliseconds: 300));

    // Initial screen is Mode Selection screen
    expect(find.text('Rumus'), findsWidgets);
    expect(find.text('Kalkulator'), findsWidgets);
  });
}
