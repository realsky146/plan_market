import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_market/features/guest/favorite_page.dart';
import 'package:plan_market/features/guest/market_list_page.dart';
// import 'package:plan_market/features/guest/signin_page.dart'; // สำหรับหน้าที่สตางค์ออกแบบ
import '../../models/market.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 2; // หน้าหลักคือ Index 2

  final List<Market> favorites = const [
    Market(
        name: 'ร้านอาชียะ',
        subtitle: 'ตลาด : จตุจักร.',
        timeText: '18.00-23.00 น.',
        isOpen: true,
        tags: [],
        image: ''),
    Market(
        name: 'ร้านติวการค้า',
        subtitle: 'ตลาด : ปากเกร็ด',
        timeText: '10.00-20.00 น.',
        isOpen: true,
        tags: [],
        image: ''),
    Market(
        name: 'เจ๊แดง ส้มตำ',
        subtitle: 'ตลาด : สามย่าน',
        timeText: '11.00-21.00 น.',
        isOpen: true,
        tags: [],
        image: ''),
  ];

  final List<Market> recommended = const [
    Market(
        name: 'ตลาดจตุจักร (โซนกลางคืน)',
        subtitle: 'ระยะทาง : จตุจักร 1.2กม.',
        timeText: 'วันนี้ 17.00-23.00 น.',
        isOpen: true,
        tags: ['อาหาร', 'แฟชั่น', 'มือสอง'],
        image: ''),
    Market(
        name: 'ตลาดนัดรถไฟ',
        subtitle: 'ระยะทาง : รามอินทรา 4.2กม.',
        timeText: 'วันนี้ 18.00-23.00 น.',
        isOpen: true,
        tags: ['อาหาร', 'แฟชั่น', 'มือสอง'],
        image: ''),
    Market(
        name: 'ตลาดเซฟวันโก',
        subtitle: 'ระยะทาง : สวนหลวง 7.2กม.',
        timeText: 'วันนี้ 17.00-23.00 น.',
        isOpen: false,
        tags: ['อาหาร', 'แฟชั่น', 'มือสอง'],
        image: ''),
  ];

  void _navigateToPage(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);

    Future.delayed(const Duration(milliseconds: 300), () {
      switch (index) {
        case 0: // หน้าถูกใจ
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const FavoritePage()));
          break;
        case 1: // หน้าตลาด
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const MarketListPage()));
          break;
        case 2: // หน้าหลัก (อยู่ที่เดิม)
          break;
        case 3: // หน้าร้านค้า (คอมเมนต์ไว้ก่อน)
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StorePage()));
          break;
        case 4: // หน้าโปรไฟล์
          /* // ลอจิกที่คุณ Cee ต้องการ:
          bool isFirstTime = true; // สมมติสถานะเช็คจากระบบ
          if(isFirstTime) {
             // ไปหน้าที่ให้เลือก Sign-in / Sign-up ที่สตางค์ออกแบบ
             // Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthSelectionPage()));
          } else {
             // ถ้าล็อคอินแล้วไปหน้าโปรไฟล์ที่คุณ Cee ออกแบบ
             // Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          }
          */
          break;
      }
    });
  }

  // --- ฟังก์ชัน Pop-up (คงเดิมตามที่คุณ Cee เขียนไว้) ---
  void _showMarketDetailDialog(BuildContext context, Market market) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                      height: 140,
                      width: double.infinity,
                      color: const Color(0xFFF3F4F6),
                      child: const Icon(Icons.storefront,
                          size: 60, color: Color(0xFFD1D5DB))),
                ),
                const SizedBox(height: 20),
                Text('ชื่อร้าน : ${market.name}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildDetailRow('ประเภท :', 'น้ำหวาน/อาหาร'),
                _buildDetailRow('วัน :', 'ศุกร์-อาทิตย์'),
                _buildDetailRow(
                    'เวลา :',
                    market.timeText.isEmpty
                        ? '18.00-23.00 น.'
                        : market.timeText),
                _buildDetailRow('ระยะเวลา :', '3 เดือน'),
                const SizedBox(height: 12),
                Row(children: [
                  const Text('สถานะ : ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  _OpenBadge(isOpen: market.isOpen)
                ]),
                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text('ย้อนกลับ',
                            style: TextStyle(
                                color: Color(0xFF4B5563),
                                fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14)))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                        child: _SectionTitle(
                            title: 'ร้านที่ถูกใจ', subtitle: 'Favorite'))),
                SliverToBoxAdapter(
                  child: SizedBox(
                      height: 110,
                      child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...favorites
                                .map((m) => Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: _FavoriteCard(
                                        market: m,
                                        onTap: () => _showMarketDetailDialog(
                                            context, m))))
                                .toList(),
                            _buildSeeAllButton()
                          ])),
                ),
                SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          _SectionTitle(
                              title: 'ตลาดแนะนำ',
                              subtitle: 'Recommended markets'),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFFE5E7EB)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              onPressed: () {},
                              child: const Text('ใกล้ฉัน Nearest',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF111827))))
                        ]))),
                SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    sliver: SliverList.separated(
                        itemCount: recommended.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _MarketCard(
                            market: recommended[i],
                            onTap: () => _showMarketDetailDialog(
                                context, recommended[i])))),
              ],
            ),
            Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
          ],
        ),
      ),
    );
  }

  // --- ส่วนดีไซน์ Bottom Nav ที่ปรับให้เหมือน MarketListPage ---
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

  // --- Header & Sub-widgets อื่นๆ (คงเดิม) ---
  Widget _buildHeader() {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Positioned.fill(
              child: ClipPath(
                  clipper: _CurveClipper(),
                  child: Container(color: const Color(0xFF6E9B4C)))),
          const Positioned(
              top: 45,
              left: 20,
              child: Text('หน้าแรก',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold))),
          Positioned(
              left: 16,
              right: 16,
              top: 90,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ]),
                  child: const Row(children: [
                    Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                    SizedBox(width: 10),
                    Text('ค้นหาตลาด/เขต/ชื่อร้าน',
                        style:
                            TextStyle(color: Color(0xFF9CA3AF), fontSize: 14))
                  ]))),
        ],
      ),
    );
  }

  Widget _buildSeeAllButton() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const FavoritePage())),
      child: Container(
          width: 100,
          decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Color(0xFF6E9B4C))),
            const SizedBox(height: 8),
            const Text('ดูทั้งหมด',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B7280)))
          ])),
    );
  }
}

