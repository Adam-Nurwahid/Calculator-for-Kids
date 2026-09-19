// lib/screens/rumus/detail/anak/pengurangan_screen.dart

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PenguranganScreen extends StatelessWidget {
  const PenguranganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Topic Header (Title & Subtitle) ───────────────────────────
          RumusTopicHeader(
            title: 'Pengurangan',
            subtitle:
                'Mencari selisih atau mengambil sebagian nilai dari suatu kelompok.',
          ),

          // ── Sifat Section ──────────────────────────────────────────────
          SectionTitle('Sifat:'),
          NumberedPropertyItem(
            number: 1,
            title: 'Tidak Bisa Ditukar (Tidak Komutatif)',
            description:
                'Urutan angka dalam pengurangan sangat penting dan tidak boleh dibalik.',
            example: '8 − 3 = 5, tapi 3 − 8 ≠ 5',
          ),
          NumberedPropertyItem(
            number: 2,
            title: 'Tidak Bisa Dikelompokkan (Tidak Asosiatif)',
            description:
                'Perubahan pengelompokan kurung akan mengubah hasil akhir.',
            example: '(10 − 4) − 2 = 4 ≠ 10 − (4 − 2) = 8',
          ),
          NumberedPropertyItem(
            number: 3,
            title: 'Dikurangi Nol (Unsur Identitas)',
            description:
                'Mengurangi bilangan berapa pun dengan 0 menghasilkan bilangan itu sendiri.',
            example: 'a − 0 = a  →  9 − 0 = 9',
          ),
          NumberedPropertyItem(
            number: 4,
            title: 'Kebalikan Penjumlahan (Invers)',
            description:
                'Pengurangan adalah operasi kebalikan langsung dari penjumlahan.',
            example: 'Jika 5 + 3 = 8, maka 8 − 3 = 5',
          ),

          // ── Math Calculation Section ──────────────────────────────────
          SectionTitle('Contoh Perhitungan:'),
          VerticalMathCalculation(
            topNumber: '532',
            bottomNumber: '274',
            operator: '−',
            resultNumber: '258',
            note:
                'Kurangi dari kolom satuan. Jika angka atas lebih kecil, pinjam 1 puluhan (10) dari sebelahnya.',
          ),
          SizedBox(height: 16),

          // ── Formula Card ──────────────────────────────────────────────
          FormulaCard(
            label: 'RUMUS PENGURANGAN',
            formula: 'a − b = Selisih',
          ),

          // ── Bottom Tips Card ──────────────────────────────────────────
          RumusTipsCard(
            tipText:
                'Saat meminjam angka, ingat bahwa 1 puluhan sama dengan 10 satuan! '
                'Contoh: 42 − 17 → (12 − 7 = 5), lalu sisa (3 − 1 = 2) → hasilnya 25 😊',
          ),
        ],
      ),
    );
  }
}
