// lib/screens/rumus/detail/umum2/deg_rad_screen.dart
//
// Detail page: Deg/Rad (Degrees & Radians) — Rumus Umum 2 tier.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class DegRadScreen extends StatelessWidget {
  const DegRadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Umum 2',
      topicTitle: 'Derajat & Radian',
      mascotEmoji: '🦅',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '°',
            title: 'Derajat & Radian',
            definition:
                'Dua satuan untuk mengukur sudut. Derajat (°) membagi '
                'lingkaran penuh menjadi 360 bagian. Radian mengukur '
                'sudut berdasarkan panjang busur.',
          ),

          // ── Konsep ───────────────────────────────────────────────────
          const SectionTitle('📋 Konsep Dasar'),
          const SifatItem(
            number: 1,
            title: 'Derajat (°)',
            description:
                'Lingkaran penuh = 360°. Setengah = 180°. Seperempat = 90°.',
            example: 'Sudut siku-siku = 90°',
          ),
          const SifatItem(
            number: 2,
            title: 'Radian (rad)',
            description:
                'Sudut yang menghasilkan panjang busur = jari-jari lingkaran. '
                'Lingkaran penuh = 2π rad ≈ 6.28 rad.',
            example: '2π rad = 360°  →  π rad = 180°',
          ),
          const SifatItem(
            number: 3,
            title: 'Konversi Derajat → Radian',
            description: 'Kalikan derajat dengan π/180.',
            example: '90° × π/180 = π/2 rad ≈ 1.571 rad',
          ),
          const SifatItem(
            number: 4,
            title: 'Konversi Radian → Derajat',
            description: 'Kalikan radian dengan 180/π.',
            example: 'π/4 × 180/π = 45°',
          ),

          // ── Diagram Lingkaran ────────────────────────────────────────
          ContohBox(
            title: 'Diagram Unit Circle',
            content: const _UnitCircleDiagram(),
          ),

          // ── Tabel Konversi ────────────────────────────────────────────
          ContohBox(
            title: 'Tabel Konversi Sudut Umum',
            content: const _DegRadTable(),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus Konversi'),
          const FormulaCard(
              label: 'DEG → RAD', formula: 'rad = deg × π / 180'),
          const FormulaCard(
              label: 'RAD → DEG', formula: 'deg = rad × 180 / π'),
          const FormulaCard(
              label: 'PANJANG BUSUR',
              formula: 's = r × θ   (θ dalam radian)'),
          const FormulaCard(
              label: 'LUAS SEKTOR',
              formula: 'L = ½ × r² × θ   (θ dalam radian)'),

          const TipsBox(
            text: 'Trik ingatan:\n'
                '"Derajat ke Radian → kalikan π/180"\n'
                '"Radian ke Derajat → kalikan 180/π"\n\n'
                'π ≈ 3.14159\n'
                'Sudut populer: 30° = π/6, 45° = π/4, 60° = π/3, 90° = π/2, 180° = π  ✨',
          ),
        ],
      ),
    );
  }
}

class _UnitCircleDiagram extends StatelessWidget {
  const _UnitCircleDiagram();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: CustomPaint(painter: _UnitCirclePainter()),
    );
  }
}

class _UnitCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const col = Color(0xFF7B1FA2);
    final cx = size.width / 2, cy = size.height / 2;
    const r = 50.0;

    final circlePaint = Paint()
      ..color = col.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    // Circle
    canvas.drawCircle(Offset(cx, cy), r, circlePaint);
    canvas.drawCircle(Offset(cx, cy), r, stroke);

    // Axes
    canvas.drawLine(Offset(cx - r - 10, cy), Offset(cx + r + 10, cy), stroke..strokeWidth = 1.0);
    canvas.drawLine(Offset(cx, cy - r - 10), Offset(cx, cy + r + 10), stroke);

    // Angle line at 60°
    const angle = 60.0 * math.pi / 180;
    final px = cx + r * math.cos(angle), py = cy - r * math.sin(angle);
    canvas.drawLine(Offset(cx, cy), Offset(px, py),
        Paint()..color = col..strokeWidth = 2.0..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(px, py), 4,
        Paint()..color = col..style = PaintingStyle.fill);

    // Arc for angle
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: 30, height: 30),
      -angle, angle, false,
      Paint()..color = const Color(0xFFE07B54)..strokeWidth = 2..style = PaintingStyle.stroke,
    );

    void lbl(String t, Offset p) {
      final tp = TextPainter(
        text: TextSpan(
            text: t,
            style: TextStyle(
                color: col, fontSize: 10, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, p.translate(-tp.width / 2, -tp.height / 2));
    }

    lbl('60°', Offset(cx + 24, cy - 14));
    lbl('(cos θ, sin θ)', Offset(px + 34, py));
    lbl('r = 1', Offset((cx + px) / 2 - 14, (cy + py) / 2 - 4));
    lbl('0°/360°', Offset(cx + r + 14, cy));
    lbl('90°', Offset(cx, cy - r - 12));
    lbl('180°', Offset(cx - r - 18, cy));
    lbl('270°', Offset(cx, cy + r + 10));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _DegRadTable extends StatelessWidget {
  const _DegRadTable();

  static const rows = [
    ('Derajat', 'Radian', 'Desimal'),
    ('0°', '0', '0'),
    ('30°', 'π/6', '0.524'),
    ('45°', 'π/4', '0.785'),
    ('60°', 'π/3', '1.047'),
    ('90°', 'π/2', '1.571'),
    ('180°', 'π', '3.14159'),
    ('270°', '3π/2', '4.712'),
    ('360°', '2π', '6.283'),
  ];

  @override
  Widget build(BuildContext context) {
    return Table(
      border:
          TableBorder.all(color: kDivider, borderRadius: BorderRadius.circular(4)),
      defaultColumnWidth: const FlexColumnWidth(),
      children: rows.map((r) {
        final isHeader = r.$1 == 'Derajat';
        return TableRow(
          decoration: BoxDecoration(color: isHeader ? kRumusOrange : null),
          children: [r.$1, r.$2, r.$3].map((cell) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Center(
                child: Text(
                  cell,
                  style: TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 12,
                    color: isHeader ? Colors.white : kRumusTextDark,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
