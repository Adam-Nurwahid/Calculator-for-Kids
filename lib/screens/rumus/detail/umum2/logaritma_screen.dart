// lib/screens/rumus/detail/umum2/logaritma_screen.dart
//
// Detail page: Logaritma (Logarithms) — Rumus Umum 2 tier.

import 'package:flutter/material.dart';
import '../../../../widgets/rumus_widgets.dart';

class LogaritmaScreen extends StatelessWidget {
  const LogaritmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RumusScaffold(
      tierLabel: 'Matematika Tingkat Umum 2',
      topicTitle: 'Logaritma',
      mascotEmoji: '🦅',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RumusTopicDefinition(
            emoji: 'log',
            title: 'Logaritma',
            definition:
                'Kebalikan dari perpangkatan. "Logaritma a dari b" artinya '
                '"pangkat berapa yang membuat a menjadi b?"',
          ),

          // ── Sifat ────────────────────────────────────────────────────
          const SectionTitle('📋 Sifat-Sifat Logaritma'),
          const SifatItem(
            number: 1,
            title: 'Definisi',
            description: 'log_a(b) = c  berarti  aᶜ = b',
            example: 'log₂(8) = 3  karena  2³ = 8',
          ),
          const SifatItem(
            number: 2,
            title: 'Perkalian',
            description: 'Jumlahkan logaritma.',
            example: 'log_a(m × n) = log_a(m) + log_a(n)\nlog₂(4 × 8) = log₂(4) + log₂(8) = 2 + 3 = 5',
          ),
          const SifatItem(
            number: 3,
            title: 'Pembagian',
            description: 'Kurangkan logaritma.',
            example: 'log_a(m / n) = log_a(m) − log_a(n)\nlog₁₀(100/10) = 2 − 1 = 1',
          ),
          const SifatItem(
            number: 4,
            title: 'Pangkat',
            description: 'Pangkat turun menjadi pengali.',
            example: 'log_a(mⁿ) = n × log_a(m)\nlog₁₀(100) = 2 × log₁₀(10) = 2',
          ),
          const SifatItem(
            number: 5,
            title: 'Logaritma Basis Diri Sendiri',
            description: 'Selalu = 1.',
            example: 'log_a(a) = 1\nlog₁₀(10) = 1',
          ),
          const SifatItem(
            number: 6,
            title: 'Logaritma dari 1',
            description: 'Selalu = 0 (karena a⁰ = 1).',
            example: 'log_a(1) = 0\nlog₅(1) = 0',
          ),
          const SifatItem(
            number: 7,
            title: 'Pergantian Basis (Change of Base)',
            description: 'Ubah ke basis 10 atau e.',
            example: 'log_a(b) = log(b) / log(a)\nlog₂(32) = log(32)/log(2) = 5',
          ),

          // ── Logaritma Khusus ─────────────────────────────────────────
          ContohBox(
            title: 'Jenis Logaritma Khusus',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _LogTypeRow('log₁₀(x)', 'Logaritma Biasa (basis 10)',
                    'Ditulis: log(x)'),
                Divider(height: 14),
                _LogTypeRow('logₑ(x)', 'Logaritma Natural (basis e ≈ 2,718)',
                    'Ditulis: ln(x)'),
                Divider(height: 14),
                _LogTypeRow('log₂(x)', 'Logaritma Biner (basis 2)',
                    'Digunakan di ilmu komputer'),
              ],
            ),
          ),

          // ── Contoh ───────────────────────────────────────────────────
          ContohBox(
            title: 'Contoh Perhitungan',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _LogExample(expr: 'log₂(64)', answer: '= 6   (2⁶ = 64)'),
                SizedBox(height: 6),
                _LogExample(expr: 'log₁₀(1000)', answer: '= 3   (10³ = 1000)'),
                SizedBox(height: 6),
                _LogExample(
                    expr: 'log₃(27) + log₃(3)',
                    answer: '= 3 + 1 = 4'),
              ],
            ),
          ),

          // ── Rumus ────────────────────────────────────────────────────
          const SectionTitle('📐 Rumus Logaritma'),
          const FormulaCard(label: 'DEFINISI', formula: 'logₐ(b) = c  ⟺  aᶜ = b'),
          const FormulaCard(label: 'PERKALIAN', formula: 'logₐ(mn) = logₐm + logₐn'),
          const FormulaCard(label: 'PEMBAGIAN', formula: 'logₐ(m/n) = logₐm − logₐn'),
          const FormulaCard(label: 'PANGKAT', formula: 'logₐ(mⁿ) = n × logₐm'),
          const FormulaCard(label: 'CHANGE OF BASE', formula: 'logₐb = log(b) / log(a)'),

          const TipsBox(
            text: 'Cara mudah:\n'
                '"log_a(b) = c" artinya → aᶜ = b\n\n'
                'Contoh: log₂(?) = 5 → 2⁵ = ? = 32\n\n'
                'Selalu tanya: "basis dipangkat berapa = hasilnya?"  💡',
          ),
        ],
      ),
    );
  }
}

class _LogTypeRow extends StatelessWidget {
  const _LogTypeRow(this.notation, this.name, this.note);
  final String notation;
  final String name;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(notation,
            style: const TextStyle(
                fontFamily: 'Fredoka One',
                fontSize: 15,
                color: kRumusOrange)),
        Text(name,
            style: const TextStyle(fontSize: 13, color: kRumusTextDark)),
        Text(note,
            style: const TextStyle(
                fontSize: 11,
                color: kRumusTextMuted,
                fontStyle: FontStyle.italic)),
      ],
    );
  }
}

class _LogExample extends StatelessWidget {
  const _LogExample({required this.expr, required this.answer});
  final String expr;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontFamily: 'Fredoka One', fontSize: 14, color: kRumusTextDark),
        children: [
          TextSpan(
              text: expr,
              style: const TextStyle(
                  color: kRumusOrange, fontWeight: FontWeight.bold)),
          TextSpan(text: '  $answer',
              style: const TextStyle(color: Color(0xFF2E7D32))),
        ],
      ),
    );
  }
}
