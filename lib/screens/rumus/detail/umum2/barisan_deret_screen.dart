// lib/screens/rumus/detail/umum2/barisan_deret_screen.dart
//
// Detail page: Barisan & Deret (Sequences & Series) — Rumus Umum 2 tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class BarisanDeretScreen extends StatelessWidget {
  const BarisanDeretScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '🔢',
            title: 'Barisan & Deret',
            definition:
                'Barisan: urutan bilangan dengan pola tertentu. '
                'Deret: jumlah semua suku dalam barisan.',
          ),

          // ── Barisan Aritmatika ────────────────────────────────────────
          const SectionTitle('➕ Barisan Aritmatika (BA)'),
          const SifatItem(
            number: 1,
            title: 'Definisi',
            description:
                'Setiap suku bertambah (atau berkurang) dengan nilai yang sama: '
                'beda (b).',
            example: '2, 5, 8, 11, 14  →  b = 3',
          ),
          const SifatItem(
            number: 2,
            title: 'Suku ke-n',
            description: 'Untuk mencari nilai suku mana pun.',
            example: 'Uₙ = a + (n−1)b\nU₅ dari 2,5,8,… = 2 + 4×3 = 14',
          ),
          const SifatItem(
            number: 3,
            title: 'Jumlah n Suku Pertama (Sₙ)',
            description: 'Jumlahkan seluruh suku dari U₁ sampai Uₙ.',
            example: 'Sₙ = n/2 × (2a + (n−1)b)\nS₄ = 2(4 + 9) = 26',
          ),

          // ── Contoh BA ─────────────────────────────────────────────────
          ContohBox(
            title: 'Contoh Barisan Aritmatika',
            content: const _BAExample(),
          ),

          // ── Barisan Geometri ──────────────────────────────────────────
          const SectionTitle('✖️ Barisan Geometri (BG)'),
          const SifatItem(
            number: 4,
            title: 'Definisi',
            description:
                'Setiap suku dikalikan dengan nilai yang sama: rasio (r).',
            example: '3, 6, 12, 24, 48  →  r = 2',
          ),
          const SifatItem(
            number: 5,
            title: 'Suku ke-n',
            description: 'Untuk mencari nilai suku geometri mana pun.',
            example: 'Uₙ = a × rⁿ⁻¹\nU₅ dari 3,6,12,… = 3 × 2⁴ = 48',
          ),
          const SifatItem(
            number: 6,
            title: 'Jumlah n Suku (Sₙ)',
            description: 'Jumlahkan seluruh suku geometri.',
            example: 'Sₙ = a(rⁿ − 1) / (r − 1)   jika r ≠ 1',
          ),
          const SifatItem(
            number: 7,
            title: 'Deret Geometri Tak Hingga (r < 1)',
            description: 'Jika |r| < 1, jumlah tak terbatas bisa dihitung.',
            example: 'S∞ = a / (1 − r)\nS∞ dari ½, ¼, ⅛,… = (½)/(1−½) = 1',
          ),

          // ── Contoh BG ─────────────────────────────────────────────────
          ContohBox(
            title: 'Contoh Barisan Geometri',
            content: const _BGExample(),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus Ringkasan'),
          const _SubTitle('Barisan Aritmatika'),
          const FormulaCard(label: 'SUKU ke-n', formula: 'Uₙ = a + (n−1)b'),
          const FormulaCard(
              label: 'JUMLAH n SUKU',
              formula: 'Sₙ = n/2 × (U₁ + Uₙ)  atau  n/2 × (2a + (n−1)b)'),
          const _SubTitle('Barisan Geometri'),
          const FormulaCard(label: 'SUKU ke-n', formula: 'Uₙ = a × rⁿ⁻¹'),
          const FormulaCard(
              label: 'JUMLAH n SUKU',
              formula: 'Sₙ = a(rⁿ − 1) / (r − 1)   jika r > 1'),
          const FormulaCard(
              label: 'DERET TAK HINGGA',
              formula: 'S∞ = a / (1 − r)   jika |r| < 1'),

          const TipsBox(
            text: 'Cara cek jenis barisan:\n'
                '• Kurangi setiap suku berurutan → sama? → Aritmatika\n'
                '• Bagi setiap suku berurutan → sama? → Geometri\n\n'
                'Contoh:\n'
                '2, 4, 6, 8 → selisih 2 (sama) → Aritmatika ➕\n'
                '2, 4, 8, 16 → rasio 2 (sama) → Geometri ✖️',
          ),
        ],
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Fredoka One',
          fontSize: 15,
          color: kRumusOrange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BAExample extends StatelessWidget {
  const _BAExample();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Barisan: 3, 7, 11, 15, 19, …\na = 3,  b = 4',
          style: TextStyle(
              fontFamily: 'Fredoka One', fontSize: 14, color: kRumusTextDark),
        ),
        const SizedBox(height: 10),
        _CalcRow('U₁₀', '= 3 + (10−1) × 4 = 3 + 36', '= 39'),
        _CalcRow('S₁₀', '= 10/2 × (2×3 + 9×4)', '= 5 × 42 = 210'),
      ],
    );
  }
}

class _BGExample extends StatelessWidget {
  const _BGExample();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Barisan: 5, 10, 20, 40, …\na = 5,  r = 2',
          style: TextStyle(
              fontFamily: 'Fredoka One', fontSize: 14, color: kRumusTextDark),
        ),
        const SizedBox(height: 10),
        _CalcRow('U₆', '= 5 × 2⁵ = 5 × 32', '= 160'),
        _CalcRow('S₆', '= 5(2⁶−1)/(2−1) = 5 × 63', '= 315'),
      ],
    );
  }
}

class _CalcRow extends StatelessWidget {
  const _CalcRow(this.label, this.mid, this.result);
  final String label;
  final String mid;
  final String result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: kRumusTextDark),
          children: [
            TextSpan(
                text: '$label  ',
                style: const TextStyle(
                    fontFamily: 'Fredoka One',
                    color: kRumusOrange,
                    fontWeight: FontWeight.bold)),
            TextSpan(text: mid),
            TextSpan(
                text: '  $result',
                style: const TextStyle(
                    fontFamily: 'Fredoka One',
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
