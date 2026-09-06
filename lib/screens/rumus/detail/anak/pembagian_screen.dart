// lib/screens/rumus/detail/anak/pembagian_screen.dart
//
// Detail page: Pembagian (Division) — Rumus Anak tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PembagianScreen extends StatelessWidget {
  const PembagianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Dasar',
      topicTitle: 'Pembagian',
      mascotEmoji: '➗',
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
            emoji: '➗',
            title: 'Pembagian',
            definition:
                'Membagi suatu bilangan menjadi beberapa bagian yang sama besar. '
                'Kebalikan (invers) dari perkalian.',
          ),

          // ── Sifat ────────────────────────────────────────────────────
          const SectionTitle('📋 Sifat Pembagian'),
          const SifatItem(
            number: 1,
            title: 'Tidak Komutatif',
            description: 'Urutan PENTING — tidak bisa dibalik.',
            example: '12 ÷ 4 = 3, tapi 4 ÷ 12 ≠ 3',
          ),
          const SifatItem(
            number: 2,
            title: 'Tidak Asosiatif',
            description: 'Pengelompokan mempengaruhi hasil.',
            example: '(24 ÷ 6) ÷ 2 = 2 ≠ 24 ÷ (6 ÷ 2) = 8',
          ),
          const SifatItem(
            number: 3,
            title: 'Identitas (Satu)',
            description: 'Membagi dengan 1 menghasilkan bilangan itu sendiri.',
            example: '15 ÷ 1 = 15',
          ),
          const SifatItem(
            number: 4,
            title: 'Bilangan Dibagi Dirinya Sendiri = 1',
            description: 'Pembagian suatu bilangan dengan dirinya = 1.',
            example: '7 ÷ 7 = 1',
          ),
          const SifatItem(
            number: 5,
            title: 'Tidak Bisa Bagi Nol',
            description: 'Membagi bilangan apapun dengan 0 tidak terdefinisi!',
            example: '5 ÷ 0 = ❌ Tidak boleh!',
          ),
          const SifatItem(
            number: 6,
            title: 'Hubungan dengan Perkalian',
            description: 'Pembagian adalah kebalikan perkalian.',
            example: 'Jika 6 × 4 = 24, maka 24 ÷ 4 = 6',
          ),

          // ── Contoh ───────────────────────────────────────────────────
          ContohBox(
            title: 'Contoh Pembagian Panjang',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '84 ÷ 4 = ?',
                  style: TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 18,
                    color: kRumusTextDark,
                  ),
                ),
                const SizedBox(height: 8),
                _DivisionStep(step: 1, text: '8 ÷ 4 = 2  (puluhan)'),
                _DivisionStep(step: 2, text: '4 ÷ 4 = 1  (satuan)'),
                const SizedBox(height: 4),
                const Text(
                  '84 ÷ 4 = 21 ✅',
                  style: TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 18,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus'),
          const FormulaCard(
            label: 'PEMBAGIAN',
            formula: 'a ÷ b = hasil bagi   (b ≠ 0)',
          ),
          const FormulaCard(
            label: 'HUBUNGAN DENGAN PERKALIAN',
            formula: 'a ÷ b = c  ↔  b × c = a',
          ),

          // ── Tips ─────────────────────────────────────────────────────
          const TipsBox(
            text: 'Gunakan tabel perkalian untuk membantu pembagian!\n'
                'Contoh: 36 ÷ 6 = ? → cari: 6 × ? = 36 → jawabannya 6  💡\n'
                'Jika ada sisa, tuliskan sebagai: hasil + sisa/pembagi.',
          ),
        ],
      ),
    );
  }
}

class _DivisionStep extends StatelessWidget {
  const _DivisionStep({required this.step, required this.text});
  final int step;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: kRumusOrange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Fredoka One',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: kRumusTextDark,
            ),
          ),
        ],
      ),
    );
  }
}
