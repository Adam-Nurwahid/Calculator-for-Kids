// lib/screens/rumus/detail/umum1/konversi_persen_screen.dart
//
// Detail page: Konversi Persen (Percent Conversion) — Rumus Umum 1 tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class KonversiPersenScreen extends StatelessWidget {
  const KonversiPersenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Umum 1',
      topicTitle: 'Konversi Persen',
      mascotEmoji: '🦊',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '%',
            title: 'Persen & Konversi',
            definition:
                'Persen (%) artinya "per seratus". 25% berarti 25 dari 100 '
                'bagian. Bisa dikonversi ke pecahan atau desimal.',
          ),

          // ── Sifat ────────────────────────────────────────────────────
          const SectionTitle('📋 Cara Konversi'),
          const SifatItem(
            number: 1,
            title: 'Persen → Pecahan',
            description: 'Tulis a% sebagai a/100, lalu sederhanakan.',
            example: '75% = 75/100 = ¾',
          ),
          const SifatItem(
            number: 2,
            title: 'Pecahan → Persen',
            description: 'Kalikan pecahan dengan 100%.',
            example: '⅖ × 100% = 40%',
          ),
          const SifatItem(
            number: 3,
            title: 'Persen → Desimal',
            description: 'Bagi angka persen dengan 100 (geser koma 2 langkah kiri).',
            example: '35% = 0,35',
          ),
          const SifatItem(
            number: 4,
            title: 'Desimal → Persen',
            description: 'Kalikan dengan 100 (geser koma 2 langkah kanan).',
            example: '0,08 × 100 = 8%',
          ),
          const SifatItem(
            number: 5,
            title: 'Mencari Nilai Persen dari Suatu Bilangan',
            description: 'Kalikan persen dengan bilangan tersebut.',
            example: '30% dari 200 = 30/100 × 200 = 60',
          ),

          // ── Tabel Konversi ────────────────────────────────────────────
          ContohBox(
            title: 'Tabel Konversi Umum',
            content: const _ConversionTable(),
          ),

          // ── Contoh Soal ───────────────────────────────────────────────
          ContohBox(
            title: 'Contoh Soal',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _SolvedProblem(
                  question: 'Berapa 15% dari 80?',
                  solution: '15/100 × 80 = 0,15 × 80 = 12',
                ),
                SizedBox(height: 10),
                _SolvedProblem(
                  question: 'Nilai siswa 45 dari 60. Berapa persennya?',
                  solution: '45/60 × 100% = 75%',
                ),
              ],
            ),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus'),
          const FormulaCard(label: 'PERSEN DARI BILANGAN', formula: 'Nilai = p/100 × Bilangan'),
          const FormulaCard(label: 'NILAI PERSEN', formula: 'p% = Bagian/Total × 100%'),
          const FormulaCard(label: 'KENAIKAN PERSEN', formula: 'Kenaikan% = Δ/Asal × 100%'),

          const TipsBox(
            text: 'Trik cepat:\n'
                '• 50% = ½ dari bilangan\n'
                '• 25% = ¼ dari bilangan\n'
                '• 10% = bagi 10\n'
                '• 1%  = bagi 100\n'
                'Gabungkan: 35% = 25% + 10%  💡',
          ),
        ],
      ),
    );
  }
}

class _ConversionTable extends StatelessWidget {
  const _ConversionTable();

  static const rows = [
    ('%',   'Pecahan', 'Desimal'),
    ('10%',  '1/10',   '0,1'),
    ('20%',  '1/5',    '0,2'),
    ('25%',  '1/4',    '0,25'),
    ('50%',  '1/2',    '0,5'),
    ('75%',  '3/4',    '0,75'),
    ('100%', '1',      '1,0'),
  ];

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: kDivider, borderRadius: BorderRadius.circular(4)),
      defaultColumnWidth: const FlexColumnWidth(),
      children: rows.map((r) {
        final isHeader = r.$1 == '%';
        return TableRow(
          decoration: BoxDecoration(
            color: isHeader ? kRumusOrange : Colors.transparent,
          ),
          children: [r.$1, r.$2, r.$3].map((cell) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
              child: Text(
                cell,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Fredoka One',
                  fontSize: 13,
                  color: isHeader ? Colors.white : kRumusTextDark,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _SolvedProblem extends StatelessWidget {
  const _SolvedProblem({required this.question, required this.solution});
  final String question;
  final String solution;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('❓ ', style: TextStyle(fontSize: 14)),
            Expanded(
              child: Text(question,
                  style: const TextStyle(
                      fontSize: 14, color: kRumusTextDark,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '✅ $solution',
          style: const TextStyle(
              fontFamily: 'Fredoka One',
              fontSize: 14,
              color: Color(0xFF2E7D32)),
        ),
      ],
    );
  }
}
