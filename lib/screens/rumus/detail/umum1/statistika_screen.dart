// lib/screens/rumus/detail/umum1/statistika_screen.dart
//
// Detail page: Statistika (Statistics) — Rumus Umum 1 tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class StatistikaScreen extends StatelessWidget {
  const StatistikaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Umum 1',
      topicTitle: 'Statistika',
      mascotEmoji: '🦊',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '📊',
            title: 'Statistika',
            definition:
                'Ilmu mengumpulkan, menyusun, dan menganalisis data '
                'untuk mengambil kesimpulan.',
          ),

          // ── Ukuran Pemusatan ─────────────────────────────────────────
          const SectionTitle('📋 Ukuran Pemusatan Data'),
          const SifatItem(
            number: 1,
            title: 'Mean (Rata-rata)',
            description: 'Jumlah semua data dibagi banyaknya data.',
            example: 'Data: 4, 7, 8, 5, 6\nMean = (4+7+8+5+6)/5 = 30/5 = 6',
          ),
          const SifatItem(
            number: 2,
            title: 'Median (Nilai Tengah)',
            description: 'Nilai tengah data setelah diurutkan.',
            example: 'Urut: 4, 5, 6, 7, 8\nMedian = 6 (posisi ke-3)',
          ),
          const SifatItem(
            number: 3,
            title: 'Modus (Nilai Terbanyak)',
            description: 'Nilai yang paling sering muncul.',
            example: 'Data: 3, 5, 5, 7, 8, 5\nModus = 5 (muncul 3×)',
          ),
          const SifatItem(
            number: 4,
            title: 'Jangkauan (Range)',
            description: 'Selisih data terbesar dan terkecil.',
            example: 'Data: 3, 5, 5, 7, 8\nJangkauan = 8 − 3 = 5',
          ),

          // ── Median genap ─────────────────────────────────────────────
          const SectionTitle('📋 Median Data Genap'),
          const SifatItem(
            number: 5,
            title: 'Jika jumlah data GENAP',
            description: 'Median = rata-rata dua nilai tengah.',
            example: 'Urut: 3, 5, 7, 9  (n=4)\nMedian = (5+7)/2 = 6',
          ),

          // ── Contoh Lengkap ────────────────────────────────────────────
          ContohBox(
            title: 'Contoh Lengkap',
            content: const _CompleteStatExample(),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus Statistika'),
          const FormulaCard(
            label: 'MEAN (RATA-RATA)',
            formula: 'x̄ = (x₁ + x₂ + … + xₙ) / n',
          ),
          const FormulaCard(
            label: 'JANGKAUAN',
            formula: 'Range = nilai_max − nilai_min',
          ),
          const FormulaCard(
            label: 'MEDIAN (n GANJIL)',
            formula: 'Median = data ke-(n+1)/2  (setelah diurutkan)',
          ),
          const FormulaCard(
            label: 'MEDIAN (n GENAP)',
            formula: 'Median = rata-rata data ke-n/2 dan (n/2)+1',
          ),

          const TipsBox(
            text: 'Urutan langkah analisis data:\n'
                '1️⃣ Kumpulkan data\n'
                '2️⃣ Urutkan dari kecil ke besar\n'
                '3️⃣ Hitung mean, median, modus, range\n'
                '4️⃣ Buat kesimpulan!\n\n'
                'Mean terpengaruh oleh data ekstrem, median lebih stabil!',
          ),
        ],
      ),
    );
  }
}

class _CompleteStatExample extends StatelessWidget {
  const _CompleteStatExample();

  @override
  Widget build(BuildContext context) {
    const data = [72, 68, 85, 91, 68, 74, 80];
    const sorted = [68, 68, 72, 74, 80, 85, 91];
    const mean = (72 + 68 + 85 + 91 + 68 + 74 + 80) / 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nilai ujian: 72, 68, 85, 91, 68, 74, 80',
          style: TextStyle(
            fontFamily: 'Fredoka One',
            fontSize: 14,
            color: kRumusTextDark,
          ),
        ),
        const SizedBox(height: 6),
        _StatResult(label: 'Diurutkan:', value: '${sorted.join(", ")}'),
        _StatResult(
          label: 'Mean:',
          value:
              '(${data.reduce((a, b) => a + b)}) ÷ ${data.length} = ${mean.toStringAsFixed(1)}',
        ),
        _StatResult(label: 'Median:', value: '${sorted[3]} (posisi ke-4)'),
        _StatResult(label: 'Modus:', value: '68 (muncul 2×)'),
        _StatResult(label: 'Range:', value: '91 − 68 = 23'),
      ],
    );
  }
}

class _StatResult extends StatelessWidget {
  const _StatResult({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: kRumusOrange,
                    fontFamily: 'Fredoka One')),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, color: kRumusTextDark)),
          ),
        ],
      ),
    );
  }
}
