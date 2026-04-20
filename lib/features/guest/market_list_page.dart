import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_market/features/auth/select_role_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_page.dart'; // ✅ เปลี่ยนจาก select_role_page
import 'favorite_page.dart';
import 'home_page.dart';
import 'market_detail_page.dart';

class MarketListPage extends StatefulWidget {
  const MarketListPage({super.key});

  @override
  State<MarketListPage> createState() => _MarketListPageState();
}

class _MarketListPageState extends State<MarketListPage> {
  int currentIndex = 1;
  String _searchText = '';

  final List<Map<String, dynamic>> _markets = [
    {
      'id': 'm001',
      'name': 'ตลาดจตุจักร (โซนกลางคืน)',
      'distance': '1.2 กม.',
      'location': 'จตุจักร กรุงเทพฯ',
      'openTime': '17:00 - 23:00',
      'isOpen': true,
      'rating': 4.8,
      'totalStalls': 120,
      'availableStalls': 45,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
      'isFavorite': false,
      'image': 'assets/images/market_chatuchak.jpg',
    },
    {
      'id': 'm002',
      'name': 'ตลาดนัดรถไฟ',
      'distance': '4.2 กม.',
      'location': 'รามอินทรา กรุงเทพฯ',
      'openTime': '18:00 - 23:00',
      'isOpen': true,
      'rating': 4.5,
      'totalStalls': 80,
      'availableStalls': 20,
      'tags': ['อาหาร', 'ของสด'],
      'isFavorite': true,
      'image': 'assets/images/market_rotfai.jpg',
    },
    {
      'id': 'm003',
      'name': 'ตลาดนัดสวนลุม',
      'distance': '6.5 กม.',
      'location': 'พระราม 4 กรุงเทพฯ',
      'openTime': '17:00 - 22:00',
      'isOpen': false,
      'rating': 4.3,
      'totalStalls': 60,
      'availableStalls': 0,
      'tags': ['ของสด', 'อาหาร'],
      'isFavorite': false,
      'image': 'assets/images/market_sevongo.jpg',
    },
  ];

  // ✅ ลบ delay ออก
  void _navigateToPage(int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const FavoritePage()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🚧 ฟีเจอร์ร้านค้ากำลังมาเร็วๆนี้',
                style: GoogleFonts.kanit()),
          ),
        );
        break;
      case 4:
        _navigateToProfile();
        break;
    }
  }

// ✅ เพิ่ม method นี้ในทุกหน้า
  Future<void> _navigateToProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');

    if (!mounted) return;

    if (role == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectRolePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GuestProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _markets.where((m) {
      return m['name'].toString().contains(_searchText) ||
          m['location'].toString().contains(_searchText);
    }).toList();

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                height: 140,
                width: double.infinity,
                child: CustomPaint(painter: _TopWavePainter()),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Text(
                      '🏪 ตลาดทั้งหมด',
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: TextField(
                      onChanged: (v) => setState(() => _searchText = v),
                      style: GoogleFonts.kanit(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'ค้นหาตลาด...',
                        hintStyle:
                            GoogleFonts.kanit(color: const Color(0xFFBDBDBD)),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text('ไม่พบตลาดที่ค้นหา',
                                style: GoogleFonts.kanit(color: Colors.grey)),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) =>
                                _buildMarketCard(filtered[i]),
                          ),
                  ),
                ],
              ),
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

  Widget _buildMarketCard(Map<String, dynamic> market) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MarketDetailPage(market: market)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          children: [
            // ✅ เพิ่มรูปตลาด
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: SizedBox(
                width: 90,
                height: 90,
                child: Image.asset(
                  market['image'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(Icons.storefront_rounded,
                        color: Color(0xFF9CA3AF), size: 32),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              market['isFavorite'] = !market['isFavorite'];
                            }),
                            child: Icon(
                              market['isFavorite']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: market['isFavorite']
                                  ? Colors.redAccent
                                  : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '📍 ${market['location']} (${market['distance']})',
                      style:
                          GoogleFonts.kanit(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '🕐 ${market['openTime']}',
                      style:
                          GoogleFonts.kanit(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: market['isOpen']
                                ? const Color(0xFFDFF7E6)
                                : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            market['isOpen'] ? '🟢 เปิดอยู่' : '🔴 ปิดแล้ว',
                            style: GoogleFonts.kanit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: market['isOpen']
                                  ? const Color(0xFF0F7A36)
                                  : const Color(0xFFB91C1C),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFB000), size: 14),
                        Text(' ${market['rating']}',
                            style: GoogleFonts.kanit(
                                fontSize: 12, color: Colors.grey)),
                      ],
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

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.favorite_border_rounded, 'label': 'ถูกใจ'},
      {'icon': Icons.storefront_rounded, 'label': 'ตลาด'},
      {'icon': Icons.home_rounded, 'label': 'หน้าแรก'},
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
                          Icon(items[i]['icon'] as IconData,
                              color: Colors.white
                                  .withOpacity(isSelected ? 0.0 : 0.8),
                              size: 22),
                          const SizedBox(height: 4),
                          Text(items[i]['label'] as String,
                              style: GoogleFonts.kanit(
                                  fontSize: 10,
                                  color: Colors.white
                                      .withOpacity(isSelected ? 0.0 : 0.8))),
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
                  ),
                  child: Icon(items[currentIndex]['icon'] as IconData,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(height: 4),
                Text(items[currentIndex]['label'] as String,
                    style: GoogleFonts.kanit(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF73A34F)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.18, size.height * 0.98,
          size.width * 0.52, size.height * 0.56)
      ..quadraticBezierTo(
          size.width * 0.72, size.height * 1.02, size.width, size.height * 0.72)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
