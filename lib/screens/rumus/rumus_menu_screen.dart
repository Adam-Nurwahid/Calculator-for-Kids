// lib/screens/rumus/rumus_menu_screen.dart

import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

// ─── Data Model ──────────────────────────────────────────────────────────────

class _TierData {
  const _TierData({
    required this.label,
    required this.items,
  });

  final String label;
  final List<_MateriItem> items;
}

class _MateriItem {
  const _MateriItem({required this.label, required this.route});
  final String label;
  final String route;
}

// ─── 3 Halaman Tier Data ─────────────────────────────────────────────────────

const List<_TierData> _tiers = [
  // Halaman 1: Operasi Dasar (6 item)
  _TierData(
    label: 'Operasi Dasar',
    items: [
      _MateriItem(label: 'Penjumlahan', route: '/rumus/anak/penjumlahan'),
      _MateriItem(label: 'Pengurangan', route: '/rumus/anak/pengurangan'),
      _MateriItem(label: 'Perkalian', route: '/rumus/anak/perkalian'),
      _MateriItem(label: 'Pembagian', route: '/rumus/anak/pembagian'),
      _MateriItem(label: 'Tanda Kurung', route: '/rumus/anak/tanda-kurung'),
      _MateriItem(label: 'Aljabar', route: '/rumus/anak/aljabar'),
    ],
  ),

  // Halaman 2: Geometri & Matematika Menengah (6 item)
  _TierData(
    label: 'Geometri & Matematika Menengah',
    items: [
      _MateriItem(label: 'Bangun Datar', route: '/rumus/geometri/bangun-datar'),
      _MateriItem(label: 'Bangun Ruang', route: '/rumus/geometri/bangun-ruang'),
      _MateriItem(label: 'Pecahan', route: '/rumus/geometri/pecahan'),
      _MateriItem(label: 'Pangkat', route: '/rumus/geometri/pangkat'),
      _MateriItem(label: 'Konversi Persen', route: '/rumus/geometri/konversi-persen'),
      _MateriItem(label: 'Akar Kuadrat', route: '/rumus/geometri/akar-kuadrat'),
    ],
  ),

  // Halaman 3: Matematika Tingkat Lanjut (6 item)
  _TierData(
    label: 'Matematika Tingkat Lanjut',
    items: [
      _MateriItem(label: 'Trigonometri', route: '/rumus/umum1/trigonometri'),
      _MateriItem(label: 'Deg/Rad', route: '/rumus/umum1/deg-rad'),
      _MateriItem(label: 'Logaritma', route: '/rumus/umum1/logaritma'),
      _MateriItem(label: 'Peluang', route: '/rumus/umum1/peluang'),
      _MateriItem(label: 'Statistika', route: '/rumus/umum1/statistika'),
      _MateriItem(label: 'Barisan & Deret', route: '/rumus/umum1/barisan-deret'),
    ],
  ),
];

// ─── Screen Utama ────────────────────────────────────────────────────────────

class RumusMenuScreen extends StatefulWidget {
  const RumusMenuScreen({super.key});

  @override
  State<RumusMenuScreen> createState() => _RumusMenuScreenState();
}

class _RumusMenuScreenState extends State<RumusMenuScreen> {
  late final PageController _pageCtrl;
  int _currentPage = 0;

  // Path aset maskot kucing
  final String _mascotAsset = 'assets/membaca_buku_belajar_2.png';

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
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgCream = Color(0xFFFBF4E4);
    const Color cardOrange = Color(0xFFFF941A);
    const Color arrowColor = Color(0xFFD65C00);

    final isLandscape = context.isLandscape;
    final screenWidth = context.screenWidth;
    final maxContainerWidth = Responsive.maxContainerWidth(screenWidth).clamp(0.0, 540.0);

    return Scaffold(
      backgroundColor: bgCream,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContainerWidth),
          child: Stack(
            children: [
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    SizedBox(height: isLandscape ? 8 : 14),

                    // 1. Maskot Kucing (Adaptive height)
                    SizedBox(
                      height: isLandscape ? 85 : 125,
                      child: Image.asset(
                        _mascotAsset,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // 2. Kontainer Oranye Utama
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: cardOrange,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36),
                            topRight: Radius.circular(36),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(20, isLandscape ? 16 : 24, 20, 14),
                        child: Column(
                          children: [
                            // Judul (Statis)
                            Text(
                              'Pilih Materi\nPembelajaranmu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Fredoka One',
                                fontSize: isLandscape ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.25,
                              ),
                            ),
                            SizedBox(height: isLandscape ? 10 : 16),

                            // 3. PageView HANYA untuk Pilihan Menu
                            Expanded(
                              child: PageView.builder(
                                controller: _pageCtrl,
                                onPageChanged: (index) {
                                  setState(() => _currentPage = index);
                                },
                                itemCount: _tiers.length,
                                itemBuilder: (context, pageIndex) {
                                  final tier = _tiers[pageIndex];
                                  return ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: tier.items.length,
                                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                                    itemBuilder: (ctx, itemIndex) {
                                      final item = tier.items[itemIndex];
                                      return _MaterialButton(
                                        label: item.label,
                                        onTap: () => Navigator.pushNamed(ctx, item.route),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 4. Bagian Bawah: Indikator 3 Dots + Panah Navigasi Aktif
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // 3 Dots di tengah
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(_tiers.length, (index) {
                                    final isActive = index == _currentPage;
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? arrowColor
                                            : arrowColor.withValues(alpha: 0.35),
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }),
                                ),

                                // Panah Kiri dan Kanan yang Berfungsi
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(
                                          Icons.arrow_left_rounded,
                                          size: 38,
                                          color: _currentPage > 0
                                              ? arrowColor
                                              : arrowColor.withValues(alpha: 0.25),
                                        ),
                                        onPressed: _currentPage > 0
                                            ? () => _goTo(_currentPage - 1)
                                            : null,
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(
                                          Icons.arrow_right_rounded,
                                          size: 38,
                                          color: _currentPage < _tiers.length - 1
                                              ? arrowColor
                                              : arrowColor.withValues(alpha: 0.25),
                                        ),
                                        onPressed: _currentPage < _tiers.length - 1
                                            ? () => _goTo(_currentPage + 1)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Footer Text
                            const Text(
                              'Materi bisa diubah kapan pun',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5A3E22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Tombol Back (Kiri Atas) ──────────────────────────────────────
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF333333),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tombol Pill Materi (with Mouse Hover Support) ─────────────────────────────

class _MaterialButton extends StatefulWidget {
  const _MaterialButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_MaterialButton> createState() => _MaterialButtonState();
}

class _MaterialButtonState extends State<_MaterialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white : const Color(0xFFFFF9E8),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.16 : 0.10),
              blurRadius: _isHovered ? 8 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_right_rounded,
                    color: Colors.black,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}