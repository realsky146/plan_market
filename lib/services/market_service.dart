import 'mock_data.dart';

class MarketService {
  // ── ดึงตลาดทั้งหมด ────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getMarkets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // คืนเฉพาะตลาดที่ approved
    return MockData.markets.where((m) => m['status'] == 'approved').toList();
  }

  // ── ดึงคำขอรออนุมัติ (Admin ใช้) ─────────────────────────
  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.markets.where((m) => m['status'] == 'pending').toList();
  }

  // ── ดึงตลาดทั้งหมด (Admin ใช้ — รวม pending) ─────────────
  Future<List<Map<String, dynamic>>> getAllMarkets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(MockData.markets);
  }

  // ── อนุมัติตลาด ───────────────────────────────────────────
  Future<Map<String, dynamic>> approveMarket(String marketId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      final index = MockData.markets.indexWhere((m) => m['id'] == marketId);
      if (index == -1) {
        return {'success': false, 'message': 'ไม่พบตลาด'};
      }

      MockData.markets[index] = {
        ...MockData.markets[index],
        'status': 'approved',
      };

      // อัพเดต status ของ owner ด้วย
      final ownerId = MockData.markets[index]['ownerId'];
      final userIndex = MockData.users.indexWhere((u) => u['id'] == ownerId);
      if (userIndex != -1) {
        MockData.users[userIndex] = {
          ...MockData.users[userIndex],
          'status': 'approved',
        };
      }

      return {'success': true, 'message': 'อนุมัติตลาดสำเร็จ'};
    } catch (e) {
      return {'success': false, 'message': 'เกิดข้อผิดพลาด: $e'};
    }
  }

  // ── ปฏิเสธตลาด ────────────────────────────────────────────
  Future<Map<String, dynamic>> rejectMarket(
    String marketId, {
    String reason = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      final index = MockData.markets.indexWhere((m) => m['id'] == marketId);
      if (index == -1) {
        return {'success': false, 'message': 'ไม่พบตลาด'};
      }

      MockData.markets[index] = {
        ...MockData.markets[index],
        'status': 'rejected',
        'rejectReason': reason,
      };

      // อัพเดต status ของ owner
      final ownerId = MockData.markets[index]['ownerId'];
      final userIndex = MockData.users.indexWhere((u) => u['id'] == ownerId);
      if (userIndex != -1) {
        MockData.users[userIndex] = {
          ...MockData.users[userIndex],
          'status': 'rejected',
        };
      }

      return {'success': true, 'message': 'ปฏิเสธตลาดสำเร็จ'};
    } catch (e) {
      return {'success': false, 'message': 'เกิดข้อผิดพลาด: $e'};
    }
  }

  // ── ดึงตลาดตาม ID ─────────────────────────────────────────
  Future<Map<String, dynamic>?> getMarketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return MockData.markets.firstWhere((m) => m['id'] == id);
    } catch (_) {
      return null;
    }
  }

  // ── ดึงการจองของ vendor ───────────────────────────────────
  Future<List<Map<String, dynamic>>> getVendorBookings(String vendorId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.bookings.where((b) => b['vendorId'] == vendorId).toList();
  }
}
