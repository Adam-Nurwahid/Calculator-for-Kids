// lib/screens/rumus/detail/anak/penjumlahan_screen.dart
//
// Detail page: Penjumlahan (Addition) — Rumus Anak tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PenjumlahanScreen extends StatelessWidget {
  const PenjumlahanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Dasar',
      topicTitle: 'Penjumlahan',
      mascotEmoji: '➕',
      headerExtra: OperatorTabRow(
        operators: const ['+', '−', '×', '÷'],
        routes: const [
          '/rumus/anak/penjumlahan',
          '/rumus/anak/pengurangan',
          '/rumus/anak/perkalian',
          '/rumus/anak/pembagian',
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Definisi ──────────────────────────────────────────────────
          const RumusTopicDefinition(
            emoji: '➕',
            title: 'Penjumlahan',
            definition:
                'Operasi menggabungkan dua bilangan atau lebih menjadi satu '
                'bilangan yang disebut jumlah (sum).',
          ),

          // ── Sifat ────────────────────────────────────────────────────
          const SectionTitle('📋 Sifat Penjumlahan'),
          const SifatItem(
            number: 1,
            title: 'Komutatif',
            description: 'Urutan bilangan tidak mengubah hasil.',
            example: 'a + b = b + a\n3 + 5 = 5 + 3 = 8',
          ),
          const SifatItem(
            number: 2,
            title: 'Asosiatif',
            description: 'Pengelompokan bilangan tidak mengubah hasil.',
            example: '(2 + 3) + 4 = 2 + (3 + 4) = 9',
          ),
          const SifatItem(
            number: 3,
            title: 'Unsur Identitas (Nol)',
            description: 'Menjumlahkan dengan 0 tidak mengubah bilangan.',
            example: '7 + 0 = 7',
          ),
          const SifatItem(
            number: 4,
            title: 'Tertutup',
            description:
                'Hasil penjumlahan dua bilangan bulat selalu bilangan bulat.',
            example: '4 + 6 = 10  ✅',
          ),

          // ── Contoh ───────────────────────────────────────────────────
          ContohBox(
            title: 'Contoh Perhitungan',
            content: const VerticalCalcExample(
              top: '247',
              operator: '+',
              bottom: '138',
              result: '385',
            ),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus'),
          const FormulaCard(
            label: 'PENJUMLAHAN',
            formula: 'a + b = jumlah',
          ),

          // ── Tips ─────────────────────────────────────────────────────
          const TipsBox(
            text: 'Kamu bisa menjumlahkan dari yang paling mudah dulu!\n'
                'Contoh: 48 + 37 → (48 + 2) + 35 = 50 + 35 = 85  🎉',
          ),
        ],
      ),
    );
  }
}
