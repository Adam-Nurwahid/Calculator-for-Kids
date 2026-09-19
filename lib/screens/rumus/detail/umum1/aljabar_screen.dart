// lib/screens/rumus/detail/umum1/aljabar_screen.dart
//
// Detail page: Aljabar (Algebra) — Rumus Umum 1 tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class AljabarScreen extends StatelessWidget {
  const AljabarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '🔠',
            title: 'Aljabar',
            definition:
                'Cabang matematika yang menggunakan simbol (variabel) '
                'untuk mewakili bilangan yang belum diketahui.',
          ),

          // ── Konsep ───────────────────────────────────────────────────
          const SectionTitle('📋 Konsep Dasar'),
          const SifatItem(
            number: 1,
            title: 'Variabel',
            description: 'Huruf yang mewakili bilangan yang belum diketahui.',
            example: 'x, y, a, b — contoh: x + 3 = 7',
          ),
          const SifatItem(
            number: 2,
            title: 'Koefisien',
            description: 'Angka yang dikalikan dengan variabel.',
            example: 'Pada 5x, angka 5 adalah koefisien dari x',
          ),
          const SifatItem(
            number: 3,
            title: 'Konstanta',
            description: 'Bilangan tetap dalam suatu ekspresi.',
            example: 'Pada 3x + 7, angka 7 adalah konstanta',
          ),
          const SifatItem(
            number: 4,
            title: 'Suku Sejenis',
            description: 'Suku dengan variabel & pangkat yang sama.',
            example: '3x dan 5x → sejenis → bisa digabung: 8x',
          ),
          const SifatItem(
            number: 5,
            title: 'Persamaan Linear',
            description: 'Persamaan dengan variabel berpangkat 1.',
            example: '2x + 5 = 11  →  cari nilai x',
          ),

          // ── Langkah Selesaikan Persamaan ─────────────────────────────
          ContohBox(
            title: 'Cara Selesaikan Persamaan Linear',
            content: const _LinearEqSteps(),
          ),

          // ── Contoh Lebih Lanjut ───────────────────────────────────────
          ContohBox(
            title: 'Contoh: 3x − 4 = 11',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _AlgStep(label: 'Pindahkan -4:', expr: '3x = 11 + 4 = 15'),
                _AlgStep(label: 'Bagi dua sisi dengan 3:', expr: 'x = 15 ÷ 3'),
                _AlgStep(label: 'Jawaban:', expr: 'x = 5  ✅'),
              ],
            ),
          ),

          // ── Operasi Aljabar ───────────────────────────────────────────
          const SectionTitle('📐 Aturan Operasi Aljabar'),
          const FormulaCard(
            label: 'GABUNGKAN SUKU SEJENIS',
            formula: 'ax + bx = (a+b)x',
          ),
          const FormulaCard(
            label: 'DISTRIBUTIF',
            formula: 'a(b + c) = ab + ac',
          ),
          const FormulaCard(
            label: 'MEMINDAHKAN RUAS',
            formula: 'x + a = b  →  x = b − a',
          ),
          const FormulaCard(
            label: 'PERSAMAAN LINEAR (1 VARIABEL)',
            formula: 'ax + b = c  →  x = (c − b) / a',
          ),

          const TipsBox(
            text: 'Trik mencari x:\n'
                '"Apa yang ada di satu sisi, pindahkan ke sisi lain '
                'dengan tanda berlawanan!"\n\n'
                '+ pindah jadi −\n'
                '× pindah jadi ÷\n\n'
                'Selalu lakukan hal yang sama pada KEDUA sisi persamaan!',
          ),
        ],
      ),
    );
  }
}

class _LinearEqSteps extends StatelessWidget {
  const _LinearEqSteps();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Selesaikan: 2x + 5 = 11',
          style: TextStyle(
            fontFamily: 'Fredoka One',
            fontSize: 15,
            color: kRumusTextDark,
          ),
        ),
        SizedBox(height: 10),
        _AlgStep(label: 'Langkah 1 — Kurangi 5:', expr: '2x = 11 − 5 = 6'),
        _AlgStep(label: 'Langkah 2 — Bagi 2:', expr: 'x = 6 ÷ 2'),
        _AlgStep(label: 'Jawaban:', expr: 'x = 3  ✅'),
        SizedBox(height: 6),
        Text(
          'Cek: 2(3) + 5 = 6 + 5 = 11  ✅',
          style: TextStyle(fontSize: 13, color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _AlgStep extends StatelessWidget {
  const _AlgStep({required this.label, required this.expr});
  final String label;
  final String expr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12, color: kRumusTextMuted,
                    fontStyle: FontStyle.italic)),
          ),
          Expanded(
            child: Text(expr,
                style: const TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 14,
                    color: kRumusTextDark)),
          ),
        ],
      ),
    );
  }
}
