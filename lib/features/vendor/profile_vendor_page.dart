import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/select_role_page.dart';
import 'vendor_home.dart';
import 'vendor_market_list_page.dart';
import 'favorite_vendor_page.dart'; // ✅ ชื่อไฟล์ตรงกับใน Explorer

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({super.key});

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  int currentIndex = 4;

  final Map<String, dynamic> _vendor = {
    'name': 'นางสาวมาลี ขายดี',
    'email': 'vendor@test.com',
    'phone': '082-345-6789',
    'shopName': 'ร้านมาลีผัดไทย',
    'shopCategory': 'อาหาร',
    'reliabilityScore': 87,
    'totalBookings': 24,
    'checkinRate': 92,
    'memberSince': 'กุมภาพันธ์ 2567',
  };

  final List<Map<String, dynamic>> _bookings = [
    {
      'id': 'b001',
      'marketName': 'ตลาดนัดจตุจักร',
      'stallNo': 'A-12',
      'date': '15 ม.ค. 2568',
      'status': 'pending',
      'price': 300,
    },
    {
      'id': 'b002',
      'marketName': 'ตลาดนัดรถไฟ',
      'stallNo': 'B-05',
      'date': '18 ม.ค. 2568',
      'status': 'approved',
      'price': 250,
    },
  ];

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('ออกจากระบบ', style: GoogleFonts.kanit()),
        content: Text(
          'ต้องการออกจากระบบใช่ไหม?',
          style: GoogleFonts.kanit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'ออกจากระบบ',
              style: GoogleFonts.kanit(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SelectRolePage()),
          (route) => false,
        );
      }
    }
  }

  void _navigateToPage(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            // ✅ ชื่อ class ตรงกับ favorite_vendor_page.dart
            MaterialPageRoute(builder: (_) => const VendorFavoritePage()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => VendorMarketListPage()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const VendorHome()),
          );
          break;
        case 3:
          break;
        case 4:
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
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 16),
                          _buildStatsRow(),
                          const SizedBox(height: 16),
                          _buildReliabilityScore(),
                          const SizedBox(height: 16),
                          _buildBookingSection(),
                          const SizedBox(height: 16),
                          _buildMenuSection(),
                          const SizedBox(height: 100),
                        ],
                      ),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Text(
              _vendor['shopName'].toString().substring(0, 1),
              style: GoogleFonts.kanit(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _vendor['shopName'],
            style: GoogleFonts.kanit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            _vendor['shopCategory'],
            style: GoogleFonts.kanit(fontSize: 14, color: Colors.white70),
          ),
          Text(
            _vendor['email'],
            style: GoogleFonts.kanit(fontSize: 13, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatCard('การจองทั้งหมด', '${_vendor['totalBookings']}',
              Icons.book_online),
          const SizedBox(width: 12),
          _buildStatCard(
              'เช็กอิน %', '${_vendor['checkinRate']}%', Icons.check_circle),
          const SizedBox(width: 12),
          _buildStatCard(
              'สมาชิกตั้งแต่', _vendor['memberSince'], Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF8CBC63), size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style:
                  GoogleFonts.kanit(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: GoogleFonts.kanit(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReliabilityScore() {
    final score = _vendor['reliabilityScore'] as int;
    final color = score >= 80
        ? Colors.green
        : score >= 60
            ? Colors.orange
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⭐ Reliability Score',
              style:
                  GoogleFonts.kanit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '$score',
                  style: GoogleFonts.kanit(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text('/100',
                    style: GoogleFonts.kanit(fontSize: 18, color: Colors.grey)),
                const SizedBox(width: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      minHeight: 12,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              score >= 80
                  ? '🏆 ร้านค้าที่เชื่อถือได้'
                  : '👍 ร้านค้าดี ยังพัฒนาได้',
              style: GoogleFonts.kanit(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📋 สถานะการจองล่าสุด',
            style: GoogleFonts.kanit(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._bookings.map((b) => _buildBookingCard(b)),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final isPending = booking['status'] == 'pending';
    final color = isPending ? Colors.orange : Colors.green;
    final text = isPending ? '⏳ รออนุมัติ' : '✅ อนุมัติแล้ว';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking['marketName'],
                    style: GoogleFonts.kanit(fontWeight: FontWeight.bold)),
                Text(
                  'ล็อก ${booking['stallNo']} | ${booking['date']}',
                  style: GoogleFonts.kanit(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  '฿${booking['price']}',
                  style: GoogleFonts.kanit(
                    fontSize: 13,
                    color: const Color(0xFF8CBC63),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: GoogleFonts.kanit(
                  fontSize: 12, color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.store,
            label: 'ค้นหาตลาด',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VendorMarketListPage()),
            ),
          ),
          _buildMenuItem(
              icon: Icons.history, label: 'ประวัติการจอง', onTap: () {}),
          _buildMenuItem(
              icon: Icons.edit, label: 'แก้ไขโปรไฟล์ร้านค้า', onTap: () {}),
          _buildMenuItem(
            icon: Icons.logout,
            label: 'ออกจากระบบ',
            color: Colors.redAccent,
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? const Color(0xFF8CBC63)),
        title: Text(label,
            style: GoogleFonts.kanit(color: color ?? Colors.black87)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
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
                          Icon(
                            items[i]['icon'] as IconData,
                            color: Colors.white
                                .withOpacity(isSelected ? 0.0 : 0.8),
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            items[i]['label'] as String,
                            style: GoogleFonts.kanit(
                              fontSize: 10,
                              color: Colors.white
                                  .withOpacity(isSelected ? 0.0 : 0.8),
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

class _TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF73A34F)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.78);
    path.quadraticBezierTo(
      size.width * 0.18,
      size.height * 0.98,
      size.width * 0.52,
      size.height * 0.56,
    );
    path.quadraticBezierTo(
      size.width * 0.72,
      size.height * 1.02,
      size.width,
      size.height * 0.72,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
