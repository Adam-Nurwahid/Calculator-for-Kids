// lib/screens/rumus/detail/anak/bangun_datar_screen.dart
//
// Detail page: Bangun Datar (2-D Shapes) — Rumus Anak tier.
// Each shape: name badge + definition + CustomPaint illustration + formula cards.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

// ─── Screen ──────────────────────────────────────────────────────────────────

class BangunDatarScreen extends StatelessWidget {
  const BangunDatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Dasar',
      topicTitle: 'Bangun Datar',
      mascotEmoji: '📐',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '📐',
            title: 'Bangun Datar',
            definition:
                'Bangun dua dimensi yang memiliki panjang dan lebar, '
                'tetapi tidak memiliki tinggi.',
          ),

          // ── Shapes ──────────────────────────────────────────────────
          ShapeCard(
            name: 'Persegi',
            definition: 'Bangun dengan 4 sisi sama panjang dan 4 sudut siku-siku.',
            illustration: const _ShapePainterWidget(
              painter: _SquarePainter(),
              size: 100,
            ),
            formulas: const [
              FormulaCard(label: 'LUAS', formula: 'L = s × s = s²'),
              FormulaCard(label: 'KELILING', formula: 'K = 4 × s'),
            ],
          ),

          ShapeCard(
            name: 'Persegi Panjang',
            definition: 'Bangun dengan 2 pasang sisi sejajar dan 4 sudut siku-siku.',
            illustration: const _ShapePainterWidget(
              painter: _RectanglePainter(),
              size: 100,
            ),
            formulas: const [
              FormulaCard(label: 'LUAS', formula: 'L = p × l'),
              FormulaCard(label: 'KELILING', formula: 'K = 2 × (p + l)'),
            ],
          ),

          ShapeCard(
            name: 'Segitiga',
            definition: 'Bangun dengan 3 sisi dan 3 sudut. Jumlah sudut = 180°.',
            illustration: const _ShapePainterWidget(
              painter: _TrianglePainter(),
              size: 100,
            ),
            formulas: const [
              FormulaCard(label: 'LUAS', formula: 'L = ½ × alas × tinggi'),
              FormulaCard(label: 'KELILING', formula: 'K = sisi a + sisi b + sisi c'),
            ],
          ),

          ShapeCard(
            name: 'Lingkaran',
            definition: 'Himpunan titik-titik yang berjarak sama dari titik pusat.',
            illustration: const _ShapePainterWidget(
              painter: _CirclePainter(),
              size: 100,
            ),
            formulas: const [
              FormulaCard(label: 'LUAS', formula: 'L = π × r²'),
              FormulaCard(label: 'KELILING', formula: 'K = 2 × π × r   (π ≈ 3,14)'),
            ],
          ),

          ShapeCard(
            name: 'Trapesium',
            definition: 'Bangun dengan tepat satu pasang sisi sejajar (alas & atas).',
            illustration: const _ShapePainterWidget(
              painter: _TrapezoidPainter(),
              size: 100,
            ),
            formulas: const [
              FormulaCard(
                  label: 'LUAS', formula: 'L = ½ × (a + b) × t'),
              FormulaCard(label: 'KELILING', formula: 'K = jumlah semua sisi'),
            ],
          ),

          ShapeCard(
            name: 'Jajar Genjang',
            definition: 'Bangun dengan 2 pasang sisi sejajar dan sama panjang.',
            illustration: const _ShapePainterWidget(
              painter: _ParallelogramPainter(),
              size: 100,
            ),
            formulas: const [
              FormulaCard(label: 'LUAS', formula: 'L = alas × tinggi'),
              FormulaCard(label: 'KELILING', formula: 'K = 2 × (a + b)'),
            ],
          ),

          ShapeCard(
            name: 'Belah Ketupat',
            definition:
                'Bangun dengan 4 sisi sama panjang, sisi berlawanan sejajar.',
            illustration: const _ShapePainterWidget(
              painter: _RhombusPainter(),
              size: 100,
            ),
            formulas: const [
              FormulaCard(label: 'LUAS', formula: 'L = ½ × d₁ × d₂'),
              FormulaCard(label: 'KELILING', formula: 'K = 4 × s'),
            ],
          ),

          const TipsBox(
            text: 'Ingat: π (pi) = 3,14 atau 22/7\n'
                'Untuk lingkaran: r adalah jari-jari (setengah diameter)\n'
                'Luas selalu ditulis dalam satuan kuadrat (cm², m², dll.)',
          ),
        ],
      ),
    );
  }
}

// ─── Shape painter wrapper ────────────────────────────────────────────────────

class _ShapePainterWidget extends StatelessWidget {
  const _ShapePainterWidget({required this.painter, required this.size});
  final CustomPainter painter;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 40,
      height: size + 40,
      child: CustomPaint(painter: painter),
    );
  }
}

// ─── Individual shape painters ────────────────────────────────────────────────

