import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/market.dart';
import 'package:plan_market/features/login/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 2;

  final List<Market> favorites = const [
    Market(
      name: 'ร้านอาชียะ',
      subtitle: 'ตลาด : จตุจักร.',
      timeText: '',
      isOpen: true,
      tags: [],
      image: '',
    ),
    Market(
      name: 'ร้านติวการค้า',
      subtitle: 'ตลาด : ปากเกร็ด',
      timeText: '',
      isOpen: true,
      tags: [],
      image: '',
    ),
  ];

  final List<Market> recommended = const [
    Market(
      name: 'ตลาดจตุจักร (โซนกลางคืน)',
      subtitle: 'ระยะทาง : อนุจักร 1.2กม.',
      timeText: 'วันนี้ 17.00-23.00 น.',
      isOpen: true,
      tags: ['อาหาร', 'แฟชั่น', 'มือสอง'],
      image: '',
    ),
    Market(
      name: 'ตลาดนัดรถไฟ',
      subtitle: 'ระยะทาง : รามอินทรา 4.2กม.',
      timeText: 'วันนี้ 18.00-23.00 น.',
      isOpen: true,
      tags: ['อาหาร', 'แฟชั่น', 'มือสอง'],
      image: '',
    ),
    Market(
      name: 'ตลาดเซฟวันโก',
      subtitle: 'ระยะทาง : สวนหลวง 7.2กม.',
      timeText: 'วันนี้ 17.00-23.00 น.',
      isOpen: false,
      tags: ['อาหาร', 'แฟชั่น', 'มือสอง'],
      image: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionTitle(
                  title: 'ร้านที่ถูกใจ',
                  subtitle: 'Favorite',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: favorites.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _FavoriteCard(market: favorites[i]),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(
                      title: 'ตลาดแนะนำ',
                      subtitle: 'Recommended markets',
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'ใกล้ฉัน  Nearest',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverList.separated(
                itemCount: recommended.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _MarketCard(market: recommended[i]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: _CurveClipper(),
              child: Container(color: const Color(0xFF6E9B4C)),
            ),
          ),
          const Positioned(
            top: 16,
            left: 20,
            child: Text(
              'หน้าแรก',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 56,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                  SizedBox(width: 10),
                  Text(
                    'ค้นหาตลาด/เขต/ชื่อร้าน',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      {'icon': Icons.favorite_border, 'label': 'ถูกใจ'},
      {'icon': Icons.storefront_outlined, 'label': 'ตลาด'},
      {'icon': Icons.home_rounded, 'label': 'หน้าแรก'},
      {'icon': Icons.shopping_cart_outlined, 'label': 'ร้านค้า'},
      {'icon': Icons.person_outline, 'label': 'โปรไฟล์'},
    ];

    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 65,
              decoration: const BoxDecoration(
                color: Color(0xFF6E9B4C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (i) {
                  if (i == 2) return const SizedBox(width: 60);
                  final isSelected = currentIndex == i;
                  final icon = items[i]['icon'] as IconData;
                  final label = items[i]['label'] as String;

                  return GestureDetector(
  onTap: () {
  if (i == 4) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
    return;
  }

  setState(() => currentIndex = i);
},
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        icon,
        color: isSelected
            ? Colors.white
            : Colors.white.withOpacity(0.7),
        size: 22,
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isSelected
              ? Colors.white
              : Colors.white.withOpacity(0.7),
          fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => setState(() => currentIndex = 2),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    color: Color(0xFF6E9B4C),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Section Title =====
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}

// ===== Favorite Card =====
class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.market});
  final Market market;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.storefront,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  market.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  market.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 6),
                _OpenBadge(isOpen: market.isOpen),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Market Card =====
class _MarketCard extends StatelessWidget {
  const _MarketCard({required this.market});
  final Market market;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.storefront,
                  color: Color(0xFF9CA3AF),
                  size: 36,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            market.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _OpenBadge(isOpen: market.isOpen),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      market.subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      market.timeText,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: market.tags
                .map((t) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1A8),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          t,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ===== Open Badge =====
class _OpenBadge extends StatelessWidget {
  const _OpenBadge({required this.isOpen});
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen ? const Color(0xFFDFF7E6) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: isOpen ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isOpen ? 'เปิดอยู่' : 'ปิดอยู่',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isOpen ? const Color(0xFF0F7A36) : const Color(0xFFB91C1C),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Curve Clipper =====
class _CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.30,
      size.height,
      size.width * 0.55,
      size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 0.80,
      size.height - 44,
      size.width,
      size.height - 16,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
