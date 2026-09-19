// lib/screens/rumus/detail/anak/pembagian_screen.dart

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PembagianScreen extends StatelessWidget {
  const PembagianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Topic Header (Title & Subtitle) ───────────────────────────
          RumusTopicHeader(
            title: 'Pembagian',
            subtitle:
                'Membagi suatu bilangan menjadi beberapa bagian yang sama besar.',
          ),

          // ── Sifat Section ──────────────────────────────────────────────
          SectionTitle('Sifat:'),
          NumberedPropertyItem(
            number: 1,
            title: 'Tidak Bisa Ditukar (Tidak Komutatif)',
            description: 'Urutan angka dalam pembagian sangat penting.',
            example: '12 ÷ 4 = 3, tapi 4 ÷ 12 ≠ 3',
          ),
          NumberedPropertyItem(
            number: 2,
            title: 'Tidak Bisa Dikelompokkan (Tidak Asosiatif)',
            description: 'Pengelompokan kurung mempengaruhi hasil.',
            example: '(24 ÷ 6) ÷ 2 = 2 ≠ 24 ÷ (6 ÷ 2) = 8',
          ),
          NumberedPropertyItem(
            number: 3,
            title: 'Dibagi Satu',
            description:
                'Membagi bilangan dengan 1 menghasilkan bilangan itu sendiri.',
            example: 'a ÷ 1 = a  →  15 ÷ 1 = 15',
          ),
          NumberedPropertyItem(
            number: 4,
            title: 'Dibagi Diri Sendiri',
            description:
                'Pembagian bilangan dengan dirinya sendiri selalu menghasilkan 1.',
            example: 'a ÷ a = 1  →  7 ÷ 7 = 1',
          ),
          NumberedPropertyItem(
            number: 5,
            title: 'Tidak Boleh Bagi Nol',
            description:
                'Membagi bilangan apa pun dengan 0 tidak terdefinisi!',
            example: '5 ÷ 0 = ❌ Tidak terdefinisi',
          ),
          NumberedPropertyItem(
            number: 6,
            title: 'Kebalikan Perkalian',
            description: 'Pembagian adalah operasi invers dari perkalian.',
            example: 'Jika 6 × 4 = 24, maka 24 ÷ 4 = 6',
          ),

          // ── Math Calculation Section (Porogapit) ──────────────────────
          SectionTitle('Contoh Perhitungan Porogapit:'),
          DivisionStepWidget(
            dividend: '84',
            divisor: '4',
            quotient: '21',
            steps: [
              'Bagi angka puluhan pertama: 8 ÷ 4 = 2 (tulis 2 di atas)',
              'Bagi angka satuan berikutnya: 4 ÷ 4 = 1 (tulis 1 di atas)',
              'Hasil akhir porogapit: 84 ÷ 4 = 21 ✅',
            ],
          ),
          SizedBox(height: 16),

          // ── Formula Cards ─────────────────────────────────────────────
          FormulaCard(
            label: 'RUMUS PEMBAGIAN',
            formula: 'a ÷ b = Hasil Bagi   (b ≠ 0)',
          ),
          FormulaCard(
            label: 'HUBUNGAN DENGAN PERKALIAN',
            formula: 'a ÷ b = c  ↔  b × c = a',
          ),

          // ── Bottom Tips Card ──────────────────────────────────────────
          RumusTipsCard(
            tipText:
                'Gunakan tabel perkalian untuk membantu pembagian!\n'
                'Contoh: 36 ÷ 6 = ? → cari: 6 × ? = 36 → jawabannya 6 💡\n'
                'Jika ada sisa, tuliskan sebagai: Hasil + sisa/pembagi.',
          ),
        ],
      ),
    );
  }
}
