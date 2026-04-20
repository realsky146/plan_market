import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ✅ ลบ shared_preferences ออก ไม่ได้ใช้ในไฟล์นี้
import '../guest/market_list_page.dart';
import '../guest/market_detail_page.dart';
import '../../services/auth_service.dart';
import '../vendor/vendor_home.dart';
import '../guest/home_page.dart';
import '../market_owner/market_owner_home.dart';
import '../market_owner/market_pending_page.dart';
import '../super_admin/admin_home.dart';
import '../guest/profile_page.dart';

class SignInPage extends StatefulWidget {
  final String role;
  const SignInPage({super.key, required this.role});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String get _roleTitle {
    switch (widget.role) {
      case 'customer':
        return 'ลูกค้า';
      case 'vendor':
        return 'ร้านค้า';
      case 'market':
        return 'เจ้าของตลาด';
      case 'super_admin':
        return 'ผู้ดูแลระบบ';
      default:
        return widget.role;
    }
  }

  Future<void> _handleSignIn() async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty) {
      setState(() => _errorMsg = 'กรุณากรอกอีเมลและรหัสผ่าน');
      return;
    }

    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    try {
      final result = await AuthService().signIn(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
        role: widget.role,
      );

      if (!mounted) return;
      setState(() => _loading = false);

      if (result['success'] == true) {
        _navigateByRole(
          role: result['role'] ?? widget.role,
          status: result['status'] ?? 'active',
        );
      } else {
        setState(
          () => _errorMsg = result['message'] ?? 'เข้าสู่ระบบไม่สำเร็จ',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMsg = 'เกิดข้อผิดพลาดในการเชื่อมต่อ';
        });
      }
    }
  }

  // ── Route ตาม Role + Status ──────────────────────────────
  void _navigateByRole({required String role, required String status}) {
    Widget page;

    switch (role) {
      case 'super_admin':
        // ✅ ตรวจสอบชื่อ class ใน admin_home.dart
        page = const AdminHome(); // ← เปลี่ยนถ้าชื่อต่างกัน
        break;

      case 'market_owner':
      case 'market':
        // ✅ ตรวจสอบชื่อ class ใน market_owner_home.dart
        page = status == 'approved'
            ? const MarketOwnerHome() // ← เปลี่ยนถ้าชื่อต่างกัน
            : const MarketPendingPage();
        break;

      case 'vendor':
        // ✅ ตรวจสอบชื่อ class ใน vendor_home.dart
        page = const VendorHome(); // ← เปลี่ยนถ้าชื่อต่างกัน
        break;

      case 'customer':
      default:
        page = const HomePage(); // ← เปลี่ยนถ้าชื่อต่างกัน
        break;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
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
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Text(
                          'Sign in',
                          style: GoogleFonts.kanit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: Image.asset(
                              'assets/images/market.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.storefront_rounded,
                                size: 90,
                                color: Color(0xFF7AAA57),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8CBC63),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Sign in — $_roleTitle',
                              style: GoogleFonts.kanit(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_errorMsg != null) _buildErrorBox(),
                                _buildLabel('E-mail'),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _emailCtrl,
                                  hint: 'กรุณากรอกอีเมล...',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email_outlined,
                                ),
                                const SizedBox(height: 14),
                                _buildLabel('Password'),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _passCtrl,
                                  hint: 'กรุณากรอกรหัสผ่าน...',
                                  obscure: _obscure,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFFBDBDBD),
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscure = !_obscure,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'ลืมรหัสผ่าน?',
                                      style: GoogleFonts.kanit(
                                        fontSize: 13,
                                        color: const Color(0xFF8CBC63),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildTestHint(),
                                const SizedBox(height: 20),
                                _buildButtons(),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBox() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMsg!,
                style: GoogleFonts.kanit(color: Colors.red, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestHint() {
    String hintEmail = '';
    String hintPass = '123456';

    switch (widget.role) {
      case 'vendor':
        hintEmail = 'vendor@test.com';
        break;
      case 'customer':
        hintEmail = 'customer@test.com';
        break;
      case 'market':
        hintEmail = 'market@test.com';
        break;
      case 'super_admin':
        hintEmail = 'admin@planmarket.com';
        hintPass = 'admin1234';
        break;
    }

    if (hintEmail.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        setState(() {
          _emailCtrl.text = hintEmail;
          _passCtrl.text = hintPass;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF8CBC63).withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF8CBC63).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF8CBC63),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔑 Mock Account (กดเพื่อ autofill)',
                    style: GoogleFonts.kanit(
                      fontSize: 12,
                      color: const Color(0xFF6E9B4C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$hintEmail / $hintPass',
                    style: GoogleFonts.kanit(
                      fontSize: 12,
                      color: Colors.grey,
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

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 46,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ยกเลิก',
                style: GoogleFonts.kanit(color: const Color(0xFF6B7280)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8CBC63),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 2,
              ),
              onPressed: _loading ? null : _handleSignIn,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'เข้าสู่ระบบ',
                      style: GoogleFonts.kanit(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.kanit(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF374151),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscure = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.kanit(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.kanit(
          color: const Color(0xFFBDBDBD),
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color(0xFFBDBDBD), size: 20)
            : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF8CBC63),
            width: 1.5,
          ),
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
