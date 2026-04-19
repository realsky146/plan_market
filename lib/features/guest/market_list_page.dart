import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'favorite_page.dart';
import 'market_detail_page.dart';

class MarketListPage extends StatefulWidget {
  const MarketListPage({super.key});
  @override
  State<MarketListPage> createState() => _MarketListPageState();
}

class _MarketListPageState extends State<MarketListPage> {
  int currentIndex = 1; // หน้าตลาดคือ Index 1

  static const _markets = [
    _MarketData(
        name: 'ตลาดจตุจักร(โซนกลางคืน)',
        distance: 'จตุจักร 1.2กม.',
        time: 'วันนี้ 17.00-23.00 น.',
        isOpen: true,
        tags: ['อาหาร', 'แฟชั่น', 'มือสอง'],
        image: 'assets/images/market1.jpg'),
    _MarketData(
        name: 'ตลาดนัดรถไฟ',
        distance: 'รามอินทรา 4.2กม.',
        time: 'วันนี้ 18.00-23.00 น.',
        isOpen: true,
        tags: ['อาหาร', 'แฟชั่น', 'มือสอง'],
        image: 'assets/images/market2.jpg'),
    _MarketData(
        name: 'ตลาดเซฟวันโก',
        distance: 'สวนหลวง 7.2กม.',
        time: 'วันนี้ 17.00-23.00 น.',
        isOpen: true,
        tags: ['อาหาร', 'แฟชั่น', 'มือสอง'],
        image: 'assets/images/market3.jpg'),
  ];

  void _navigateToPage(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);

    Future.delayed(const Duration(milliseconds: 300), () {
      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const FavoritePage()));
          break;
        case 1:
          break; // หน้านี้อยู่แล้ว
        case 2:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
          break;
        case 3:
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StorePage()));
          break;
        case 4:
          // logic profile เหมือนหน้า Home
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme)),
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: CustomPaint(painter: _TopWavePainter())),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Text('รายการตลาดแนะนำ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  const SizedBox(height: 12),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4))
                              ]),
                          child: const Row(children: [
                            Icon(Icons.search,
                                color: Color(0xFF9CA3AF), size: 20),
                            SizedBox(width: 10),
                            Text('ค้นหาตลาด...',
                                style: TextStyle(
                                    color: Color(0xFF9CA3AF), fontSize: 14))
                          ]))),
                  const SizedBox(height: 16),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ตลาดแนะนำ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                                  Text('Recommended markets',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF9CA3AF)))
                                ]),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFFE5E7EB)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: const Text('ใกล้ที่สุด Nearest',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF111827))))
                          ])),
                  const SizedBox(height: 10),
                  Expanded(
                      child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                          itemCount: _markets.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) => _MarketCard(
                              data: _markets[i],
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MarketDetailPage(
                                          market: _markets[i])))))),
                ],
              ),
              Positioned(
                  bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
            ],
          ),
        ),
      ),
    );
  }

  // --- ส่วนดีไซน์ Bottom Nav ---
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.favorite_border_rounded, 'label': 'ถูกใจ'},
      {'icon': Icons.storefront_rounded, 'label': 'ตลาด'},
      {'icon': Icons.home_rounded, 'label': 'หน้าหลัก'},
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
                                  size: 24),
                              const SizedBox(height: 4),
                              Text(items[i]['label'] as String,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                          .withOpacity(isSelected ? 0 : 0.8),
                                      fontWeight: FontWeight.w500))
                            ])),
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
                              offset: const Offset(0, 4))
                        ]),
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

// ปลายไฟล์คงเดิม (MarketCard, WavePainter, etc.)
class _MarketCard extends StatelessWidget {
  final _MarketData data;
  final VoidCallback onTap;
  const _MarketCard({required this.data, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                                width: 90,
                                height: 80,
                                color: const Color(0xFFE5E7EB),
                                child: const Icon(Icons.storefront,
                                    color: Color(0xFF9CA3AF), size: 36))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Text(data.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800))),
                                    const SizedBox(width: 6),
                                    _OpenBadge(isOpen: data.isOpen)
                                  ]),
                              const SizedBox(height: 4),
                              Text('ระยะทาง : ${data.distance}',
                                  style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF6B7280))),
                              const SizedBox(height: 2),
                              Text(data.time,
                                  style: const TextStyle(
                                      fontSize: 11.5, color: Color(0xFF6B7280)))
                            ]))
                      ])),
              Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                      children: data.tags
                          .map((t) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1A8),
                                      borderRadius: BorderRadius.circular(999)),
                                  child: Text(t,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)))))
                          .toList()))
            ])));
  }
}

class _OpenBadge extends StatelessWidget {
  final bool isOpen;
  const _OpenBadge({required this.isOpen});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: isOpen ? const Color(0xFFDFF7E6) : const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(999)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                  color: isOpen
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFEF4444),
                  shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(isOpen ? 'เปิดอยู่' : 'ปิดอยู่',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isOpen
                      ? const Color(0xFF0F7A36)
                      : const Color(0xFFB91C1C)))
        ]));
  }
}

class _MarketData {
  final String name, distance, time, image;
  final bool isOpen;
  final List<String> tags;
  const _MarketData(
      {required this.name,
      required this.distance,
      required this.time,
      required this.image,
      required this.isOpen,
      required this.tags});
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
