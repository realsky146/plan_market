import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'market_detail_page.dart';
import 'market_list_page.dart';
import 'profile_page.dart';
import '../auth/select_role_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int currentIndex = 0;
  String? _userRole; // ✅ เก็บ role
  bool _isLoading = true;

  // ── Mock ร้านที่ถูกใจ (อิงจากข้อมูลที่ร้านลงทะเบียน) ────
  final List<Map<String, dynamic>> _favorites = [
    {
      'id': 's001',
      'shopName': 'โกโก้ในตำนาน',
      'category': 'น้ำหวาน',
      'day': 'ศุกร์-อาทิตย์',
      'time': '18.00-23.00 น.',
      'rentalPeriod': '3 เดือน',
      'status': 'เปิด',
      'isOpen': true,
      'marketName': 'ตลาดจตุจักร',
      'distance': 'จตุจักร 1.2กม.',
      'openTime': '18.00-23.00 น.',
      'image': 'assets/images/market_chatuchak.jpg',
      'tags': ['อาหาร', 'แฟชั่น', 'มือสอง'],
    },
    {
      'id': 's002',
      'shopName': 'ร้านมาลีผัดไทย',
      'category': 'อาหาร',
      'day': 'เสาร์-อาทิตย์',
      'time': '17.00-22.00 น.',
      'rentalPeriod': '6 เดือน',
      'status': 'เปิด',
      'isOpen': true,
      'marketName': 'ตลาดนัดรถไฟ',
      'distance': 'รามอินทรา 4.2กม.',
      'openTime': '17.00-22.00 น.',
      'image': 'assets/images/market_rotfai.jpg',
      'tags': ['อาหาร', 'ของสด'],
    },
    {
      'id': 's003',
      'shopName': 'ร้านแฟชั่นเกาหลี',
      'category': 'เสื้อผ้า',
      'day': 'ทุกวัน',
      'time': '16.00-22.00 น.',
      'rentalPeriod': '1 เดือน',
      'status': 'ปิด',
      'isOpen': false,
      'marketName': 'ตลาดเซฟวันโก',
      'distance': 'สวนหลวง 7.2กม.',
      'openTime': '16.00-22.00 น.',
      'image': 'assets/images/market_sevongo.jpg',
      'tags': ['แฟชั่น', 'เสื้อผ้า'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  // ✅ โหลด role จาก session
  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role');
      _isLoading = false;
    });

    // ✅ ถ้าไม่มี session → แสดง popup แนะนำลงทะเบียน
    if (_userRole == null && mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _showRegisterSuggestionDialog();
      });
    }
  }

  // ══════════════════════════════════════════════════════════
  // ✅ Popup แนะนำลงทะเบียน (สำหรับ guest ที่ไม่มี session)
  // ══════════════════════════════════════════════════════════
  void _showRegisterSuggestionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6E9B4C), Color(0xFF8CBC63)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'บันทึกร้านที่ถูกใจ',
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Save Your Favorites',
                      style: GoogleFonts.kanit(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Body ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Info Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9EB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF8CBC63).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xFF8CBC63),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'ลงทะเบียนเพื่อบันทึกร้านที่ถูกใจ\n'
                              'และติดตามร้านโปรดของคุณได้ทุกที่!',
                              style: GoogleFonts.kanit(
                                fontSize: 13,
                                color: const Color(0xFF374151),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Benefits
                    _buildBenefit(Icons.favorite_rounded, 'บันทึกร้านที่ถูกใจ'),
                    _buildBenefit(Icons.notifications_rounded,
                        'รับแจ้งเตือนเมื่อร้านเปิด'),
                    _buildBenefit(
                        Icons.history_rounded, 'ดูประวัติร้านที่เคยเยี่ยมชม'),
                    const SizedBox(height: 20),

                    // Buttons
                    Row(
                      children: [
                        // ยกเลิก
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFFD1D5DB)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'ข้ามไปก่อน',
                                style: GoogleFonts.kanit(
                                  color: const Color(0xFF6B7280),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // ลงทะเบียน
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8CBC63),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SelectRolePage(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.person_add_rounded,
                                      size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'ลงทะเบียน',
                                    style: GoogleFonts.kanit(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF8CBC63).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF8CBC63), size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.kanit(
              fontSize: 13,
              color: const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // ✅ Popup รายละเอียดร้าน (ตามรูปแบบที่ส่งมา)
  // ══════════════════════════════════════════════════════════
  void _showShopDetailDialog(Map<String, dynamic> shop) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF8CBC63).withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header Wave ───────────────────────────
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF8CBC63),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          // ปุ่มกลับ
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                          ),
                          Text(
                            'ร้านค้า',
                            style: GoogleFonts.kanit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content ───────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF8CBC63).withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── รูปร้าน ───────────────────────
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                        child: SizedBox(
                          height: 160,
                          width: double.infinity,
                          child: Image.asset(
                            shop['image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 160,
                              color: const Color(0xFF8CBC63).withOpacity(0.2),
                              child: const Center(
                                child: Icon(
                                  Icons.storefront_rounded,
                                  color: Color(0xFF8CBC63),
                                  size: 60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ── ข้อมูลร้าน ────────────────────
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('ชื่อร้าน', shop['shopName'] ?? '-'),
                            _buildInfoRow('ประเภท', shop['category'] ?? '-'),
                            _buildInfoRow('วัน', shop['day'] ?? '-'),
                            _buildInfoRow('เวลา', shop['time'] ?? '-'),
                            _buildInfoRow(
                                'ระยะเวลา', shop['rentalPeriod'] ?? '-'),
                            _buildInfoRow('ประเภท', shop['category'] ?? '-'),
                            _buildInfoRow('วัน', shop['day'] ?? '-'),
                            _buildInfoRow('เวลา', shop['time'] ?? '-'),
                            _buildInfoRow('สถานะ', shop['status'] ?? '-',
                                isStatus: true,
                                isOpen: shop['isOpen'] ?? false),
                            const SizedBox(height: 16),

                            // ปุ่มย้อนกลับ
                            Center(
                              child: SizedBox(
                                width: 120,
                                height: 40,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFFD1D5DB)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'ย้อนกลับ',
                                    style: GoogleFonts.kanit(
                                      color: const Color(0xFF6B7280),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
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
      ),
    );
  }

  // ✅ Row แสดงข้อมูลแต่ละบรรทัด
  Widget _buildInfoRow(
    String label,
    String value, {
    bool isStatus = false,
    bool isOpen = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: GoogleFonts.kanit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF374151),
            ),
          ),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              decoration: BoxDecoration(
                color: isOpen
                    ? const Color(0xFF8CBC63).withOpacity(0.15)
                    : Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                value,
                style: GoogleFonts.kanit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isOpen ? const Color(0xFF6E9B4C) : Colors.grey,
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.kanit(
                  fontSize: 13,
                  color: const Color(0xFF374151),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // Navigation
  // ══════════════════════════════════════════════════════════
  Future<void> _navigateToProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    if (!mounted) return;
    if (role == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const SelectRolePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const GuestProfilePage()));
    }
  }

  void _navigateToPage(int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MarketListPage()));
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF8CBC63)),
        ),
      );
    }

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
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 22),
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

                  Expanded(
                    // ✅ แยก UI ตาม role
                    child: _userRole == null
                        ? _buildGuestView()
                        : _buildLoggedInView(),
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

  // ══════════════════════════════════════════════════════════
  // ✅ View สำหรับ Guest (ยังไม่ login)
  // ══════════════════════════════════════════════════════════
  Widget _buildGuestView() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MarketListPage()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
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
                  const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'ค้นหาร้านค้า...',
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
        const SizedBox(height: 20),

        // Empty State
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8CBC63).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      size: 40,
                      color: Color(0xFF8CBC63),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ยังไม่ได้เข้าสู่ระบบ',
                    style: GoogleFonts.kanit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ลงทะเบียนเพื่อบันทึกร้านที่ถูกใจ\nและติดตามร้านโปรดของคุณ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kanit(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8CBC63),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () => _showRegisterSuggestionDialog(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_add_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'ลงทะเบียนเพื่อเพิ่มร้านถูกใจ',
                            style: GoogleFonts.kanit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF8CBC63)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MarketListPage()),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_rounded,
                              color: Color(0xFF8CBC63), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'ค้นหาตลาดและร้านค้า',
                            style: GoogleFonts.kanit(
                              color: const Color(0xFF8CBC63),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  // ✅ View สำหรับ User ที่ Login แล้ว
  // ══════════════════════════════════════════════════════════
  Widget _buildLoggedInView() {
    return _favorites.isEmpty
        ? _buildEmpty()
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: _favorites.length,
            itemBuilder: (_, i) => _buildCard(_favorites[i]),
          );
  }

  // ── Empty State ───────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('ยังไม่มีร้านที่ถูกใจ',
              style: GoogleFonts.kanit(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8CBC63),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MarketListPage())),
            child: Text('ค้นหาตลาด',
                style: GoogleFonts.kanit(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Card ร้านค้า (กดแล้วขึ้น Popup) ─────────────────────
  Widget _buildCard(Map<String, dynamic> shop) {
    return GestureDetector(
      // ✅ กดแล้วแสดง Popup รายละเอียดร้าน
      onTap: () => _showShopDetailDialog(shop),
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
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // รูปร้าน
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: SizedBox(
                        width: 120,
                        height: 110,
                        child: Image.asset(
                          shop['image'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF8CBC63).withOpacity(0.15),
                            child: const Center(
                              child: Icon(
                                Icons.store_mall_directory_rounded,
                                color: Color(0xFF8CBC63),
                                size: 44,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ข้อมูลร้าน
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 60, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ร้าน',
                              style: GoogleFonts.kanit(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ระยะทาง : ${shop['distance']}',
                              style: GoogleFonts.kanit(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              'วันนี้ ${shop['openTime']}',
                              style: GoogleFonts.kanit(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Badge เปิด/ปิด มุมขวาบน
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildStatusBadge(shop['isOpen'] ?? false),
                ),
              ],
            ),
            // Tags
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Row(
                children: (shop['tags'] as List<String>)
                    .take(3)
                    .map((tag) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildTag(tag),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reusable Widgets ──────────────────────────────────────
  Widget _buildStatusBadge(bool isOpen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen ? const Color(0xFF8CBC63) : Colors.grey,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            isOpen ? 'เปิดอยู่' : 'ปิดแล้ว',
            style: GoogleFonts.kanit(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
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
    );
  }

  // ── Bottom Nav ────────────────────────────────────────────
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
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

// ── Wave Painter ──────────────────────────────────────────
class _TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8CBC63)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.75)
      ..quadraticBezierTo(
          size.width * 0.25, size.height, size.width * 0.5, size.height * 0.85)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.7, size.width, size.height * 0.9)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
