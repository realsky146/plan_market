import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
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
              // ===== Header โค้งสีเขียว =====
              SizedBox(
                height: 140,
                width: double.infinity,
                child: CustomPaint(painter: _TopWavePainter()),
              ),

              // ===== Content =====
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หัวข้อ Sign up
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 0, 0),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          // รูปตลาด
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
                          const SizedBox(height: 16),

                          // ปุ่ม Sign up (สีเขียว)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8CBC63),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ===== ฟอร์ม =====
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ชื่อบัญชี
                                _buildLabel('ชื่อบัญชี'),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _nameCtrl,
                                  hint: 'กรุณากรอกเบอร์โทรศัพท์...',
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 14),

                                // E-mail
                                _buildLabel('E-mail'),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _emailCtrl,
                                  hint: 'กรุณากรอกอีเมล...',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 14),

                                // Password
                                _buildLabel('Password'),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _passCtrl,
                                  hint: 'กรุณากรอกรหัสผ่าน...',
                                  obscure: _obscure,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFFBDBDBD),
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // เบอร์โทรศัพท์
                                _buildLabel('เบอร์โทรศัพท์'),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _phoneCtrl,
                                  hint: 'กรุณากรอกเบอร์โทรศัพท์...',
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 28),

                                // ===== ปุ่ม ยกเลิก + สมัครบัญชี =====
                                Row(
                                  children: [
                                    // ปุ่มยกเลิก → กลับ HomePage
                                    Expanded(
                                      child: SizedBox(
                                        height: 44,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Color(0xFFD1D5DB)),
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24)),
                                          ),
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const HomePage()),
                                            );
                                          },
                                          child: const Text(
                                            'ยกเลิก',
                                            style: TextStyle(
                                              color: Color(0xFF6B7280),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // ปุ่มสมัครบัญชี → ไปหน้า SignIn
                                    Expanded(
                                      child: SizedBox(
                                        height: 44,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF8CBC63),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24)),
                                          ),
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const SignInPage()),
                                            );
                                          },
                                          child: const Text(
                                            'สมัครบัญชี',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ===== Bottom Nav =====
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

  // ===== Label =====
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  // ===== TextField =====
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFBDBDBD),
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8CBC63), width: 1.5),
        ),
      ),
    );
  }

  // ===== Bottom Nav =====
  Widget _buildBottomNav(BuildContext context) {
    final items = [
      {'icon': Icons.favorite_border_rounded, 'label': 'ถูกใจ'},
      {'icon': Icons.storefront_outlined, 'label': 'ตลาด'},
      {'icon': Icons.home_rounded, 'label': 'หน้าแรก'},
      {'icon': Icons.shopping_cart_outlined, 'label': 'ร้านค้า'},
    ];

    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFF8CBC63),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  ...List.generate(items.length, (i) {
                    final icon = items[i]['icon'] as IconData;
                    final label = items[i]['label'] as String;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (i == 2) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()),
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, color: Colors.white, size: 22),
                            const SizedBox(height: 2),
                            Text(label,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(width: 64),
                ],
              ),
            ),
          ),

          // ปุ่มกลม โปรไฟล์
          Positioned(
            right: 12,
            bottom: 6,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF6E9B4C),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: const Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Top Wave Painter =====
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
