import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_kids/main.dart';
import 'package:calculator_kids/screens/kalkulator_anak_screen.dart';
import 'package:calculator_kids/screens/kalkulator_umum_screen.dart';
import 'package:calculator_kids/screens/kalkulator_tingkat_lanjut_screen.dart';
import 'package:calculator_kids/screens/rumus/rumus_menu_screen.dart';

void main() {
  final testSurfaces = [
    const Size(360, 640),   // Small Phone Portrait
    const Size(390, 844),   // Phone Portrait
    const Size(412, 915),   // Tall Phone Portrait
    const Size(844, 390),   // Phone Landscape
    const Size(768, 1024),  // Tablet Portrait
    const Size(1024, 768),  // Tablet Landscape
    const Size(1440, 900),  // Desktop / Web
  ];

  group('Responsive Layout Tests - No RenderFlex Overflow', () {
    testWidgets('KalkulatorKidsApp loads on all surface sizes without overflow', (WidgetTester tester) async {
      for (final surface in testSurfaces) {
        tester.view.physicalSize = surface;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(KalkulatorKidsApp(key: UniqueKey()));
        await tester.pumpAndSettle();

        expect(find.text('Rumus', skipOffstage: false), findsWidgets);
        expect(find.text('Kalkulator', skipOffstage: false), findsWidgets);
        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('KalkulatorAnakScreen pumps cleanly on all surface sizes', (WidgetTester tester) async {
      for (final surface in testSurfaces) {
        tester.view.physicalSize = surface;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            key: UniqueKey(),
            home: const KalkulatorAnakScreen(),
          ),
        );
        await tester.pump();

        expect(find.byType(KalkulatorAnakScreen), findsOneWidget);
        expect(find.text('Kalkulator SD', skipOffstage: false), findsOneWidget);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('KalkulatorUmumScreen pumps cleanly on all surface sizes', (WidgetTester tester) async {
      for (final surface in testSurfaces) {
        tester.view.physicalSize = surface;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            key: UniqueKey(),
            home: const KalkulatorUmumScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(KalkulatorUmumScreen), findsOneWidget);
        expect(find.text('AC', skipOffstage: false), findsWidgets);
        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('KalkulatorTingkatLanjutScreen pumps cleanly on all surface sizes', (WidgetTester tester) async {
      for (final surface in testSurfaces) {
        tester.view.physicalSize = surface;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            key: UniqueKey(),
            home: const KalkulatorTingkatLanjutScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(KalkulatorTingkatLanjutScreen), findsOneWidget);
        expect(find.text('Pecahan', skipOffstage: false), findsWidgets);
        expect(find.text('Trigonometri', skipOffstage: false), findsWidgets);
        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('RumusMenuScreen pumps cleanly on all surface sizes', (WidgetTester tester) async {
      for (final surface in testSurfaces) {
        tester.view.physicalSize = surface;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            key: UniqueKey(),
            home: const RumusMenuScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RumusMenuScreen), findsOneWidget);
        expect(find.text('Penjumlahan', skipOffstage: false), findsWidgets);
        expect(find.text('Pengurangan', skipOffstage: false), findsWidgets);
        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
