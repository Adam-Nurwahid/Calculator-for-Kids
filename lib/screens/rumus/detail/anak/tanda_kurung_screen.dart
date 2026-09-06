// lib/screens/rumus/detail/anak/tanda_kurung_screen.dart
//
// Detail page: Tanda Kurung (Brackets / Order of Operations) — Rumus Anak tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class TandaKurungScreen extends StatelessWidget {
  const TandaKurungScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Dasar',
      topicTitle: 'Tanda Kurung',
      mascotEmoji: '🔢',
      // No OperatorTabRow — this is a special topic, not a basic operator
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Definisi ──────────────────────────────────────────────────
          const RumusTopicDefinition(
            emoji: '🔢',
            title: 'Tanda Kurung & Urutan Operasi',
            definition:
                'Aturan yang menentukan bagian mana dari suatu ekspresi yang '
                'dihitung lebih dulu agar hasilnya benar.',
          ),

          // ── Aturan KBKP ──────────────────────────────────────────────
          const SectionTitle('📋 Aturan KBKP (Kurung → Bagi → Kali → Plus/Minus)'),
          const SifatItem(
            number: 1,
            title: 'Kurung ( ) dikerjakan PERTAMA',
            description: 'Apapun yang ada di dalam tanda kurung harus diselesaikan dulu.',
            example: '(3 + 4) × 2 → 7 × 2 = 14',
          ),
          const SifatItem(
            number: 2,
            title: 'Perkalian & Pembagian BERIKUTNYA',
            description: 'Dikerjakan dari kiri ke kanan setelah kurung selesai.',
            example: '3 + 4 × 2 → 3 + 8 = 11  (bukan 14!)',
          ),
          const SifatItem(
            number: 3,
            title: 'Penjumlahan & Pengurangan TERAKHIR',
            description: 'Dikerjakan dari kiri ke kanan setelah × dan ÷.',
            example: '10 − 2 + 3 = 8 + 3 = 11',
          ),

          // ── Contoh Bertingkat ────────────────────────────────────────
          ContohBox(
            title: 'Contoh Bertingkat',
            content: const _StepExample(),
          ),

          // ── Perbandingan ─────────────────────────────────────────────
          ContohBox(
            title: 'Pengaruh Kurung',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CompareRow(
                  expr: '2 + 3 × 4',
                  result: '= 2 + 12 = 14',
                  note: '(tanpa kurung → kali dulu)',
                ),
                const Divider(height: 16),
                _CompareRow(
                  expr: '(2 + 3) × 4',
                  result: '= 5 × 4 = 20',
                  note: '(dengan kurung → kurung dulu)',
                ),
              ],
            ),
          ),

          // ── Rumus / Ingatan ──────────────────────────────────────────
          const SectionTitle('📐 Ingat Selalu!'),
          const FormulaCard(
            label: 'URUTAN OPERASI',
            formula: '( )  →  × ÷  →  + −',
          ),

          // ── Tips ─────────────────────────────────────────────────────
          const TipsBox(
            text: 'Ingat singkatan KBKP:\n'
                '🟠 K = Kurung\n'
                '🟡 B = Bagi\n'
                '🟢 K = Kali\n'
                '🔵 P = Plus & Minus\n\n'
                'Kerjakanlah dari warna paling atas ke bawah!',
          ),
        ],
      ),
    );
  }
}

class _StepExample extends StatelessWidget {
  const _StepExample();

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Ekspresi asli:', '(5 + 3) × 2 − 4 ÷ 2'),
      ('Langkah 1 — Kurung:', '8 × 2 − 4 ÷ 2'),
      ('Langkah 2 — × dan ÷:', '16 − 2'),
      ('Langkah 3 — −:', '14'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.map((s) {
        final isLast = s == steps.last;
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  s.$1,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kRumusTextMuted,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  s.$2,
                  style: TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: isLast ? 18 : 14,
                    color: isLast ? const Color(0xFF2E7D32) : kRumusTextDark,
                    fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({
    required this.expr,
    required this.result,
    required this.note,
  });
  final String expr;
  final String result;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          expr,
          style: const TextStyle(
            fontFamily: 'Fredoka One',
            fontSize: 16,
            color: kRumusTextDark,
          ),
        ),
        Text(
          result,
          style: const TextStyle(
            fontFamily: 'Fredoka One',
            fontSize: 16,
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          note,
          style: const TextStyle(
            fontSize: 11,
            color: kRumusTextMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
