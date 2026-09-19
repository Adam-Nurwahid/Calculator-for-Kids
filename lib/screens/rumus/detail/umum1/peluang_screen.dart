// lib/screens/rumus/detail/umum1/peluang_screen.dart
//
// Detail page: Peluang (Probability) — Rumus Umum 1 tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PeluangScreen extends StatelessWidget {
  const PeluangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '🎲',
            title: 'Peluang (Probabilitas)',
            definition:
                'Ukuran kemungkinan suatu kejadian akan terjadi. '
                'Nilainya antara 0 (mustahil) dan 1 (pasti).',
          ),

          // ── Sifat ────────────────────────────────────────────────────
          const SectionTitle('📋 Konsep Dasar'),
          const SifatItem(
            number: 1,
            title: 'Ruang Sampel (S)',
            description:
                'Semua hasil yang mungkin terjadi dari suatu percobaan.',
            example: 'Melempar dadu: S = {1, 2, 3, 4, 5, 6}',
          ),
          const SifatItem(
            number: 2,
            title: 'Kejadian (A)',
            description:
                'Himpunan hasil yang kita inginkan (subset dari S).',
            example: 'Mendapat angka genap: A = {2, 4, 6}',
          ),
          const SifatItem(
            number: 3,
            title: 'Peluang Kejadian P(A)',
            description: 'Jumlah hasil yang diinginkan dibagi total kemungkinan.',
            example: 'P(genap) = 3/6 = ½ = 0,5',
          ),
          const SifatItem(
            number: 4,
            title: 'Peluang Komplemen',
            description: 'Peluang kejadian TIDAK terjadi.',
            example: "P(bukan A) = 1 − P(A)\nP(bukan genap) = 1 − ½ = ½",
          ),
          const SifatItem(
            number: 5,
            title: 'Rentang Nilai Peluang',
            description: 'Peluang selalu antara 0 dan 1.',
            example: '0 ≤ P(A) ≤ 1',
          ),

          // ── Contoh ───────────────────────────────────────────────────
          ContohBox(
            title: 'Contoh: Mengocok Kartu',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dari kartu 1–10, berapa peluang mendapat kartu ≥ 7?',
                  style: TextStyle(fontSize: 13, color: kRumusTextDark),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Kejadian A = {7, 8, 9, 10}  → n(A) = 4\n'
                  '• Ruang sampel S = {1, …, 10}  → n(S) = 10',
                  style: TextStyle(fontSize: 13, color: kRumusTextMuted),
                ),
                const SizedBox(height: 6),
                const Text(
                  'P(A) = 4/10 = 2/5 = 0,4  ✅',
                  style: TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 16,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          ContohBox(
            title: 'Contoh: Koin',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Melempar koin 1 kali:\n'
                  '  S = {Angka, Gambar}  → n(S) = 2',
                  style: TextStyle(fontSize: 13, color: kRumusTextMuted),
                ),
                const SizedBox(height: 6),
                const Text(
                  'P(Angka) = 1/2 = 0,5 = 50%',
                  style: TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 15,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus Peluang'),
          const FormulaCard(
            label: 'PELUANG SUATU KEJADIAN',
            formula: 'P(A) = n(A) / n(S)',
          ),
          const FormulaCard(
            label: 'KOMPLEMEN',
            formula: "P(Aᶜ) = 1 − P(A)",
          ),
          const FormulaCard(
            label: 'NILAI PASTI',
            formula: '0 ≤ P(A) ≤ 1',
          ),

          const TipsBox(
            text: 'Cara mudah membaca peluang:\n'
                '• P = 0 → mustahil (tidak pernah terjadi)\n'
                '• P = 0,5 → sama kemungkinan ya/tidak\n'
                '• P = 1 → pasti terjadi\n\n'
                'Semakin mendekati 1, semakin besar kemungkinannya!  🎲',
          ),
        ],
      ),
    );
  }
}
