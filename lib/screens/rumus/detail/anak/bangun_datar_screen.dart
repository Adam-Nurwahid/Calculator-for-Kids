// lib/screens/rumus/detail/anak/bangun_datar_screen.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class BangunDatarScreen extends StatelessWidget {
  const BangunDatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Topic Header (Title & Subtitle) ───────────────────────────
          RumusTopicHeader(
            title: 'Bangun Datar',
            subtitle:
                'Bangun dua dimensi yang memiliki panjang dan lebar, tetapi tidak memiliki tinggi.',
          ),

          // 1. Persegi
          ShapeCard(
            name: 'Persegi',
            definition:
                'Bangun dengan 4 sisi sama panjang dan 4 sudut siku-siku (90°).',
            illustration: _ShapePainterWidget(
              painter: _SquarePainter(),
              size: 100,
            ),
            formulas: [
              FormulaCard(label: 'LUAS', formula: 'L = s × s = s²'),
              FormulaCard(label: 'KELILING', formula: 'K = 4 × s'),
            ],
          ),

          // 2. Persegi Panjang
          ShapeCard(
            name: 'Persegi Panjang',
            definition:
                'Bangun dengan 2 pasang sisi sejajar sama panjang dan 4 sudut siku-siku.',
            illustration: _ShapePainterWidget(
              painter: _RectanglePainter(),
              size: 100,
            ),
            formulas: [
              FormulaCard(label: 'LUAS', formula: 'L = p × l'),
              FormulaCard(label: 'KELILING', formula: 'K = 2 × (p + l)'),
            ],
          ),

          // 3. Belah Ketupat
          ShapeCard(
            name: 'Belah Ketupat',
            definition:
                'Bangun dengan 4 sisi sama panjang dan diagonal yang saling tegak lurus.',
            illustration: _ShapePainterWidget(
              painter: _RhombusPainter(),
              size: 100,
            ),
            formulas: [
              FormulaCard(label: 'LUAS', formula: 'L = ½ × d₁ × d₂'),
              FormulaCard(label: 'KELILING', formula: 'K = 4 × s'),
            ],
          ),

          // 4. Layang-layang
          ShapeCard(
            name: 'Layang-layang',
            definition:
                'Bangun dengan 2 pasang sisi sama panjang dan diagonal tegak lurus.',
            illustration: _ShapePainterWidget(
              painter: _KitePainter(),
              size: 100,
            ),
            formulas: [
              FormulaCard(label: 'LUAS', formula: 'L = ½ × d₁ × d₂'),
              FormulaCard(label: 'KELILING', formula: 'K = 2 × (a + b)'),
            ],
          ),

          // 5. Jajargenjang
          ShapeCard(
            name: 'Jajargenjang',
            definition:
                'Bangun segi empat dengan 2 pasang sisi sejajar dan sudut berhadapan sama besar.',
            illustration: _ShapePainterWidget(
              painter: _ParallelogramPainter(),
              size: 100,
            ),
            formulas: [
              FormulaCard(label: 'LUAS', formula: 'L = alas × tinggi'),
              FormulaCard(label: 'KELILING', formula: 'K = 2 × (a + b)'),
            ],
          ),

          // 6. Trapesium
          ShapeCard(
            name: 'Trapesium',
            definition:
                'Bangun segi empat yang memiliki tepat satu pasang sisi sejajar.',
            illustration: _ShapePainterWidget(
              painter: _TrapezoidPainter(),
              size: 100,
            ),
            formulas: [
              FormulaCard(label: 'LUAS', formula: 'L = ½ × (a + b) × t'),
              FormulaCard(label: 'KELILING', formula: 'K = jumlah semua sisi'),
            ],
          ),

          // 7. Segitiga
          ShapeCard(
            name: 'Segitiga',
            definition:
                'Bangun dengan 3 sisi dan 3 sudut. Total jumlah sudutnya = 180°.',
            illustration: _ShapePainterWidget(
              painter: _TrianglePainter(),
              size: 100,
            ),
            formulas: [
              FormulaCard(label: 'LUAS', formula: 'L = ½ × alas × tinggi'),
              FormulaCard(label: 'KELILING', formula: 'K = sisi a + sisi b + sisi c'),
            ],
          ),

          // 8. Lingkaran
          ShapeCard(
            name: 'Lingkaran',
            definition:
                'Himpunan titik-titik yang berjarak sama (jari-jari) dari titik pusat.',
            illustration: _ShapePainterWidget(
              painter: _CirclePainter(),
              size: 100,
            ),
            formulas: [
              FormulaCard(label: 'LUAS', formula: 'L = π × r²'),
              FormulaCard(
                  label: 'KELILING', formula: 'K = 2 × π × r   (π ≈ 3,14 atau 22/7)'),
            ],
          ),

          // ── Bottom Tips Card ──────────────────────────────────────────
          RumusTipsCard(
            tipText: 'Ingat: π (pi) = 3,14 atau 22/7\n'
                'Untuk lingkaran: r adalah jari-jari (setengah dari diameter d)\n'
                'Luas selalu ditulis dalam satuan kuadrat (cm², m², dll.) 📐',
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

// ─── Individual 2D Shape Painters ─────────────────────────────────────────────

class _SquarePainter extends CustomPainter {
  const _SquarePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB042).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFFFFB042)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    const margin = 20.0;
    final s = math.min(size.width, size.height) - margin * 2;
    final l = margin + (size.width - margin * 2 - s) / 2;
    final t = margin + (size.height - margin * 2 - s) / 2;
    final rect = Rect.fromLTWH(l, t, s, s);
    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, strokePaint);

    _drawLabel(canvas, 's', Offset(l + s / 2, t - 10), const Color(0xFFFFB042));
    _drawLabel(canvas, 's', Offset(l - 12, t + s / 2), const Color(0xFFFFB042));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RectanglePainter extends CustomPainter {
  const _RectanglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF42A5F5).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF1E88E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    const ml = 15.0, mt = 30.0;
    final w = size.width - ml * 2;
    final h = size.height - mt * 2;
    final rect = Rect.fromLTWH(ml, mt, w, h);
    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, strokePaint);

    _drawLabel(canvas, 'p', Offset(ml + w / 2, mt - 10), const Color(0xFF1E88E5));
    _drawLabel(canvas, 'l', Offset(ml + w + 12, mt + h / 2), const Color(0xFF1E88E5));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RhombusPainter extends CustomPainter {
  const _RhombusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF26C6DA).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF00838F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const hw = 52.0;
    const hh = 36.0;
    final path = Path()
      ..moveTo(cx, cy - hh)
      ..lineTo(cx + hw, cy)
      ..lineTo(cx, cy + hh)
      ..lineTo(cx - hw, cy)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    final dashPaint = Paint()
      ..color = const Color(0xFF00838F).withValues(alpha: 0.6)
      ..strokeWidth = 1.5;
    _drawDashed(canvas, Offset(cx - hw, cy), Offset(cx + hw, cy), dashPaint);
    _drawDashed(canvas, Offset(cx, cy - hh), Offset(cx, cy + hh), dashPaint);

    _drawLabel(canvas, 'd₁', Offset(cx + hw / 2, cy - 10), const Color(0xFF00838F));
    _drawLabel(canvas, 'd₂', Offset(cx + 10, cy - hh / 2), const Color(0xFF00838F));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _KitePainter extends CustomPainter {
  const _KitePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFAB47BC).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF7B1FA2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const hw = 48.0;
    const topH = 30.0;
    const botH = 50.0;

    final path = Path()
      ..moveTo(cx, cy - topH)
      ..lineTo(cx + hw, cy)
      ..lineTo(cx, cy + botH)
      ..lineTo(cx - hw, cy)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    final dashPaint = Paint()
      ..color = const Color(0xFF7B1FA2).withValues(alpha: 0.6)
      ..strokeWidth = 1.5;
    _drawDashed(canvas, Offset(cx - hw, cy), Offset(cx + hw, cy), dashPaint);
    _drawDashed(canvas, Offset(cx, cy - topH), Offset(cx, cy + botH), dashPaint);

    _drawLabel(canvas, 'd₁', Offset(cx + hw / 2, cy - 10), const Color(0xFF7B1FA2));
    _drawLabel(canvas, 'd₂', Offset(cx + 10, cy + 10), const Color(0xFF7B1FA2));
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

    const m = 15.0;
    const offset = 25.0;
    final path = Path()
      ..moveTo(m + offset, m)
      ..lineTo(size.width - m, m)
      ..lineTo(size.width - m - offset, size.height - m)
      ..lineTo(m, size.height - m)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    final dashPaint = Paint()
      ..color = const Color(0xFFF57F17).withValues(alpha: 0.6)
      ..strokeWidth = 1.5;
    _drawDashed(canvas, Offset(m + offset + 15, m),
        Offset(m + offset + 15, size.height - m), dashPaint);

    _drawLabel(canvas, 'a', Offset(size.width / 2, size.height - 6), const Color(0xFFF57F17));
    _drawLabel(canvas, 't', Offset(m + offset + 24, size.height / 2), const Color(0xFFF57F17));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _TrapezoidPainter extends CustomPainter {
  const _TrapezoidPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEF5350).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFFC62828)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    const m = 15.0;
    final path = Path()
      ..moveTo(size.width * 0.28, m)
      ..lineTo(size.width * 0.72, m)
      ..lineTo(size.width - m, size.height - m)
      ..lineTo(m, size.height - m)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    _drawLabel(canvas, 'b (atas)', Offset(size.width / 2, m - 8), const Color(0xFFC62828));
    _drawLabel(canvas, 'a (bawah)', Offset(size.width / 2, size.height - 6), const Color(0xFFC62828));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF66BB6A).withValues(alpha: 0.2)
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

    final dashPaint = Paint()
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.6)
      ..strokeWidth = 1.5;
    _drawDashed(canvas, Offset(size.width / 2, m),
        Offset(size.width / 2, size.height - m), dashPaint);

    _drawLabel(canvas, 't', Offset(size.width / 2 + 10, size.height / 2), const Color(0xFF2E7D32));
    _drawLabel(canvas, 'a', Offset(size.width / 2, size.height - 6), const Color(0xFF2E7D32));
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
      ..color = const Color(0xFF26A69A).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF00695C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, r, paint);
    canvas.drawCircle(center, r, strokePaint);

    canvas.drawLine(center, center.translate(r, 0), strokePaint..strokeWidth = 1.5);
    canvas.drawCircle(center, 3.5, Paint()..color = const Color(0xFF00695C));
    _drawLabel(canvas, 'r', center.translate(r / 2, -10), const Color(0xFF00695C));
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
