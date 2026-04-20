import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_home.dart';
import 'favorite_vendor_page.dart';
import 'profile_vendor_page.dart';
import 'vendor_booking_page.dart';

class VendorMarketListPage extends StatefulWidget {
  const VendorMarketListPage({super.key});

  @override
  State<VendorMarketListPage> createState() => _VendorMarketListPageState();
}

class _VendorMarketListPageState extends State<VendorMarketListPage> {
  int currentIndex = 1;
  String _selectedFilter = 'แนะนำ';
  final _searchCtrl = TextEditingController();

  final _filters = [
    'แนะนำ',
    'ใกล้ฉัน',
    'คนเยอะ',
    'ราคาถูก',
    'เปิดอยู่',
  ];

  // Mock ตลาดแนะนำ (พร้อมข้อมูลที่ร้านค้าสนใจ)
  final _markets = [
    {
      'id': 'm001',
      'name': 'ตลาดจตุจักร (โซนกลางคืน)',
      'distance': '1.2 กม.',
      'time': '17:00 - 23:00 น.',
      'isOpen': true,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
      'stallsAvailable': 12,
      'totalStalls': 120,
      'pricePerDay': 300,
      'traffic': 'สูง', // traffic คนเดินเยอะ
      'rating': 4.8,
      'isFavorite': true,
      'reason': 'ใกล้คุณที่สุด', // เหตุผลแนะนำ
    },
    {
      'id': 'm002',
      'name': 'ตลาดนัดรถไฟ',
      'distance': '4.2 กม.',
      'time': '18:00 - 23:00 น.',
      'isOpen': true,
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
      'stallsAvailable': 25,
      'totalStalls': 200,
      'pricePerDay': 250,
      'traffic': 'สูงมาก',
      'rating': 4.9,
      'isFavorite': false,
      'reason': 'คนเดินเยอะที่สุด',
    },
    {
      'id': 'm003',
      'name': 'ตลาดเซฟวันโก',
      'distance': '7.2 กม.',
      'time': '17:00 - 23:00 น.',
      'isOpen': false,
      'tags': ['อาหาร', 'ของใช้'],
      'stallsAvailable': 40,
      'totalStalls': 150,
      'pricePerDay': 200,
      'traffic': 'ปานกลาง',
      'rating': 4.5,
      'isFavorite': false,
      'reason': 'แผงว่างเยอะ',
    },
    {
      'id': 'm004',
      'name': 'ตลาดนัดสวนหลวง',
      'distance': '3.5 กม.',
      'time': '16:00 - 22:00 น.',
      'isOpen': true,
      'tags': ['อาหาร', 'เสื้อผ้า'],
      'stallsAvailable': 8,
      'totalStalls': 80,
      'pricePerDay': 180,
      'traffic': 'สูง',
      'rating': 4.6,
      'isFavorite': false,
      'reason': 'ราคาถูกที่สุด',
    },
  ];

  List<Map<String, dynamic>> get _filteredMarkets {
    var list = List<Map<String, dynamic>>.from(_markets);

    // กรองตาม filter
    switch (_selectedFilter) {
      case 'ใกล้ฉัน':
        list.sort((a, b) {
          final da =
              double.parse((a['distance'] as String).replaceAll(' กม.', ''));
          final db =
              double.parse((b['distance'] as String).replaceAll(' กม.', ''));
          return da.compareTo(db);
        });
        break;
      case 'คนเยอะ':
        final order = ['สูงมาก', 'สูง', 'ปานกลาง', 'ต่ำ'];
        list.sort((a, b) => order
            .indexOf(a['traffic'] as String)
            .compareTo(order.indexOf(b['traffic'] as String)));
        break;
      case 'ราคาถูก':
        list.sort((a, b) =>
            (a['pricePerDay'] as int).compareTo(b['pricePerDay'] as int));
        break;
      case 'เปิดอยู่':
        list = list.where((m) => m['isOpen'] == true).toList();
        break;
    }
    return list;
  }

