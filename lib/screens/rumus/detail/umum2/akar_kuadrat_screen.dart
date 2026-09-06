// lib/screens/rumus/detail/umum2/akar_kuadrat_screen.dart
//
// Detail page: Akar Kuadrat (Square Roots) — Rumus Umum 2 tier.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class AkarKuadratScreen extends StatelessWidget {
  const AkarKuadratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Umum 2',
      topicTitle: 'Akar Kuadrat',
      mascotEmoji: '🦅',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '√',
            title: 'Akar Kuadrat',
            definition:
                'Kebalikan dari pengkuadratan. √a adalah bilangan yang '
                'kalau dikuadratkan menghasilkan a.',
          ),

          // ── Sifat ────────────────────────────────────────────────────
          const SectionTitle('📋 Sifat Akar Kuadrat'),
          const SifatItem(
            number: 1,
            title: 'Definisi',
            description: '√a = b  berarti  b² = a  (untuk a ≥ 0)',
            example: '√25 = 5  karena  5² = 25',
          ),
          const SifatItem(
            number: 2,
            title: 'Perkalian',
            description: 'Akar dari perkalian = perkalian akar-akarnya.',
            example: '√(a × b) = √a × √b\n√(4 × 9) = 2 × 3 = 6',
          ),
          const SifatItem(
            number: 3,
            title: 'Pembagian',
            description: 'Akar dari pembagian = pembagian akar-akarnya.',
            example: '√(a / b) = √a / √b\n√(16/4) = 4/2 = 2',
          ),
          const SifatItem(
            number: 4,
            title: 'Akar dari Pangkat',
            description: 'Akar kuadrat dari aⁿ = a^(n/2).',
            example: '√(a²) = a\n√(49) = 7',
          ),
          const SifatItem(
            number: 5,
            title: 'Menyederhanakan Akar',
            description: 'Pisahkan faktor kuadrat sempurna dari bilangan.',
            example: '√50 = √(25 × 2) = 5√2',
          ),
          const SifatItem(
            number: 6,
            title: 'Merasionalkan Penyebut',
            description: 'Hilangkan akar dari penyebut dengan mengalikan sekawan.',
            example: '1/√2 = √2/2',
          ),

          // ── Daftar Akar Sempurna ──────────────────────────────────────
          ContohBox(
            title: 'Daftar Akar Kuadrat Sempurna',
            content: const _SqrtGrid(),
          ),

          // ── Estimasi ─────────────────────────────────────────────────
          ContohBox(
            title: 'Cara Estimasi √N',
            content: const _EstimationSteps(),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus Akar'),
          const FormulaCard(label: 'DEFINISI', formula: '√a = b  ⟺  b² = a'),
          const FormulaCard(label: 'PERKALIAN', formula: '√(a·b) = √a · √b'),
          const FormulaCard(label: 'PEMBAGIAN', formula: '√(a/b) = √a / √b'),
          const FormulaCard(
              label: 'AKAR LEBIH TINGGI',
              formula: 'ⁿ√a = a^(1/n)   →   ³√8 = 2'),

          const TipsBox(
            text: 'Cara cepat estimasi akar:\n'
                '√50 → antara √49=7 dan √64=8\n'
                '50 lebih dekat ke 49, jadi ≈ 7.1\n\n'
                'Hafalkan akar 1–15:\n'
                '√1=1  √4=2  √9=3  √16=4  √25=5\n'
                '√36=6  √49=7  √64=8  √81=9  √100=10  🎉',
          ),
        ],
      ),
    );
  }
}

class _SqrtGrid extends StatelessWidget {
  const _SqrtGrid();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        for (int i = 1; i <= 15; i++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: kFormulaBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kFormulaBorder),
            ),
            child: Text(
              '√${i * i} = $i',
              style: const TextStyle(
                fontFamily: 'Fredoka One',
                fontSize: 12,
                color: kRumusTextDark,
              ),
            ),
          ),
      ],
    );
  }
}

class _EstimationSteps extends StatelessWidget {
  const _EstimationSteps();

  @override
  Widget build(BuildContext context) {
    // Pre-compute non-const value at build time
    final sqrtResult = math.sqrt(20).toStringAsFixed(4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contoh: hitung √20',
          style: TextStyle(
              fontFamily: 'Fredoka One', fontSize: 14, color: kRumusTextDark),
        ),
        const SizedBox(height: 6),
        const _EstStep('Langkah 1:', '√16 = 4 dan √25 = 5, jadi 4 < √20 < 5'),
        const _EstStep('Langkah 2:', '20 lebih dekat ke 16, jadi √20 ≈ 4.5'),
        _EstStep('Kalkulator:', '√20 = $sqrtResult  ✅'),
      ],
    );
  }
}

class _EstStep extends StatelessWidget {
  const _EstStep(this.label, this.text);
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: kRumusOrange,
                    fontFamily: 'Fredoka One')),
          ),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 13, color: kRumusTextDark)),
          ),
        ],
      ),
    );
  }
}
