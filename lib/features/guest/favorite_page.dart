import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  // ===== Mock Data (สำหรับการทำ Prototype) =====
  static const _shops = [
    _ShopData(
      shopName: 'โกโก้ในตำนาน',
      marketName: 'ตลาดจตุจักร',
      distance: '1.2 กม.',
      openTime: '18.00-23.00 น.',
      isOpen: true,
      shopType: 'น้ำหวาน',
      duration: '3 เดือน',
      days: 'ศุกร์-อาทิตย์',
      image: '', // ใส่ Path รูปภาพถ้ามี
    ),
    _ShopData(
      shopName: 'ร้านอาชียะ',
      marketName: 'ตลาดนัดรถไฟ',
      distance: '4.2 กม.',
      openTime: '17.00-23.00 น.',
      isOpen: true,
      shopType: 'อาหาร',
      duration: '6 เดือน',
      days: 'ทุกวัน',
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
        backgroundColor: const Color(0xFFEEEEEE),
        body: SafeArea(
          child: Stack(
            children: [
              // Header โค้งสีเขียว
              SizedBox(
                height: 130,
                width: double.infinity,
                child: CustomPaint(painter: _TopWavePainter()),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ปุ่มย้อนกลับและหัวข้อ
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 16, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'ร้านที่ถูกใจ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // รายการร้านค้า
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: _shops.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () =>
                              _showShopDetailDialog(context, _shops[i]),
                          child: _ShopCard(data: _shops[i]),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Bottom Navigation
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomNav(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== ฟังก์ชันแสดง Popup รายละเอียดร้านค้า =====
  void _showShopDetailDialog(BuildContext context, _ShopData data) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ส่วนหัว Popup (สีเขียว)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF73A34F),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Text(
                'รายละเอียดร้านค้า',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // รูปภาพใน Popup
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // ข้อมูลรายละเอียด (ตามตัวอย่างภาพ)
                  _buildDetailRow('ชื่อร้าน :', data.shopName),
                  _buildDetailRow('ประเภท :', data.shopType),
                  _buildDetailRow('วัน :', data.days),
                  _buildDetailRow('เวลา :', data.openTime),
                  _buildDetailRow('ระยะเวลา :', data.duration),
                  _buildDetailRow('สถานะ :', data.isOpen ? 'เปิด' : 'ปิด'),

                  const SizedBox(height: 24),

                  // ปุ่มย้อนกลับ
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE9E9E9),
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ย้อนกลับ'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    // โค้ด Bottom Nav เหมือนที่คุณมี...
    return Container(/* ... UI Bottom Nav ... */);
  }
}

// ===== Widget: การ์ดร้านค้า =====
class _ShopCard extends StatelessWidget {
  final _ShopData data;
  const _ShopCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.store, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.shopName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(data.marketName,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                _OpenBadge(isOpen: data.isOpen),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Helper Widgets & Painter =====
class _OpenBadge extends StatelessWidget {
  final bool isOpen;
  const _OpenBadge({required this.isOpen});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isOpen ? const Color(0xFFDFF7E6) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOpen ? 'เปิดอยู่' : 'ปิดอยู่',
        style: TextStyle(
            fontSize: 10,
            color: isOpen ? Colors.green[800] : Colors.red[800],
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ShopData {
  final String shopName,
      marketName,
      distance,
      openTime,
      shopType,
      duration,
      days,
      image;
  final bool isOpen;
  const _ShopData(
      {required this.shopName,
      required this.marketName,
      required this.distance,
      required this.openTime,
      required this.isOpen,
      required this.shopType,
      required this.duration,
      required this.days,
      required this.image});
}

class _TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF73A34F)
      ..style = PaintingStyle.fill;
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.2, size.height, size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.4, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