// Sub-Widgets (คงเดิมตามโค้ดของคุณ)
class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Text(subtitle,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)))
    ]);
  }
}

class _FavoriteCard extends StatelessWidget {
  final Market market;
  final VoidCallback onTap;
  const _FavoriteCard({required this.market, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: 180,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]),
            child: Row(children: [
              Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(10)),
                  child:
                      const Icon(Icons.storefront, color: Color(0xFF9CA3AF))),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(market.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    Text(market.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF6B7280))),
                    const SizedBox(height: 4),
                    _OpenBadge(isOpen: market.isOpen)
                  ]))
            ])));
  }
}

class _MarketCard extends StatelessWidget {
  final Market market;
  final VoidCallback onTap;
  const _MarketCard({required this.market, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(12),
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
              Row(children: [
                Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.storefront,
                        color: Color(0xFF9CA3AF), size: 30)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(market.name,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
                            _OpenBadge(isOpen: market.isOpen)
                          ]),
                      Text(market.subtitle,
                          style: const TextStyle(
                              fontSize: 11.5, color: Color(0xFF6B7280))),
                      Text(market.timeText,
                          style: const TextStyle(
                              fontSize: 11.5, color: Color(0xFF6B7280)))
                    ]))
              ]),
              const SizedBox(height: 10),
              Row(
                  children: market.tags
                      .map((t) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFF1A8),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(t,
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold))))
                      .toList())
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
            borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                  color: isOpen
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFEF4444),
                  shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(isOpen ? 'เปิดอยู่' : 'ปิดอยู่',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isOpen
                      ? const Color(0xFF0F7A36)
                      : const Color(0xFFB91C1C)))
        ]));
  }
}

class _CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width * 0.3, size.height, size.width * 0.55, size.height - 20);
    path.quadraticBezierTo(
        size.width * 0.8, size.height - 44, size.width, size.height - 16);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
