// lib/screens/rumus/detail/umum1/pecahan_screen.dart
//
// Detail page: Pecahan (Fractions) — Rumus Umum 1 tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PecahanScreen extends StatelessWidget {
  const PecahanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: '½',
            title: 'Pecahan',
            definition:
                'Bilangan yang menyatakan bagian dari keseluruhan. '
                'Ditulis sebagai a/b, di mana a = pembilang dan b = penyebut (b ≠ 0).',
          ),

          // ── Jenis Pecahan ────────────────────────────────────────────
          const SectionTitle('📋 Jenis-Jenis Pecahan'),
          const SifatItem(
            number: 1,
            title: 'Pecahan Biasa',
            description: 'Pembilang lebih kecil dari penyebut.',
            example: '¾,  ²⁄₅,  ⁷⁄₁₀',
          ),
          const SifatItem(
            number: 2,
            title: 'Pecahan Campuran',
            description: 'Gabungan bilangan bulat dan pecahan biasa.',
            example: '2½  =  2 + ½',
          ),
          const SifatItem(
            number: 3,
            title: 'Pecahan Senilai',
            description:
                'Pecahan yang berbeda bentuk tetapi memiliki nilai sama.',
            example: '½ = 2/4 = 3/6 = 4/8',
          ),
          const SifatItem(
            number: 4,
            title: 'Pecahan Desimal',
            description: 'Pecahan dengan penyebut 10, 100, 1000, …',
            example: '0,5 = ½;   0,25 = ¼;   0,75 = ¾',
          ),

          // ── Operasi ──────────────────────────────────────────────────
          const SectionTitle('🔢 Operasi Pecahan'),
          ContohBox(
            title: 'Penjumlahan & Pengurangan',
            content: const _FractionOpTable(),
          ),
          ContohBox(
            title: 'Perkalian & Pembagian',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FormulaRow('a/b × c/d', '= (a×c) / (b×d)',
                    example: '½ × ¾ = 3/8'),
                const Divider(height: 16),
                _FormulaRow('a/b ÷ c/d', '= a/b × d/c  (balik!)',
                    example: '½ ÷ ¼ = ½ × 4 = 2'),
              ],
            ),
          ),

          // ── Menyederhanakan ──────────────────────────────────────────
          const SectionTitle('📐 Rumus & Cara'),
          const FormulaCard(
            label: 'MENYEDERHANAKAN',
            formula: 'a/b → bagi pembilang & penyebut dengan FPB-nya',
          ),
          const FormulaCard(
            label: 'PENJUMLAHAN (penyebut sama)',
            formula: 'a/c + b/c = (a+b)/c',
          ),
          const FormulaCard(
            label: 'PENJUMLAHAN (penyebut beda)',
            formula: 'a/b + c/d = (ad + bc) / bd',
          ),
          const FormulaCard(
            label: 'PERKALIAN',
            formula: 'a/b × c/d = ac / bd',
          ),
          const FormulaCard(
            label: 'PEMBAGIAN',
            formula: 'a/b ÷ c/d = a/b × d/c',
          ),

          const TipsBox(
            text: 'Untuk menjumlahkan pecahan beda penyebut:\n'
                '1. Samakan penyebut (cari KPK)\n'
                '2. Jumlahkan pembilangnya\n'
                '3. Sederhanakan hasilnya!\n\n'
                'Contoh: ⅓ + ¼ = 4/12 + 3/12 = 7/12 🎉',
          ),
        ],
      ),
    );
  }
}

class _FractionOpTable extends StatelessWidget {
  const _FractionOpTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormulaRow('Penyebut SAMA',  'a/c + b/c = (a+b)/c',
            example: '1/5 + 2/5 = 3/5'),
        const Divider(height: 14),
        _FormulaRow('Penyebut BEDA', 'Samakan penyebut dulu (KPK)',
            example: '1/3 + 1/4 = 4/12 + 3/12 = 7/12'),
      ],
    );
  }
}

class _FormulaRow extends StatelessWidget {
  const _FormulaRow(this.label, this.formula, {this.example});
  final String label;
  final String formula;
  final String? example;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: kRumusTextMuted,
                fontStyle: FontStyle.italic)),
        const SizedBox(height: 2),
        Text(formula,
            style: const TextStyle(
                fontFamily: 'Fredoka One',
                fontSize: 14,
                color: kRumusTextDark)),
        if (example != null)
          Text('→ $example',
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600)),
      ],
    );
  }
}
