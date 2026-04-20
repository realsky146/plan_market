import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/guest/home_page.dart';
import 'features/guest/profile_page.dart';
import 'features/vendor/vendor_home.dart';
import 'features/market_owner/market_owner_home.dart';
import 'features/market_owner/market_pending_page.dart';
import 'features/super_admin/admin_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PlanMarketApp());
}

class PlanMarketApp extends StatelessWidget {
  const PlanMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(),
        useMaterial3: true,
      ),
      home: const SplashRouter(),
    );
  }
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    final status = prefs.getString('status') ?? 'active';

    if (!mounted) return;

    // ✅ ไม่มี session → HomePage (Guest)
    if (role == null) {
      _go(const HomePage());
      return;
    }

    switch (role) {
      case 'super_admin':
        _go(const AdminHome());
        break;

      case 'market_owner':
        if (status == 'approved') {
          _go(const MarketOwnerHome());
        } else if (status == 'pending') {
          _go(const MarketPendingPage());
        } else {
          // rejected → ล้าง session → HomePage
          await prefs.clear();
          _go(const HomePage());
        }
        break;

      case 'vendor':
        _go(const VendorHome());
        break;

      case 'customer':
        // ✅ customer → GuestProfilePage
        _go(const GuestProfilePage());
        break;

      default:
        _go(const HomePage());
    }
  }

  void _go(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8CBC63),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.store_mall_directory_rounded,
                size: 56,
                color: Color(0xFF8CBC63),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Plan Market',
              style: GoogleFonts.kanit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'บริหารจัดการตลาดนัด',
              style: GoogleFonts.kanit(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