  void _navigateToPage(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      switch (index) {
        case 0:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const VendorFavoritePage()));
          break;
        case 2:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const VendorHome()));
          break;
        case 4:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const VendorProfilePage()));
          break;
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
              // Header
              SizedBox(
                height: 160,
                width: double.infinity,
                child: CustomPaint(painter: _TopWavePainter()),
              ),

              Column(
                children: [
                  // หัวข้อ + Search
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ตลาดแนะนำสำหรับคุณ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 10),

                        // Search bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4)),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search,
                                  color: Color(0xFF9CA3AF), size: 20),
                              SizedBox(width: 10),
                              Text('ค้นหาตลาด...',
                                  style: TextStyle(
                                      color: Color(0xFF9CA3AF), fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Filter chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final f = _filters[i];
                        final selected = _selectedFilter == f;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = f),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF6E9B4C)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: selected
                                        ? const Color(0xFF6E9B4C)
                                        : const Color(0xFFE5E7EB))),
                            child: Text(f,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF6B7280))),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // รายการตลาด
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      itemCount: _filteredMarkets.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          _buildMarketCard(_filteredMarkets[i]),
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

  // ===== Market Card =====
  Widget _buildMarketCard(Map<String, dynamic> m) {
    final isOpen = m['isOpen'] as bool;
    final tags = m['tags'] as List<String>;
    final available = m['stallsAvailable'] as int;
    final total = m['totalStalls'] as int;
    final traffic = m['traffic'] as String;
    final isFavorite = m['isFavorite'] as bool;

    // สี traffic
    Color trafficColor;
    switch (traffic) {
      case 'สูงมาก':
        trafficColor = const Color(0xFFEF4444);
        break;
      case 'สูง':
        trafficColor = const Color(0xFFFFB000);
        break;
      default:
        trafficColor = const Color(0xFF22C55E);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // รูปตลาด
                    Stack(
                      children: [
                        Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                color: const Color(0xFFE5E7EB),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.storefront,
                                color: Color(0xFF9CA3AF), size: 36)),

                        // badge เปิด/ปิด
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: isOpen
                                    ? const Color(0xFF22C55E)
                                    : const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 1.5)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ชื่อ + ถูกใจ
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(m['name'] as String,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14))),
                              GestureDetector(
                                  onTap: () => setState(
                                      () => m['isFavorite'] = !isFavorite),
                                  child: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF9CA3AF),
                                      size: 20)),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // ระยะทาง + เวลา
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 12, color: Color(0xFF9CA3AF)),
                              const SizedBox(width: 4),
                              Text(m['distance'] as String,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF6B7280))),
                              const SizedBox(width: 10),
                              const Icon(Icons.access_time,
                                  size: 12, color: Color(0xFF9CA3AF)),
                              const SizedBox(width: 4),
                              Text(m['time'] as String,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF6B7280))),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Stats row
                          Row(
                            children: [
                              // แผงว่าง
                              _miniStat(
                                  Icons.grid_view,
                                  'ว่าง $available/$total',
                                  const Color(0xFF2D9CDB)),
                              const SizedBox(width: 10),
                              // Traffic
                              _miniStat(
                                  Icons.people, 'คน: $traffic', trafficColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Tags + ราคา
                Row(
                  children: [
                    // Tags
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        children: tags
                            .map((t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFFF1A8),
                                    borderRadius: BorderRadius.circular(999)),
                                child: Text(t,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600))))
                            .toList(),
                      ),
                    ),

                    // ราคา
                    Text('฿${m['pricePerDay']}/วัน',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8CBC63))),
                  ],
                ),
              ],
            ),
          ),

          // เหตุผลแนะนำ + ปุ่มจอง
          Container(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                // เหตุผลแนะนำ
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFF6E9B4C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          size: 13, color: Color(0xFF6E9B4C)),
                      const SizedBox(width: 5),
                      Text(m['reason'] as String,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6E9B4C),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const Spacer(),

                // ปุ่มจองแผง
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: available > 0
                        ? const Color(0xFF8CBC63)
                        : const Color(0xFFE5E7EB),
                    foregroundColor:
                        available > 0 ? Colors.white : const Color(0xFF9CA3AF),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: available > 0
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => VendorBookingPage(
                                    marketId: m['id'] as String,
                                    marketName: m['name'] as String,
                                    market: {},
                                  )))
                      : null,
                  child: Text(available > 0 ? 'จองแผง' : 'เต็มแล้ว',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(text,
            style: TextStyle(
                fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ===== Bottom Nav =====
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.favorite_border_rounded, 'label': 'ถูกใจ'},
      {'icon': Icons.storefront_rounded, 'label': 'ตลาด'},
      {'icon': Icons.home_rounded, 'label': 'หน้าแรก'},
      {'icon': Icons.shopping_cart_outlined, 'label': 'ร้านค้า'},
      {'icon': Icons.account_circle_rounded, 'label': 'โปรไฟล์'},
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / items.length;

    return Container(
      height: 90,
      color: Colors.transparent,
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
                      topRight: Radius.circular(25))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (i) {
                  bool isSelected = currentIndex == i;
                  return GestureDetector(
                    onTap: () => _navigateToPage(i),
                    child: Container(
                      width: itemWidth,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Icon(items[i]['icon'] as IconData,
                              color: Colors.white
                                  .withOpacity(isSelected ? 0 : 0.8),
                              size: 22),
                          const SizedBox(height: 4),
                          Text(items[i]['label'] as String,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white
                                      .withOpacity(isSelected ? 0 : 0.8),
                                  fontWeight: FontWeight.w500)),
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
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Icon(items[currentIndex]['icon'] as IconData,
                        color: Colors.white, size: 28)),
                const SizedBox(height: 4),
                Text(items[currentIndex]['label'] as String,
                    style: const TextStyle(
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
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.78);
    path.quadraticBezierTo(size.width * 0.18, size.height * 0.98,
        size.width * 0.52, size.height * 0.56);
    path.quadraticBezierTo(
        size.width * 0.72, size.height * 1.02, size.width, size.height * 0.72);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
