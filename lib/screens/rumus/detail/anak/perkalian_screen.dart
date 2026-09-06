// lib/screens/rumus/detail/anak/perkalian_screen.dart
//
// Detail page: Perkalian (Multiplication) — Rumus Anak tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PerkalianScreen extends StatelessWidget {
  const PerkalianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Dasar',
      topicTitle: 'Perkalian',
      mascotEmoji: '✖️',
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
            emoji: '✖️',
            title: 'Perkalian',
            definition:
                'Penjumlahan berulang suatu bilangan sebanyak bilangan pengali. '
                '3 × 4 artinya 3 dijumlahkan 4 kali.',
          ),

          // ── Sifat ────────────────────────────────────────────────────
          const SectionTitle('📋 Sifat Perkalian'),
          const SifatItem(
            number: 1,
            title: 'Komutatif',
            description: 'Urutan faktor tidak mengubah hasil.',
            example: '4 × 7 = 7 × 4 = 28',
          ),
          const SifatItem(
            number: 2,
            title: 'Asosiatif',
            description: 'Pengelompokan faktor tidak mengubah hasil.',
            example: '(2 × 3) × 5 = 2 × (3 × 5) = 30',
          ),
          const SifatItem(
            number: 3,
            title: 'Distributif terhadap Penjumlahan',
            description: 'Perkalian menyebar ke setiap suku dalam kurung.',
            example: '3 × (4 + 5) = (3×4) + (3×5) = 12 + 15 = 27',
          ),
          const SifatItem(
            number: 4,
            title: 'Identitas (Satu)',
            description: 'Perkalian dengan 1 menghasilkan bilangan itu sendiri.',
            example: '9 × 1 = 9',
          ),
          const SifatItem(
            number: 5,
            title: 'Nol',
            description: 'Perkalian dengan 0 selalu menghasilkan 0.',
            example: '999 × 0 = 0',
          ),

          // ── Tabel Perkalian ──────────────────────────────────────────
          ContohBox(
            title: 'Tabel Perkalian 1–5',
            content: _MultiplicationTable(),
          ),

          // ── Contoh ───────────────────────────────────────────────────
          ContohBox(
            title: 'Contoh Perhitungan',
            content: const VerticalCalcExample(
              top: '34',
              operator: '×',
              bottom: '6',
              result: '204',
            ),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus'),
          const FormulaCard(
            label: 'PERKALIAN',
            formula: 'a × b = hasil kali',
          ),
          const FormulaCard(
            label: 'PENJUMLAHAN BERULANG',
            formula: 'a × b = a + a + … (b kali)',
          ),

          // ── Tips ─────────────────────────────────────────────────────
          const TipsBox(
            text: 'Hafal perkalian 1–10 dengan cara bernyanyi atau "jarimatika"!\n'
                'Perkalian 9: hasil selalu berurutan turun (9, 18, 27, 36, …)\n'
                'Dan angka-angkanya selalu berjumlah 9!  🌟',
          ),
        ],
      ),
    );
  }
}

// Mini multiplication table widget
class _MultiplicationTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const base = [1, 2, 3, 4, 5];
    return Table(
      border: TableBorder.all(color: kDivider, borderRadius: BorderRadius.circular(4)),
      defaultColumnWidth: const FlexColumnWidth(),
      children: [
        // Header row
        TableRow(
          decoration: const BoxDecoration(color: kRumusOrange),
          children: ['×', ...base.map((e) => '$e')]
              .map((h) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Center(
                      child: Text(h,
                          style: const TextStyle(
                            fontFamily: 'Fredoka One',
                            color: Colors.white,
                            fontSize: 13,
                          )),
                    ),
                  ))
              .toList(),
        ),
        ...base.map((row) => TableRow(
              children: [
                // Row header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Center(
                    child: Text(
                      '$row',
                      style: const TextStyle(
                        fontFamily: 'Fredoka One',
                        color: kRumusOrange,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ...base.map((col) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Center(
                        child: Text(
                          '${row * col}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: kRumusTextDark,
                          ),
                        ),
                      ),
                    )),
              ],
            )),
      ],
    );
  }
}
