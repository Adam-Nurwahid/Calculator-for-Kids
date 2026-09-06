// lib/screens/rumus/detail/umum1/pangkat_screen.dart
//
// Detail page: Pangkat (Exponents / Powers) — Rumus Umum 1 tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PangkatScreen extends StatelessWidget {
  const PangkatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Umum 1',
      topicTitle: 'Pangkat',
      mascotEmoji: '🦊',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '²',
            title: 'Pangkat (Eksponen)',
            definition:
                'Bilangan yang dikalikan dengan dirinya sendiri sebanyak '
                'pangkatnya. Ditulis aⁿ, artinya a × a × … × a (n kali).',
          ),

          // ── Sifat Pangkat ────────────────────────────────────────────
          const SectionTitle('📋 Sifat Pangkat'),
          const SifatItem(
            number: 1,
            title: 'Perkalian Pangkat Sama',
            description: 'Basis sama, pangkat dijumlahkan.',
            example: 'aᵐ × aⁿ = aᵐ⁺ⁿ\n2³ × 2² = 2⁵ = 32',
          ),
          const SifatItem(
            number: 2,
            title: 'Pembagian Pangkat Sama',
            description: 'Basis sama, pangkat dikurangkan.',
            example: 'aᵐ ÷ aⁿ = aᵐ⁻ⁿ\n3⁵ ÷ 3² = 3³ = 27',
          ),
          const SifatItem(
            number: 3,
            title: 'Pangkat dari Pangkat',
            description: 'Pangkat dikalikan.',
            example: '(aᵐ)ⁿ = aᵐˣⁿ\n(2²)³ = 2⁶ = 64',
          ),
          const SifatItem(
            number: 4,
            title: 'Pangkat Nol',
            description: 'Bilangan apapun (≠0) berpangkat 0 = 1.',
            example: 'a⁰ = 1\n100⁰ = 1',
          ),
          const SifatItem(
            number: 5,
            title: 'Pangkat Negatif',
            description: 'Pangkat negatif artinya kebalikan (resiprokal).',
            example: 'a⁻ⁿ = 1 / aⁿ\n2⁻³ = 1/8',
          ),
          const SifatItem(
            number: 6,
            title: 'Pangkat Pecahan',
            description: 'Pangkat ½ sama dengan akar kuadrat.',
            example: 'a^(1/2) = √a\n9^(1/2) = 3',
          ),

          // ── Contoh ───────────────────────────────────────────────────
          ContohBox(
            title: 'Daftar Kuadrat Sempurna',
            content: const _PerfectSquaresTable(),
          ),

          ContohBox(
            title: 'Contoh Perhitungan',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _PowerStep(expr: '2⁵', step: '= 2 × 2 × 2 × 2 × 2', result: '= 32'),
                SizedBox(height: 8),
                _PowerStep(expr: '(3²)² = 3⁴', step: '= 81', result: ''),
              ],
            ),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus Pangkat'),
          const FormulaCard(label: 'DEFINISI', formula: 'aⁿ = a × a × … × a  (n kali)'),
          const FormulaCard(label: 'PERKALIAN', formula: 'aᵐ × aⁿ = aᵐ⁺ⁿ'),
          const FormulaCard(label: 'PEMBAGIAN', formula: 'aᵐ ÷ aⁿ = aᵐ⁻ⁿ'),
          const FormulaCard(label: 'PANGKAT NESTING', formula: '(aᵐ)ⁿ = aᵐⁿ'),
          const FormulaCard(label: 'PANGKAT NOL', formula: 'a⁰ = 1   (a ≠ 0)'),

          const TipsBox(
            text: 'Hafalkan pangkat 2 sampai 10:\n'
                '2²=4  3²=9  4²=16  5²=25\n'
                '6²=36  7²=49  8²=64  9²=81  10²=100\n\n'
                'Pangkat 2 = kuadrat, Pangkat 3 = kubik!',
          ),
        ],
      ),
    );
  }
}

class _PerfectSquaresTable extends StatelessWidget {
  const _PerfectSquaresTable();

  @override
  Widget build(BuildContext context) {
    final data = [for (int i = 1; i <= 10; i++) (i, i * i)];
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: data
          .map((e) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: kFormulaBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kFormulaBorder),
                ),
                child: Text(
                  '${e.$1}² = ${e.$2}',
                  style: const TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 13,
                    color: kRumusTextDark,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _PowerStep extends StatelessWidget {
  const _PowerStep(
      {required this.expr, required this.step, required this.result});
  final String expr;
  final String step;
  final String result;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontFamily: 'Fredoka One', fontSize: 15, color: kRumusTextDark),
        children: [
          TextSpan(text: expr,
              style: const TextStyle(color: kRumusOrange, fontWeight: FontWeight.bold)),
          TextSpan(text: '  $step'),
          if (result.isNotEmpty)
            TextSpan(
                text: '  $result',
                style: const TextStyle(color: Color(0xFF2E7D32))),
        ],
      ),
    );
  }
}
