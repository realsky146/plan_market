import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_market_list_page.dart';
import 'favorite_vendor_page.dart';
import 'profile_vendor_page.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int currentIndex = 2;
  String userRole = 'customer'; // กำหนดเริ่มต้นที่ 'customer'

  // ฟังก์ชันสำหรับเปลี่ยน Role (เรียกใช้ฟังก์ชันนี้เพื่อสลับเมนู)
  void changeRole(String newRole) {
    setState(() {
      userRole = newRole;
    });
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
        case 1:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => VendorMarketListPage()));
          break;
        case 2:
          // อยู่หน้า Home แล้ว
          break;
        case 4:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const VendorProfilePage()));
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
              SizedBox(
                height: 140,
                width: double.infinity,
                child: CustomPaint(painter: _TopWavePainter()),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 0, 0),
                    child: Text(
                      'หน้าแรก (${userRole == 'customer' ? 'ลูกค้า' : 'ร้านค้า'})',
                      style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const SizedBox(height: 8),
                        _buildSearchBar(),
                        const SizedBox(height: 20),
                        _buildStatusCard(),
                        const SizedBox(height: 16),
                        Text('ตลาดแนะนำสำหรับคุณ',
                            style: GoogleFonts.kanit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF374151))),
                        const SizedBox(height: 10),
                        _buildMarketCard('ตลาดจตุจักร (โซนกลางคืน)',
                            'อนุจักร 1.2กม.', 'วันนี้ 17:00-23:00'),
                        const SizedBox(height: 10),
                        _buildMarketCard('ตลาดนัดรถไฟ', 'รามอินทรา 4.2กม.',
                            'วันนี้ 18:00-23:00'),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
              // จุดแสดง NavigationBar แบบ Dynamic
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: (userRole == 'vendor')
                    ? _buildVendorBottomNav()
                    : _buildCustomerBottomNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- กำหนดเมนูตาม Role ---

  Widget _buildCustomerBottomNav() {
    // เมนูของลูกค้า
    final items = [
      {'icon': Icons.favorite_border_rounded, 'label': 'ถูกใจ'},
      {'icon': Icons.storefront_rounded, 'label': 'ตลาด'},
      {'icon': Icons.home_rounded, 'label': 'หน้าแรก'},
      {'icon': Icons.shopping_cart_outlined, 'label': 'ตะกร้า'},
      {'icon': Icons.account_circle_rounded, 'label': 'โปรไฟล์'},
    ];
    return _buildBottomNavBase(items);
  }

  Widget _buildVendorBottomNav() {
    // เมนูของร้านค้า (ตัวอย่าง: เปลี่ยนไอคอนหรือเมนู)
    final items = [
      {'icon': Icons.analytics_outlined, 'label': 'ยอดขาย'},
      {'icon': Icons.edit_note_rounded, 'label': 'จัดการ'},
      {'icon': Icons.home_rounded, 'label': 'หน้าแรก'},
      {'icon': Icons.inventory_2_outlined, 'label': 'สินค้า'},
      {'icon': Icons.account_circle_rounded, 'label': 'ร้าน'},
    ];
    return _buildBottomNavBase(items);
  }

  // --- โครงสร้างพื้นฐานของ BottomNav ---

  Widget _buildBottomNavBase(List<Map<String, Object>> items) {
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
                    topRight: Radius.circular(25)),
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
                      border: Border.all(color: Colors.white, width: 3)),
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

  // --- Widget ส่วนประกอบอื่นๆ (คงเดิม) ---

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ]),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
          const SizedBox(width: 10),
          Text('ค้นหาตลาด...',
              style: GoogleFonts.kanit(
                  color: const Color(0xFF9CA3AF), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('สรุปการดำเนินการ',
              style:
                  GoogleFonts.kanit(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: [
              _statItem('รออนุมัติ', '2', const Color(0xFFFFB000)),
              const SizedBox(width: 12),
              _statItem('อนุมัติแล้ว', '5', const Color(0xFF22C55E)),
              const SizedBox(width: 12),
              _statItem('ปฏิเสธ', '1', const Color(0xFFEF4444)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.kanit(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.kanit(
                    fontSize: 11, color: const Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketCard(String name, String distance, String time) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => VendorMarketListPage())),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3))
            ]),
        child: Row(
          children: [
            Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.storefront,
                    color: Color(0xFF9CA3AF), size: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.kanit(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('ระยะทาง : $distance',
                      style: GoogleFonts.kanit(
                          fontSize: 12, color: const Color(0xFF6B7280))),
                  Text(time,
                      style: GoogleFonts.kanit(
                          fontSize: 12, color: const Color(0xFF9CA3AF))),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CBC63),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => VendorMarketListPage())),
              child: Text('จองแผง', style: GoogleFonts.kanit(fontSize: 12)),
            ),
          ],
        ),
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
