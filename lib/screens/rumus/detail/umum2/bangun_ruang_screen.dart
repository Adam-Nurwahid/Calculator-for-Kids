// lib/screens/rumus/detail/umum2/bangun_ruang_screen.dart
//
// Detail page: Bangun Ruang (3-D Shapes) — Rumus Umum 2 tier.
// Each solid: name badge + definition + CustomPaint illustration +
// Volume & Luas Permukaan formula cards.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

// ─── Screen ──────────────────────────────────────────────────────────────────

class BangunRuangScreen extends StatelessWidget {
  const BangunRuangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '📦',
            title: 'Bangun Ruang',
            definition:
                'Bangun tiga dimensi yang memiliki panjang, lebar, '
                'dan tinggi — sehingga mempunyai volume.',
          ),

          ShapeCard(
            name: 'Kubus',
            definition:
                'Bangun ruang dengan 6 sisi berbentuk persegi yang semuanya sama besar.',
            illustration: const _BRPainter(type: _BRType.kubus),
            formulas: const [
              FormulaCard(label: 'VOLUME', formula: 'V = s³'),
              FormulaCard(label: 'LUAS PERMUKAAN', formula: 'LP = 6 × s²'),
            ],
          ),

          ShapeCard(
            name: 'Balok',
            definition:
                'Bangun ruang dengan 6 sisi persegi panjang, 3 pasang sisi berhadapan sama.',
            illustration: const _BRPainter(type: _BRType.balok),
            formulas: const [
              FormulaCard(label: 'VOLUME', formula: 'V = p × l × t'),
              FormulaCard(
                  label: 'LUAS PERMUKAAN', formula: 'LP = 2(pl + pt + lt)'),
            ],
          ),

          ShapeCard(
            name: 'Tabung',
            definition:
                'Bangun ruang dengan dua alas lingkaran sejajar dan sisi tegak berupa selimut.',
            illustration: const _BRPainter(type: _BRType.tabung),
            formulas: const [
              FormulaCard(label: 'VOLUME', formula: 'V = π × r² × t'),
              FormulaCard(
                  label: 'LUAS PERMUKAAN', formula: 'LP = 2πr(r + t)'),
            ],
          ),

          ShapeCard(
            name: 'Kerucut',
            definition:
                'Bangun ruang dengan alas lingkaran dan satu titik puncak.',
            illustration: const _BRPainter(type: _BRType.kerucut),
            formulas: const [
              FormulaCard(label: 'VOLUME', formula: 'V = ⅓ × π × r² × t'),
              FormulaCard(
                  label: 'LUAS PERMUKAAN', formula: 'LP = π × r × (r + s)\ns = garis pelukis'),
            ],
          ),

          ShapeCard(
            name: 'Bola',
            definition:
                'Bangun ruang sempurna — setiap titik permukaan berjarak sama dari pusat.',
            illustration: const _BRPainter(type: _BRType.bola),
            formulas: const [
              FormulaCard(label: 'VOLUME', formula: 'V = 4/3 × π × r³'),
              FormulaCard(label: 'LUAS PERMUKAAN', formula: 'LP = 4 × π × r²'),
            ],
          ),

          ShapeCard(
            name: 'Prisma Segitiga',
            definition:
                'Bangun ruang dengan alas & atap segitiga dan tiga sisi persegi panjang.',
            illustration: const _BRPainter(type: _BRType.prisma),
            formulas: const [
              FormulaCard(
                  label: 'VOLUME', formula: 'V = Luas alas × tinggi'),
              FormulaCard(
                  label: 'LUAS PERMUKAAN',
                  formula: 'LP = 2×(Luas alas) + Keliling alas × t'),
            ],
          ),

          const TipsBox(
            text: 'Ingat:\n'
                '• π (pi) ≈ 3,14 atau 22/7\n'
                '• Volume ditulis dalam satuan kubik (cm³, m³)\n'
                '• Luas Permukaan ditulis dalam satuan persegi (cm², m²)\n\n'
                'Garis pelukis kerucut: s = √(r² + t²)  📐',
          ),
        ],
      ),
    );
  }
}

// ─── CustomPaint wrappers ─────────────────────────────────────────────────────

enum _BRType { kubus, balok, tabung, kerucut, bola, prisma }

class _BRPainter extends StatelessWidget {
  const _BRPainter({required this.type});
  final _BRType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 120,
      child: CustomPaint(painter: _BangunRuangPainter(type)),
    );
  }
}

