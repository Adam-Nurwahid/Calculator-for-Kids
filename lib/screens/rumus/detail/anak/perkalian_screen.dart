// lib/screens/rumus/detail/anak/perkalian_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/rumus_widgets.dart';

class PerkalianScreen extends StatelessWidget {
  const PerkalianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Topic Header (Title & Subtitle) ───────────────────────────
          const RumusTopicHeader(
            title: 'Perkalian',
            subtitle:
                'Penjumlahan berulang suatu bilangan sebanyak bilangan pengali.',
          ),

          // ── Sifat Section ──────────────────────────────────────────────
          const SectionTitle('Sifat:'),
          const NumberedPropertyItem(
            number: 1,
            title: 'Bisa Ditukar (Komutatif)',
            description: 'Urutan perkalian dua bilangan tidak mengubah hasil.',
            example: 'a × b = b × a  →  4 × 7 = 7 × 4 = 28',
          ),
          const NumberedPropertyItem(
            number: 2,
            title: 'Bisa Dikelompokkan (Asosiatif)',
            description: 'Pengelompokan urutan perkalian tidak mengubah hasil.',
            example:
                '(a × b) × c = a × (b × c)  →  (2 × 3) × 5 = 2 × (3 × 5) = 30',
          ),
          const NumberedPropertyItem(
            number: 3,
            title: 'Menyebar (Distributif)',
            description:
                'Perkalian menyebar ke setiap suku di dalam tanda kurung.',
            example: '3 × (4 + 5) = (3×4) + (3×5) = 12 + 15 = 27',
          ),
          const NumberedPropertyItem(
            number: 4,
            title: 'Dikali Satu (Identitas)',
            description:
                'Perkalian dengan angka 1 menghasilkan bilangan itu sendiri.',
            example: 'a × 1 = a  →  9 × 1 = 9',
          ),
          const NumberedPropertyItem(
            number: 5,
            title: 'Dikali Nol',
            description: 'Perkalian dengan angka 0 selalu menghasilkan 0.',
            example: 'a × 0 = 0  →  999 × 0 = 0',
          ),

          // ── Tabel Perkalian ──────────────────────────────────────────
          ContohBox(
            title: 'Tabel Perkalian 1–5',
            content: _MultiplicationTable(),
          ),

          // ── Math Calculation Section ──────────────────────────────────
          const SectionTitle('Contoh Perhitungan:'),
          const VerticalMathCalculation(
            topNumber: '34',
            bottomNumber: '6',
            operator: '×',
            resultNumber: '204',
            note:
                'Kalikan 6 × 4 = 24 (tulis 4, simpan 2). Lalu 6 × 3 = 18 + 2 = 20 → 204.',
          ),
          const SizedBox(height: 16),

          // ── Formula Cards ─────────────────────────────────────────────
          const FormulaCard(
            label: 'RUMUS PERKALIAN',
            formula: 'a × b = Hasil Kali',
          ),
          const FormulaCard(
            label: 'PENJUMLAHAN BERULANG',
            formula: 'a × b = a + a + ... (b kali)',
          ),

          // ── Bottom Tips Card ──────────────────────────────────────────
          const RumusTipsCard(
            tipText:
                'Hafal perkalian 1–10 dengan cara bernyanyi atau "jarimatika"! '
                'Trik angka 9: hasil perkalian berurutan turun (9, 18, 27, 36...) '
                'dan jumlah digit angkanya selalu 9! 🌟',
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
      border: TableBorder.all(
        color: AppColors.tipBoxBorder,
        borderRadius: BorderRadius.circular(6),
      ),
      defaultColumnWidth: const FlexColumnWidth(),
      children: [
        // Header row
        TableRow(
          decoration: const BoxDecoration(color: AppColors.rumusMulColor),
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
                        color: AppColors.rumusMulColor,
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
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
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
