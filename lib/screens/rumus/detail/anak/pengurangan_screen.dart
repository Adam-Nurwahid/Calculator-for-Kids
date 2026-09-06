// lib/screens/rumus/detail/anak/pengurangan_screen.dart
//
// Detail page: Pengurangan (Subtraction) — Rumus Anak tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PenguranganScreen extends StatelessWidget {
  const PenguranganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Dasar',
      topicTitle: 'Pengurangan',
      mascotEmoji: '➖',
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
            emoji: '➖',
            title: 'Pengurangan',
            definition:
                'Operasi mencari selisih antara dua bilangan. '
                'Bilangan pertama dikurangi bilangan kedua.',
          ),

          // ── Sifat ────────────────────────────────────────────────────
          const SectionTitle('📋 Sifat Pengurangan'),
          const SifatItem(
            number: 1,
            title: 'Tidak Komutatif',
            description: 'Urutan PENTING dalam pengurangan — tidak bisa dibalik.',
            example: '8 − 3 = 5, tapi 3 − 8 ≠ 5',
          ),
          const SifatItem(
            number: 2,
            title: 'Tidak Asosiatif',
            description: 'Pengelompokan mempengaruhi hasil.',
            example: '(10 − 4) − 2 = 4 ≠ 10 − (4 − 2) = 8',
          ),
          const SifatItem(
            number: 3,
            title: 'Unsur Identitas (Nol)',
            description: 'Mengurangi dengan 0 tidak mengubah bilangan.',
            example: '9 − 0 = 9',
          ),
          const SifatItem(
            number: 4,
            title: 'Hubungan dengan Penjumlahan',
            description:
                'Pengurangan adalah kebalikan penjumlahan (operasi invers).',
            example: 'Jika 5 + 3 = 8, maka 8 − 3 = 5',
          ),

          // ── Contoh ───────────────────────────────────────────────────
          ContohBox(
            title: 'Contoh Perhitungan',
            content: const VerticalCalcExample(
              top: '532',
              operator: '−',
              bottom: '274',
              result: '258',
            ),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus'),
          const FormulaCard(
            label: 'PENGURANGAN',
            formula: 'a − b = selisih',
          ),

          // ── Tips ─────────────────────────────────────────────────────
          const TipsBox(
            text: 'Saat meminjam angka, ingat: 1 puluhan = 10 satuan.\n'
                'Contoh: 42 − 17 → 12 − 7 = 5, lalu 3 − 1 = 2 → hasilnya 25  😊',
          ),
        ],
      ),
    );
  }
}
