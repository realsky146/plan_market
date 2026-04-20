import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'favorite_page.dart';
import 'market_list_page.dart';
import 'market_detail_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 2;

  // ── Mock ร้านที่ถูกใจ ─────────────────────────────────────
  final List<Map<String, dynamic>> _favorites = [
    {
      'id': 'f001',
      'name': 'ร้านอาชียะ',
      'marketName': 'ตลาด : จตุจักร.',
      'isOpen': true,
      'image': 'assets/images/market_chatuchak.jpg',
    },
    {
      'id': 'f002',
      'name': 'ร้านติวการส',
      'marketName': 'ตลาด : ปากน้ำ',
      'isOpen': true,
      'image': 'assets/images/market_rotfai.jpg',
    },
    {
      'id': 'f003',
      'name': 'ร้านมาลีผัดไทย',
      'marketName': 'ตลาด : รถไฟ',
      'isOpen': false,
      'image': 'assets/images/market_sevongo.jpg',
    },
    {
      'id': 'f004',
      'name': 'ร้านสมชายข้าวต้ม',
      'marketName': 'ตลาด : สวนลุม',
      'isOpen': true,
      'image': 'assets/images/market_chatuchak.jpg',
    },
  ];

  // ── Mock ตลาดแนะนำ ────────────────────────────────────────
  final List<Map<String, dynamic>> _markets = [
    {
      'id': 'm001',
      'name': 'ตลาดจตุจักร(โซนกลางคืน)',
      'distance': 'จตุจักร 1.2กม.',
      'location': 'จตุจักร กรุงเทพฯ',
      'openTime': '17.00-23.00 น.',
      'isOpen': true,
      'rating': 4.8,
      'isFavorite': false,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
      'image': 'assets/images/market_chatuchak.jpg',
    },
    {
      'id': 'm002',
      'name': 'ตลาดนัดรถไฟ',
      'distance': 'รามอินทรา 4.2กม.',
      'location': 'รามอินทรา กรุงเทพฯ',
      'openTime': '18.00-23.00 น.',
      'isOpen': true,
      'rating': 4.5,
      'isFavorite': true,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
      'image': 'assets/images/market_rotfai.jpg',
    },
    {
      'id': 'm003',
      'name': 'ตลาดเซฟวันโก',
      'distance': 'สวนหลวง 7.2กม.',
      'location': 'สวนหลวง กรุงเทพฯ',
      'openTime': '17.00-23.00 น.',
      'isOpen': true,
      'rating': 4.3,
      'isFavorite': false,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
      'image': 'assets/images/market_sevongo.jpg',
    },
  ];

  void _navigateToPage(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const FavoritePage()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MarketListPage()),
          );
          break;
        case 2:
          break;
        case 3:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '🚧 ฟีเจอร์ร้านค้ากำลังมาเร็วๆนี้',
                style: GoogleFonts.kanit(),
              ),
            ),
          );
          break;
        case 4:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const GuestProfilePage()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        body: SafeArea(
          child: Stack(
            children: [
              // Wave Header
              SizedBox(
                height: 180,
                width: double.infinity,
                child: CustomPaint(painter: _TopWavePainter()),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title "หน้าแรก" ──────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      'หน้าแรก',
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // ── Search Bar ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MarketListPage(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Color(0xFF9CA3AF),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'ค้นหาตลาด/เขต/ชื่อร้าน',
                              style: GoogleFonts.kanit(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Content ────────────────────────────
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      children: [
                        // ร้านที่ถูกใจ Section
                        _buildFavoriteSection(),
                        const SizedBox(height: 20),
                        // ตลาดแนะนำ Section
                        _buildRecommendSection(),
                      ],
                    ),
                  ),
                ],
              ),

              // Bottom Nav
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // ร้านที่ถูกใจ Section
  // ══════════════════════════════════════════════════════════
  Widget _buildFavoriteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ร้านที่ถูกใจ',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF374151),
                  ),
                ),
                Text(
                  'Favorite',
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ✅ Horizontal scroll cards + ปุ่มดูร้านอื่นๆ
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _favorites.length + 1, // +1 สำหรับปุ่มดูร้านอื่นๆ
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              if (i == _favorites.length) {
                // ปุ่มดูร้านอื่นๆที่ถูกใจ
                return _buildViewMoreFavoriteButton();
              }
              return _buildFavoriteCard(_favorites[i]);
            },
          ),
        ),
      ],
    );
  }

  // ปุ่ม "ดูร้านอื่นๆ" ที่อยู่ท้ายรายการร้านถูกใจ
  Widget _buildViewMoreFavoriteButton() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FavoritePage()),
      ),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF8CBC63).withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF8CBC63).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFF8CBC63),
                size: 28,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'ดูร้านอื่นๆ',
              style: GoogleFonts.kanit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8CBC63),
              ),
            ),
            Text(
              'ที่ถูกใจ',
              style: GoogleFonts.kanit(
                fontSize: 12,
                color: const Color(0xFF8CBC63),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> shop) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FavoritePage()),
      ),
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // รูปร้าน
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: 90,
                width: double.infinity,
                child: Image.asset(
                  shop['image'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1B5E20),
                            const Color(0xFF8CBC63).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.storefront_rounded,
                          color: Colors.white70,
                          size: 36,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ข้อมูลร้าน
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shop['name'],
                      style: GoogleFonts.kanit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      shop['marketName'],
                      style: GoogleFonts.kanit(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: shop['isOpen']
                            ? const Color(0xFF8CBC63)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            shop['isOpen'] ? 'เปิดอยู่' : 'ปิดแล้ว',
                            style: GoogleFonts.kanit(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // ตลาดแนะนำ Section
  // ══════════════════════════════════════════════════════════
  Widget _buildRecommendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ตลาดแนะนำ',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF374151),
                  ),
                ),
                Text(
                  'Recommended markets',
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            // ปุ่ม ใกล้ที่สุด Nearest
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ใกล้ที่สุด  ',
                    style: GoogleFonts.kanit(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Nearest',
                    style: GoogleFonts.kanit(
                      fontSize: 12,
                      color: const Color(0xFF8CBC63),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Market Cards
        ..._markets.map((market) => _buildMarketCard(market)),
      ],
    );
  }

  Widget _buildMarketCard(Map<String, dynamic> market) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MarketDetailPage(market: market),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // รูปตลาด
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 120,
                  child: Image.asset(
                    market['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF1B5E20),
                              const Color(0xFF8CBC63).withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.store_mall_directory_rounded,
                            color: Colors.white70,
                            size: 44,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ข้อมูลตลาด
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Status badge + ชื่อ
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              market['name'],
                              style: GoogleFonts.kanit(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          // Status badge ย้ายมาอยู่ข้างชื่อ
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: market['isOpen']
                                  ? const Color(0xFF8CBC63)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  market['isOpen'] ? 'เปิดอยู่' : 'ปิดแล้ว',
                                  style: GoogleFonts.kanit(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // ระยะทาง
                      Text(
                        'ระยะทาง : ${market['distance']}',
                        style: GoogleFonts.kanit(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      // วันนี้เวลา
                      Text(
                        'วันนี้ ${market['openTime']}',
                        style: GoogleFonts.kanit(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Tags สีเหลือง
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: (market['tags'] as List<String>)
                            .take(3)
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3CD),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: GoogleFonts.kanit(
                                    fontSize: 11,
                                    color: const Color(0xFFB45309),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // Bottom Nav - ปรับ hover ไปคลุมปุ่มถูกใจ (index 0)
  // ══════════════════════════════════════════════════════════
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.favorite_rounded, 'label': 'ถูกใจ'},
      {'icon': Icons.storefront_rounded, 'label': 'ตลาด'},
      {'icon': Icons.home_rounded, 'label': 'หน้าหลัก'},
      {'icon': Icons.shopping_cart_outlined, 'label': 'ร้านค้า'},
      {'icon': Icons.account_circle_rounded, 'label': 'โปรไฟล์'},
    ];

    final double itemWidth = MediaQuery.of(context).size.width / items.length;

    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFF8CBC63),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (i) {
                  final isSelected = currentIndex == i;
                  return GestureDetector(
                    onTap: () => _navigateToPage(i),
                    child: SizedBox(
                      width: itemWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Icon(
                            items[i]['icon'] as IconData,
                            color: Colors.white.withOpacity(
                              isSelected ? 0.0 : 0.8,
                            ),
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            items[i]['label'] as String,
                            style: GoogleFonts.kanit(
                              fontSize: 10,
                              color: Colors.white.withOpacity(
                                isSelected ? 0.0 : 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Animated floating circle
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            left: (itemWidth * currentIndex) + (itemWidth / 2) - 31,
            top: 2,
            child: GestureDetector(
              onTap: () => _navigateToPage(currentIndex),
              child: Column(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6E9B4C),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      items[currentIndex]['icon'] as IconData,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[currentIndex]['label'] as String,
                    style: GoogleFonts.kanit(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
}

// ── Wave Painter ──────────────────────────────────────────
class _TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8CBC63)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.9,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
