// lib/screens/rumus/rumus_menu_screen.dart
//
// 3-tier material-selection menu for the Rumus (formula learning) feature.
//
// Layout per page:
//  • Orange rounded card filling the screen
//  • Mascot emoji + tier title at top
//  • "Pilih Materi Pembelajaranmu" heading
//  • Vertical list of MateriPillButton items
//  • Pagination dots (3 dots)
//  • Left/right arrow nav
//  • Footer note

import 'package:flutter/material.dart';
import '../../widgets/rumus_widgets.dart';

// ─── Data model ──────────────────────────────────────────────────────────────

class _TierData {
  const _TierData({
    required this.label,
    required this.mascot,
    required this.items,
  });
  final String label;
  final String mascot;
  final List<_MateriItem> items;
}

class _MateriItem {
  const _MateriItem({required this.emoji, required this.label, required this.route});
  final String emoji;
  final String label;
  final String route;
}

const _tiers = [
  _TierData(
    label: 'Rumus (Anak)',
    mascot: '🐣',
    items: [
      _MateriItem(emoji: '➕', label: 'Penjumlahan',  route: '/rumus/anak/penjumlahan'),
      _MateriItem(emoji: '➖', label: 'Pengurangan',  route: '/rumus/anak/pengurangan'),
      _MateriItem(emoji: '✖️', label: 'Perkalian',    route: '/rumus/anak/perkalian'),
      _MateriItem(emoji: '➗', label: 'Pembagian',    route: '/rumus/anak/pembagian'),
      _MateriItem(emoji: '🔢', label: 'Tanda Kurung', route: '/rumus/anak/tanda-kurung'),
      _MateriItem(emoji: '📐', label: 'Bangun Datar', route: '/rumus/anak/bangun-datar'),
    ],
  ),
  _TierData(
    label: 'Rumus (Umum 1)',
    mascot: '🦊',
    items: [
      _MateriItem(emoji: '½',  label: 'Pecahan',         route: '/rumus/umum1/pecahan'),
      _MateriItem(emoji: '²',  label: 'Pangkat',          route: '/rumus/umum1/pangkat'),
      _MateriItem(emoji: '%',  label: 'Konversi Persen',  route: '/rumus/umum1/konversi-persen'),
      _MateriItem(emoji: '🎲', label: 'Peluang',          route: '/rumus/umum1/peluang'),
      _MateriItem(emoji: '🔠', label: 'Aljabar',          route: '/rumus/umum1/aljabar'),
      _MateriItem(emoji: '📊', label: 'Statistika',       route: '/rumus/umum1/statistika'),
    ],
  ),
  _TierData(
    label: 'Rumus (Umum 2)',
    mascot: '🦅',
    items: [
      _MateriItem(emoji: '📦', label: 'Bangun Ruang',     route: '/rumus/umum2/bangun-ruang'),
      _MateriItem(emoji: '📐', label: 'Trigonometri',     route: '/rumus/umum2/trigonometri'),
      _MateriItem(emoji: 'log', label: 'Logaritma',       route: '/rumus/umum2/logaritma'),
      _MateriItem(emoji: '√',  label: 'Akar Kuadrat',     route: '/rumus/umum2/akar-kuadrat'),
      _MateriItem(emoji: '°',  label: 'Deg / Rad',        route: '/rumus/umum2/deg-rad'),
      _MateriItem(emoji: '🔢', label: 'Barisan & Deret',  route: '/rumus/umum2/barisan-deret'),
    ],
  ),
];

// ─── Screen ──────────────────────────────────────────────────────────────────

class RumusMenuScreen extends StatefulWidget {
  const RumusMenuScreen({super.key});

  @override
  State<RumusMenuScreen> createState() => _RumusMenuScreenState();
}

class _RumusMenuScreenState extends State<RumusMenuScreen> {
  late final PageController _pageCtrl;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    final target = page.clamp(0, _tiers.length - 1);
    _pageCtrl.animateToPage(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kRumusBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Back button row ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: kRumusTextDark, size: 22),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Pilih Materi',
                    style: TextStyle(
                      fontFamily: 'Fredoka One',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: kRumusTextDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Paged card area ─────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (p) => setState(() => _currentPage = p),
                itemCount: _tiers.length,
                itemBuilder: (_, i) => _TierPage(tier: _tiers[i]),
              ),
            ),

            // ── Bottom nav area ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 10, 28, 16),
              child: Column(
                children: [
                  PageDots(current: _currentPage, total: _tiers.length),
                  const SizedBox(height: 14),
                  NavArrows(
                    leftEnabled: _currentPage > 0,
                    rightEnabled: _currentPage < _tiers.length - 1,
                    onLeft: () => _goTo(_currentPage - 1),
                    onRight: () => _goTo(_currentPage + 1),
                    center: Column(
                      children: [
                        Text(
                          _tiers[_currentPage].label,
                          style: const TextStyle(
                            fontFamily: 'Fredoka One',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kRumusTextDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Materi bisa diubah kapan pun',
                    style: TextStyle(
                      fontSize: 12,
                      color: kRumusTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single tier page ────────────────────────────────────────────────────────

class _TierPage extends StatelessWidget {
  const _TierPage({required this.tier});
  final _TierData tier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: kRumusOrange,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: kRumusOrangeDark.withValues(alpha: 0.30),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mascot + tier label
            Row(
              children: [
                Text(tier.mascot,
                    style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tier.label,
                    style: const TextStyle(
                      fontFamily: 'Fredoka One',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Pilih Materi Pembelajaranmu',
              style: TextStyle(
                fontFamily: 'Fredoka One',
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            // Pill buttons list
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tier.items.length,
                itemBuilder: (ctx, i) {
                  final item = tier.items[i];
                  return MateriPillButton(
                    emoji: item.emoji,
                    label: item.label,
                    onTap: () =>
                        Navigator.pushNamed(ctx, item.route),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