class _SquarePainter extends CustomPainter {
  const _SquarePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kRumusOrange.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = kRumusOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    const margin = 20.0;
    final s = math.min(size.width, size.height) - margin * 2;
    final l = margin + (size.width - margin * 2 - s) / 2;
    final t = margin + (size.height - margin * 2 - s) / 2;
    final rect = Rect.fromLTWH(l, t, s, s);
    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, strokePaint);

    // Label: "s"
    _drawLabel(canvas, 's', Offset(l + s / 2, t - 8), kRumusOrange);
    _drawLabel(canvas, 's', Offset(l - 10, t + s / 2), kRumusOrange);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RectanglePainter extends CustomPainter {
  const _RectanglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF42A5F5).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF1E88E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    const ml = 10.0, mt = 30.0;
    final w = size.width - ml * 2;
    final h = size.height - mt * 2;
    final rect = Rect.fromLTWH(ml, mt, w, h);
    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, strokePaint);
    _drawLabel(canvas, 'p', Offset(ml + w / 2, mt - 10),
        const Color(0xFF1E88E5));
    _drawLabel(canvas, 'l', Offset(ml + w + 10, mt + h / 2),
        const Color(0xFF1E88E5));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF66BB6A).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    const m = 15.0;
    final path = Path()
      ..moveTo(size.width / 2, m)
      ..lineTo(size.width - m, size.height - m)
      ..lineTo(m, size.height - m)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    // Height dashed line
    final dashPaint = Paint()
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    _drawDashed(canvas, Offset(size.width / 2, m),
        Offset(size.width / 2, size.height - m), dashPaint);

    _drawLabel(canvas, 't', Offset(size.width / 2 + 10, size.height / 2),
        const Color(0xFF2E7D32));
    _drawLabel(canvas, 'a', Offset(size.width / 2, size.height - 8),
        const Color(0xFF2E7D32));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CirclePainter extends CustomPainter {
  const _CirclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) / 2 - 15;
    final paint = Paint()
      ..color = const Color(0xFFAB47BC).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF6A1B9A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, r, paint);
    canvas.drawCircle(center, r, strokePaint);

    // Radius line
    canvas.drawLine(center, center.translate(r, 0),
        strokePaint..strokeWidth = 1.5);
    canvas.drawCircle(center, 3, Paint()..color = const Color(0xFF6A1B9A));
    _drawLabel(
        canvas, 'r', center.translate(r / 2, -10), const Color(0xFF6A1B9A));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _TrapezoidPainter extends CustomPainter {
  const _TrapezoidPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEF5350).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFFC62828)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    const m = 10.0;
    final path = Path()
      ..moveTo(size.width * 0.25, m)
      ..lineTo(size.width * 0.75, m)
      ..lineTo(size.width - m, size.height - m)
      ..lineTo(m, size.height - m)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    _drawLabel(canvas, 'b (atas)', Offset(size.width / 2, m - 8),
        const Color(0xFFC62828));
    _drawLabel(canvas, 'a (bawah)',
        Offset(size.width / 2, size.height - 6), const Color(0xFFC62828));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ParallelogramPainter extends CustomPainter {
  const _ParallelogramPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFCA28).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFFF57F17)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    const m = 10.0;
    const offset = 25.0;
    final path = Path()
      ..moveTo(m + offset, m)
      ..lineTo(size.width - m, m)
      ..lineTo(size.width - m - offset, size.height - m)
      ..lineTo(m, size.height - m)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    // Height dashed line
    final dashPaint = Paint()
      ..color = const Color(0xFFF57F17).withValues(alpha: 0.6)
      ..strokeWidth = 1.5;
    _drawDashed(canvas, Offset(m + offset + 20, m),
        Offset(m + offset + 20, size.height - m), dashPaint);

    _drawLabel(canvas, 'a', Offset(size.width / 2, size.height - 6),
        const Color(0xFFF57F17));
    _drawLabel(canvas, 't', Offset(m + offset + 28, size.height / 2),
        const Color(0xFFF57F17));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RhombusPainter extends CustomPainter {
  const _RhombusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF26C6DA).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF00838F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const hw = 55.0; // half-width
    const hh = 38.0; // half-height
    final path = Path()
      ..moveTo(cx, cy - hh)
      ..lineTo(cx + hw, cy)
      ..lineTo(cx, cy + hh)
      ..lineTo(cx - hw, cy)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    // Diagonals
    final dashPaint = Paint()
      ..color = const Color(0xFF00838F).withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    _drawDashed(canvas, Offset(cx - hw, cy), Offset(cx + hw, cy), dashPaint);
    _drawDashed(canvas, Offset(cx, cy - hh), Offset(cx, cy + hh), dashPaint);

    _drawLabel(canvas, 'd₁', Offset(cx + hw / 2, cy - 10),
        const Color(0xFF00838F));
    _drawLabel(canvas, 'd₂', Offset(cx + 8, cy - hh / 2),
        const Color(0xFF00838F));
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        fontFamily: 'Fredoka One',
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  tp.paint(canvas, pos.translate(-tp.width / 2, -tp.height / 2));
}

void _drawDashed(Canvas canvas, Offset start, Offset end, Paint paint) {
  const dashLen = 5.0;
  const gapLen = 3.0;
  final total = (end - start).distance;
  final dir = (end - start) / total;
  double covered = 0;
  while (covered < total) {
    final from = start + dir * covered;
    final to = start + dir * math.min(covered + dashLen, total);
    canvas.drawLine(from, to, paint);
    covered += dashLen + gapLen;
  }
}