class _BangunRuangPainter extends CustomPainter {
  const _BangunRuangPainter(this.type);
  final _BRType type;

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case _BRType.kubus:
        _drawKubus(canvas, size);
      case _BRType.balok:
        _drawBalok(canvas, size);
      case _BRType.tabung:
        _drawTabung(canvas, size);
      case _BRType.kerucut:
        _drawKerucut(canvas, size);
      case _BRType.bola:
        _drawBola(canvas, size);
      case _BRType.prisma:
        _drawPrisma(canvas, size);
    }
  }

  // Helpers
  Paint _fill(Color c) => Paint()
    ..color = c.withValues(alpha: 0.18)
    ..style = PaintingStyle.fill;

  Paint _stroke(Color c) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  Paint _dash(Color c) => Paint()
    ..color = c.withValues(alpha: 0.5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.2;

  void _dashed(Canvas c, Offset a, Offset b, Paint p) {
    const dl = 4.0, gl = 3.0;
    final dist = (b - a).distance;
    final dir = (b - a) / dist;
    double t = 0;
    while (t < dist) {
      c.drawLine(a + dir * t, a + dir * math.min(t + dl, dist), p);
      t += dl + gl;
    }
  }

  void _label(Canvas c, String txt, Offset pos, Color col) {
    final tp = TextPainter(
      text: TextSpan(
          text: txt,
          style: TextStyle(
              color: col, fontSize: 10, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, pos.translate(-tp.width / 2, -tp.height / 2));
  }

  void _drawKubus(Canvas canvas, Size s) {
    const col = Color(0xFFE07B54);
    const d = 24.0, w = 60.0, h = 60.0;
    final l = (s.width - w) / 2, t = (s.height - h) / 2;
    // Front face
    final front = Rect.fromLTWH(l, t + d, w, h);
    canvas.drawRect(front, _fill(col));
    canvas.drawRect(front, _stroke(col));
    // Top face
    final topPath = Path()
      ..moveTo(l, t + d)
      ..lineTo(l + d, t)
      ..lineTo(l + d + w, t)
      ..lineTo(l + w, t + d)
      ..close();
    canvas.drawPath(topPath, _fill(col));
    canvas.drawPath(topPath, _stroke(col));
    // Right face
    final rightPath = Path()
      ..moveTo(l + w, t + d)
      ..lineTo(l + w + d, t)
      ..lineTo(l + w + d, t + h)
      ..lineTo(l + w, t + d + h)
      ..close();
    canvas.drawPath(rightPath, _fill(col));
    canvas.drawPath(rightPath, _stroke(col));
    // Dashed hidden edges
    _dashed(canvas, Offset(l, t + d), Offset(l + d, t + d + h), _dash(col));
    _dashed(canvas, Offset(l + d, t + d + h), Offset(l + w + d, t + d + h), _dash(col));
    _dashed(canvas, Offset(l + d, t), Offset(l + d, t + d + h), _dash(col));
    _label(canvas, 's', Offset(l - 6, t + d + h / 2), col);
  }

  void _drawBalok(Canvas canvas, Size s) {
    const col = Color(0xFF1E88E5);
    const pw = 70.0, ph = 45.0, d = 20.0;
    final l = (s.width - pw) / 2 - 4, t = (s.height - ph) / 2;
    final front = Rect.fromLTWH(l, t + d, pw, ph);
    canvas.drawRect(front, _fill(col));
    canvas.drawRect(front, _stroke(col));
    final topPath = Path()
      ..moveTo(l, t + d)
      ..lineTo(l + d, t)
      ..lineTo(l + d + pw, t)
      ..lineTo(l + pw, t + d)
      ..close();
    canvas.drawPath(topPath, _fill(col));
    canvas.drawPath(topPath, _stroke(col));
    final rightPath = Path()
      ..moveTo(l + pw, t + d)
      ..lineTo(l + pw + d, t)
      ..lineTo(l + pw + d, t + ph)
      ..lineTo(l + pw, t + d + ph)
      ..close();
    canvas.drawPath(rightPath, _fill(col));
    canvas.drawPath(rightPath, _stroke(col));
    _label(canvas, 'p', Offset(l + pw / 2, t + d + ph + 8), col);
    _label(canvas, 'l', Offset(l + pw + d + 6, t + ph / 2), col);
    _label(canvas, 't', Offset(l - 8, t + d + ph / 2), col);
  }

  void _drawTabung(Canvas canvas, Size s) {
    const col = Color(0xFF7B1FA2);
    final cx = s.width / 2, cy = s.height / 2;
    const rx = 35.0, ry = 12.0, ht = 55.0;
    // Bottom ellipse
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + ht / 2), width: rx * 2, height: ry * 2),
        _fill(col));
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + ht / 2), width: rx * 2, height: ry * 2),
        _stroke(col));
    // Side
    final sidePath = Path()
      ..moveTo(cx - rx, cy - ht / 2)
      ..lineTo(cx - rx, cy + ht / 2)
      ..arcTo(Rect.fromCenter(center: Offset(cx, cy + ht / 2), width: rx * 2, height: ry * 2),
          math.pi, -math.pi, false)
      ..lineTo(cx + rx, cy - ht / 2)
      ..close();
    canvas.drawPath(sidePath, _fill(col));
    canvas.drawPath(sidePath, _stroke(col));
    // Top ellipse
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy - ht / 2), width: rx * 2, height: ry * 2),
        _fill(col));
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy - ht / 2), width: rx * 2, height: ry * 2),
        _stroke(col));
    _label(canvas, 'r', Offset(cx + rx / 2, cy - ht / 2 - 12), col);
    _label(canvas, 't', Offset(cx + rx + 8, cy), col);
  }

  void _drawKerucut(Canvas canvas, Size s) {
    const col = Color(0xFF2E7D32);
    final cx = s.width / 2, cy = s.height / 2;
    const rx = 35.0, ry = 12.0, ht = 65.0;
    // Cone body
    final conePath = Path()
      ..moveTo(cx, cy - ht / 2)
      ..arcTo(Rect.fromCenter(center: Offset(cx, cy + ht / 2 - ry),
          width: rx * 2, height: ry * 2), math.pi, -math.pi, false)
      ..close();
    canvas.drawPath(conePath, _fill(col));
    canvas.drawPath(conePath, _stroke(col));
    // Base ellipse
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy + ht / 2 - ry),
            width: rx * 2,
            height: ry * 2),
        _stroke(col));
    _label(canvas, 'r', Offset(cx + rx / 2, cy + ht / 2 + 4), col);
    _label(canvas, 't', Offset(cx + 8, cy), col);
  }

  void _drawBola(Canvas canvas, Size s) {
    const col = Color(0xFFF57F17);
    final center = Offset(s.width / 2, s.height / 2);
    const r = 42.0;
    canvas.drawCircle(center, r, _fill(col));
    canvas.drawCircle(center, r, _stroke(col));
    // Equator ellipse (dashed)
    _dashed(canvas, center.translate(-r, 0), center.translate(r, 0),
        _dash(col)..strokeWidth = 1.0);
    canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2, height: r * 0.5),
        _dash(col));
    // Radius line
    canvas.drawLine(center, center.translate(r * 0.7, -r * 0.7), _stroke(col));
    _label(canvas, 'r', center.translate(r * 0.4, -r * 0.4 - 8), col);
  }

  void _drawPrisma(Canvas canvas, Size s) {
    const col = Color(0xFF00838F);
    final cx = s.width / 2, cy = s.height / 2;
    const hw = 45.0, hh = 35.0, d = 20.0;
    // Front triangle
    final frontPath = Path()
      ..moveTo(cx, cy - hh)
      ..lineTo(cx - hw, cy + hh)
      ..lineTo(cx + hw, cy + hh)
      ..close();
    canvas.drawPath(frontPath, _fill(col));
    canvas.drawPath(frontPath, _stroke(col));
    // Back triangle (offset)
    final backPath = Path()
      ..moveTo(cx + d, cy - hh - d)
      ..lineTo(cx - hw + d, cy + hh - d)
      ..lineTo(cx + hw + d, cy + hh - d)
      ..close();
    _dashed(canvas, Offset(cx + d, cy - hh - d),
        Offset(cx - hw + d, cy + hh - d), _dash(col));
    _dashed(canvas, Offset(cx - hw + d, cy + hh - d),
        Offset(cx + hw + d, cy + hh - d), _dash(col));
    _dashed(canvas, Offset(cx + hw + d, cy + hh - d),
        Offset(cx + d, cy - hh - d), _dash(col));
    // Lateral edges
    canvas.drawLine(Offset(cx, cy - hh), Offset(cx + d, cy - hh - d), _stroke(col));
    canvas.drawLine(Offset(cx + hw, cy + hh), Offset(cx + hw + d, cy + hh - d), _stroke(col));
    _dashed(canvas, Offset(cx - hw, cy + hh), Offset(cx - hw + d, cy + hh - d), _dash(col));
    _label(canvas, 't', Offset(cx + hw + d + 8, cy - 4), col);
  }

  @override
  bool shouldRepaint(_) => false;
}
