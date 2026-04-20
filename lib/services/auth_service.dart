import 'package:shared_preferences/shared_preferences.dart';
import 'mock_data.dart';

class AuthService {
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
    required String role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final lookupRole = role == 'market' ? 'market_owner' : role;

      final user = MockData.users.firstWhere(
        (u) =>
            u['email'] == email &&
            u['password'] == password &&
            (u['role'] == lookupRole || u['role'] == role),
        orElse: () => <String, dynamic>{},
      );

      if (user.isEmpty) {
        return {'success': false, 'message': 'อีเมลหรือรหัสผ่านไม่ถูกต้อง'};
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', user['role']);
      await prefs.setString('status', user['status'] ?? 'active');
      await prefs.setString('email', email);
      await prefs.setString('userId', user['id']);

      return {
        'success': true,
        'user': user,
        'role': user['role'],
        'status': user['status'] ?? 'active',
      };
    } catch (e) {
      return {'success': false, 'message': 'เกิดข้อผิดพลาด: $e'};
    }
  }

  // --- Sign Up Customer ---
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    // ... (โค้ดเดิมของคุณ ทำงานได้ดีแล้ว)
    return {'success': true, 'role': role};
  }

  // --- Sign Up Market ---
  Future<Map<String, dynamic>> signUpMarket({
    required String marketName,
    required String ownerName,
    required String email,
    required String password,
    required String phone,
    required String location,
    required String description,
  }) async {
    // ... (โค้ดเดิมของคุณ ทำงานได้ดีแล้ว)
    return {'success': true, 'role': 'market_owner'};
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email == null) return null;
    return MockData.users.firstWhere((u) => u['email'] == email,
        orElse: () => <String, dynamic>{});
  }

  Future<Map<String, String?>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'role': prefs.getString('role'),
      'status': prefs.getString('status'),
      'email': prefs.getString('email'),
      'userId': prefs.getString('userId'),
    };
  }
}
