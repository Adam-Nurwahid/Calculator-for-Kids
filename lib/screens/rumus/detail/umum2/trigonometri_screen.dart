// lib/screens/rumus/detail/umum2/trigonometri_screen.dart
//
// Detail page: Trigonometri — Rumus Umum 2 tier.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class TrigonometriScreen extends StatelessWidget {
  const TrigonometriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Umum 2',
      topicTitle: 'Trigonometri',
      mascotEmoji: '🦅',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '📐',
            title: 'Trigonometri',
            definition:
                'Cabang matematika yang mempelajari hubungan antara '
                'sudut dan sisi segitiga siku-siku.',
          ),

          // ── Definisi SOH-CAH-TOA ─────────────────────────────────────
          const SectionTitle('📋 Definisi SOH-CAH-TOA'),
          // Right triangle illustration
          ContohBox(
            title: 'Segitiga Siku-Siku',
            content: const _TriangleDiagram(),
          ),
          const SifatItem(
            number: 1,
            title: 'Sinus (sin) — SOH',
            description: 'Sisi depan sudut dibagi sisi miring.',
            example: 'sin θ = depan / miring',
          ),
          const SifatItem(
            number: 2,
            title: 'Cosinus (cos) — CAH',
            description: 'Sisi samping sudut dibagi sisi miring.',
            example: 'cos θ = samping / miring',
          ),
          const SifatItem(
            number: 3,
            title: 'Tangen (tan) — TOA',
            description: 'Sisi depan dibagi sisi samping.',
            example: 'tan θ = depan / samping  =  sin θ / cos θ',
          ),

          // ── Sudut Istimewa ────────────────────────────────────────────
          const SectionTitle('🔢 Nilai Sudut Istimewa'),
          ContohBox(
            title: 'Tabel sin, cos, tan',
            content: const _TrigTable(),
          ),

          // ── Identitas Dasar ───────────────────────────────────────────
          const SectionTitle('📐 Identitas & Rumus'),
          const FormulaCard(label: 'SIN', formula: 'sin θ = depan / miring'),
          const FormulaCard(label: 'COS', formula: 'cos θ = samping / miring'),
          const FormulaCard(label: 'TAN', formula: 'tan θ = sin θ / cos θ'),
          const FormulaCard(
              label: 'IDENTITAS PITAGORAS',
              formula: 'sin²θ + cos²θ = 1'),
          const FormulaCard(
              label: 'TEOREMA PITAGORAS',
              formula: 'miring² = depan² + samping²'),

          const TipsBox(
            text: 'Hafalkan dengan singkatan SOH-CAH-TOA!\n'
                '🟠 SOH: Sin = Opposite / Hypotenuse\n'
                '🟡 CAH: Cos = Adjacent / Hypotenuse\n'
                '🟢 TOA: Tan = Opposite / Adjacent\n\n'
                '"Some Old Hippie Caught A Hippy Tripping On Acid" 😄',
          ),
        ],
      ),
    );
  }
}

class _TriangleDiagram extends StatelessWidget {
  const _TriangleDiagram();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 110,
      child: CustomPaint(painter: _TriDiagPainter()),
    );
  }
}

class _TriDiagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const col = Color(0xFF1E88E5);
    final paint = Paint()
      ..color = col.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Triangle points: bottom-left, bottom-right, top-right
    final a = Offset(20, size.height - 20);      // right angle
    final b = Offset(size.width - 20, size.height - 20); // bottom-right
    final c = Offset(size.width - 20, 20);       // top

    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..lineTo(c.dx, c.dy)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, stroke);

    // Right angle mark
    const sq = 10.0;
    canvas.drawRect(
        Rect.fromLTWH(b.dx - sq, b.dy - sq, sq, sq),
        Paint()
          ..color = col
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    // Labels
    void lbl(String t, Offset p) {
      final tp = TextPainter(
        text: TextSpan(
            text: t,
            style: const TextStyle(
                color: col, fontSize: 11, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, p.translate(-tp.width / 2, -tp.height / 2));
    }

    lbl('Miring (hyp)', Offset((a.dx + c.dx) / 2 - 20, (a.dy + c.dy) / 2));
    lbl('Depan', Offset(b.dx + 24, (b.dy + c.dy) / 2));
    lbl('Samping', Offset((a.dx + b.dx) / 2, a.dy + 12));
    lbl('θ', Offset(a.dx + 22, a.dy - 12));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _TrigTable extends StatelessWidget {
  const _TrigTable();

  static const angles = [0, 30, 45, 60, 90];
  static const sinV = ['0', '½', '½√2', '½√3', '1'];
  static const cosV = ['1', '½√3', '½√2', '½', '0'];
  static const tanV = ['0', '⅓√3', '1', '√3', '∞'];

  @override
  Widget build(BuildContext context) {
    return Table(
      border:
          TableBorder.all(color: kDivider, borderRadius: BorderRadius.circular(4)),
      defaultColumnWidth: const FlexColumnWidth(),
      children: [
        // Header
        TableRow(
          decoration: const BoxDecoration(color: kRumusOrange),
          children: ['θ°', 'sin', 'cos', 'tan']
              .map((h) => _cell(h, isHeader: true))
              .toList(),
        ),
        for (int i = 0; i < angles.length; i++)
          TableRow(children: [
            _cell('${angles[i]}°'),
            _cell(sinV[i]),
            _cell(cosV[i]),
            _cell(tanV[i]),
          ]),
      ],
    );
  }

  static Widget _cell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Fredoka One',
            fontSize: 12,
            color: isHeader ? Colors.white : kRumusTextDark,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
