// lib/screens/rumus/detail/anak/tanda_kurung_screen.dart

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class TandaKurungScreen extends StatelessWidget {
  const TandaKurungScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Topic Header (Title & Subtitle) ───────────────────────────
          RumusTopicHeader(
            title: 'Tanda Kurung',
            subtitle:
                'Aturan urutan pengerjaan operasi matematika agar menghasilkan jawaban yang benar.',
          ),

          // ── Sifat / Rules Section ──────────────────────────────────────
          SectionTitle('Aturan Prioritas Utama (KBKP):'),
          NumberedPropertyItem(
            number: 1,
            title: 'Prioritas Utama — Kurung ( )',
            description:
                'Angka dan operasi di dalam tanda kurung WAJIB dihitung paling awal.',
            example: '2 × (10 − 4) = 2 × 6 = 12',
          ),
          NumberedPropertyItem(
            number: 2,
            title: 'Prioritas Kedua — Perkalian (×) & Pembagian (÷)',
            description:
                'Dikerjakan berurutan dari kiri ke kanan setelah tanda kurung selesai.',
            example: '3 + 4 × 2 → 3 + 8 = 11  (Bukan 14!)',
          ),
          NumberedPropertyItem(
            number: 3,
            title: 'Prioritas Ketiga — Penjumlahan (+) & Pengurangan (−)',
            description:
                'Dikerjakan paling akhir berurutan dari kiri ke kanan.',
            example: '10 − 2 + 3 = 8 + 3 = 11',
          ),

          // ── Math Calculation Section (Bracket Steps) ──────────────────
          SectionTitle('Contoh Evaluasi Bertingkat:'),
          BracketStepWidget(
            expression: '2 × [ 10 − ( 3 + 1 ) ]',
            steps: [
              'Hitung dalam kurung terdalam: (3 + 1) = 4',
              'Substitusi hasil: 2 × (10 − 4)',
              'Hitung dalam kurung berikutnya: (10 − 4) = 6',
              'Kalikan dengan angka depan: 2 × 6',
              '= 12 ✅',
            ],
          ),
          SizedBox(height: 16),

          // ── Formula Card ──────────────────────────────────────────────
          FormulaCard(
            label: 'URUTAN PRIORITAS OPERASI',
            formula: '( )  →  × ÷  →  + −',
          ),

          // ── Bottom Tips Card ──────────────────────────────────────────
          RumusTipsCard(
            tipText:
                'Ingat jembatan keledai KBKP:\n'
                '🟠 K = Kurung\n'
                '🟡 B = Bagi\n'
                '🟢 K = Kali\n'
                '🔵 P = Plus & Minus\n\n'
                'Kerjakan selalu dari tingkatan atas ke bawah! 🧠',
          ),
        ],
      ),
    );
  }
}
