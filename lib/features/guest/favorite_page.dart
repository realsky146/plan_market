import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_page.dart';
import 'market_detail_page.dart';
import 'market_list_page.dart';
import 'profile_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int currentIndex = 0;

  final List<Map<String, dynamic>> _favorites = [
    {
      'id': 'm001',
      'name': 'ตลาดจตุจักร (โซนกลางคืน)',
      'distance': 'จตุจักร 1.2กม.',
      'location': 'จตุจักร กรุงเทพฯ',
      'openTime': '17.00-23.00 น.',
      'isOpen': true,
      'rating': 4.8,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
    },
    {
      'id': 'm002',
      'name': 'ตลาดนัดรถไฟ',
      'distance': 'รามอินทรา 4.2กม.',
      'location': 'รามอินทรา กรุงเทพฯ',
      'openTime': '18.00-23.00 น.',
      'isOpen': true,
      'rating': 4.5,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
    },
    {
      'id': 'm003',
      'name': 'ตลาดเซฟวันโก',
      'distance': 'สวนหลวง 7.2กม.',
      'location': 'สวนหลวง กรุงเทพฯ',
      'openTime': '17.00-23.00 น.',
      'isOpen': true,
      'rating': 4.3,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
    },
    {
      'id': 'm004',
      'name': 'ตลาดเซฟวันโก',
      'distance': 'สวนหลวง 7.2กม.',
      'location': 'สวนหลวง กรุงเทพฯ',
      'openTime': '17.00-23.00 น.',
      'isOpen': true,
      'rating': 4.3,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
    },
  ];

  void _navigateToPage(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MarketListPage()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
          break;
        case 3:
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
              // ── Wave Header ────────────────────────────
              SizedBox(
                height: 160,
                width: double.infinity,
                child: CustomPaint(painter: _TopWavePainter()),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 14, 20, 0),
                    child: Row(
                      children: [
                        // ปุ่ม Back
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        Text(
                          'ร้านที่ถูกใจ...',
                          style: GoogleFonts.kanit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── List ────────────────────────────────
                  Expanded(
                    child: _favorites.isEmpty
                        ? _buildEmpty()
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            itemCount: _favorites.length,
                            itemBuilder: (_, i) => _buildCard(_favorites[i]),
                          ),
                  ),
                ],
              ),

              // ── Bottom Nav ──────────────────────────────
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

  // ── Empty State ───────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'ยังไม่มีตลาดที่ถูกใจ',
            style: GoogleFonts.kanit(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8CBC63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MarketListPage()),
            ),
            child: Text(
              'ค้นหาตลาด',
              style: GoogleFonts.kanit(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Market Card (ตามรูป) ──────────────────────────────────
  Widget _buildCard(Map<String, dynamic> market) {
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
        child: Column(
          children: [
            // ── Row บน: รูป + ข้อมูล ──────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // รูปตลาด
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Container(
                    width: 120,
                    height: 110,
                    color: const Color(0xFF8CBC63).withOpacity(0.15),
                    child: const Icon(
                      Icons.store_mall_directory_rounded,
                      color: Color(0xFF8CBC63),
                      size: 44,
                    ),
                  ),
                ),

                // ข้อมูลตลาด
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status badge + ปุ่มลบ
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
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
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ปุ่มลบ
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _favorites.removeWhere(
                                    (m) => m['id'] == market['id'],
                                  );
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'ลบออกจากรายการถูกใจแล้ว',
                                      style: GoogleFonts.kanit(),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // ชื่อตลาด
                        Text(
                          'ร้าน',
                          style: GoogleFonts.kanit(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

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
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Tags Row ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: (market['tags'] as List<String>)
                    .take(3)
                    .map(
                      (tag) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.kanit(
                            fontSize: 12,
                            color: const Color(0xFFB45309),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Nav ─────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.favorite_border_rounded, 'label': 'ถูกใจ'},
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            left: (itemWidth * currentIndex) + (itemWidth / 2) - 31,
            top: 2,
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
