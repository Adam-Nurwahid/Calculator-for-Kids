// This is a basic Flutter widget test for the updated Kids Calculator app.
//
// Note: pumpAndSettle() is intentionally avoided here because StartScreen
// contains a repeating bounce animation that never settles.
// We use pump(Duration) instead to advance frames without waiting forever.

import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_kids/main.dart';

void main() {
  testWidgets('App launches and shows Start screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KalkulatorKidsApp());
    // Advance enough frames for the initial build to complete without
    // waiting for the infinite bounce animation to settle.
    await tester.pump(const Duration(milliseconds: 300));

    // The start screen should show the app title and the start button
    expect(find.text('Kalkulator Anak'), findsWidgets);
    expect(find.text('✨  Mulai Belajar!'), findsOneWidget);
  });

  testWidgets('Start button navigates to Mode Selection screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const KalkulatorKidsApp());
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('✨  Mulai Belajar!'));
    // Advance through the Cupertino page transition
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Pilih Mode Belajar'), findsOneWidget);
  });
}
