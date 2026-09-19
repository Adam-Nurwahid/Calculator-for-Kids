// lib/screens/rumus/detail/anak/penjumlahan_screen.dart

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class PenjumlahanScreen extends StatelessWidget {
  const PenjumlahanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Topic Header (Title & Subtitle) ───────────────────────────
          RumusTopicHeader(
            title: 'Penjumlahan',
            subtitle: 'Menggabungkan nilai dari dua kelompok atau lebih.',
          ),

          // ── Sifat Section ──────────────────────────────────────────────
          SectionTitle('Sifat:'),
          NumberedPropertyItem(
            number: 1,
            title: 'Bisa Ditukar (Komutatif)',
            description: 'Urutan penjumlahan tidak mengubah hasil akhirnya.',
            example: 'a + b = b + a  →  3 + 5 = 5 + 3 = 8',
          ),
          NumberedPropertyItem(
            number: 2,
            title: 'Bisa Dikelompokkan (Asosiatif)',
            description: 'Cara pengelompokan angka tidak mengubah hasil akhir.',
            example: '(a + b) + c = a + (b + c)  →  (2 + 3) + 4 = 2 + (3 + 4) = 9',
          ),
          NumberedPropertyItem(
            number: 3,
            title: 'Ditambah Nol (Unsur Identitas)',
            description:
                'Menjumlahkan bilangan berapa pun dengan 0 menghasilkan bilangan itu sendiri.',
            example: 'a + 0 = a  →  7 + 0 = 7',
          ),
          NumberedPropertyItem(
            number: 4,
            title: 'Hasil Selalu Bilangan Bulat (Tertutup)',
            description:
                'Hasil penjumlahan dua bilangan bulat pasti bilangan bulat juga.',
            example: '4 + 6 = 10  ✅',
          ),

          // ── Math Calculation Section ──────────────────────────────────
          SectionTitle('Contoh Perhitungan:'),
          VerticalMathCalculation(
            topNumber: '114',
            bottomNumber: '76',
            operator: '+',
            resultNumber: '190',
            note: 'Jumlahkan dari kolom satuan (kanan) ke puluhan dan ratusan (kiri).',
          ),
          SizedBox(height: 16),

          // ── Formula Card ──────────────────────────────────────────────
          FormulaCard(
            label: 'RUMUS PENJUMLAHAN',
            formula: 'a + b = Jumlah Total',
          ),

          // ── Bottom Tips Card ──────────────────────────────────────────
          RumusTipsCard(
            tipText:
                'Kamu bisa menghitung dari angka puluhan dulu, lalu tambahkan satuannya '
                'agar lebih cepat dan mudah! Contoh: 48 + 37 → (48 + 2) + 35 = 50 + 35 = 85 🎉',
          ),
        ],
      ),
    );
  }
}
