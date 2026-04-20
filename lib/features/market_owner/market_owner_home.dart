import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_service.dart';
import '../auth/select_role_page.dart'; // ✅ แก้: ไป SelectRolePage แทน LoginPage(role:'')

class MarketOwnerHome extends StatefulWidget {
  const MarketOwnerHome({super.key});

  @override
  State<MarketOwnerHome> createState() => _MarketOwnerHomeState();
}

class _MarketOwnerHomeState extends State<MarketOwnerHome> {
  int _currentIndex = 0;

  final _pages = const [
    _DashboardTab(),
    _StallLayoutTab(),
    _BookingTab(),
    _VendorTab(),
    _BroadcastTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        body: _pages[_currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF8CBC63).withOpacity(0.2),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: Color(0xFF8CBC63)),
              label: 'แดชบอร์ด',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map, color: Color(0xFF8CBC63)),
              label: 'ผังตลาด',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment, color: Color(0xFF8CBC63)),
              label: 'การจอง',
            ),
            NavigationDestination(
              icon: Icon(Icons.store_outlined),
              selectedIcon: Icon(Icons.store, color: Color(0xFF8CBC63)),
              label: 'ร้านค้า',
            ),
            NavigationDestination(
              icon: Icon(Icons.campaign_outlined),
              selectedIcon: Icon(Icons.campaign, color: Color(0xFF8CBC63)),
              label: 'ประกาศ',
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Tab 1: Dashboard
// ══════════════════════════════════════════════════════════
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _sectionTitle('รายรับวันนี้'),
                  const SizedBox(height: 8),
                  _buildRevenueCard(),
                  const SizedBox(height: 16),
                  _sectionTitle('คำขอจองล่าสุด'),
                  const SizedBox(height: 8),
                  ...List.generate(3, (i) => _bookingRequestCard(i)),
                  const SizedBox(height: 16),
                  _sectionTitle('ประกาศด่วน'),
                  const SizedBox(height: 8),
                  _broadcastCard(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF8CBC63),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'สวัสดี เจ้าของตลาด 👋',
                    style: GoogleFonts.kanit(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'ตลาดจตุจักร',
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // ✅ แก้: Logout ไป SelectRolePage
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
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

                  if (confirm == true && context.mounted) {
                    await AuthService().logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SelectRolePage(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statCard('แผงทั้งหมด', '120', Icons.grid_view, Colors.white),
              const SizedBox(width: 12),
              _statCard(
                'ว่าง',
                '45',
                Icons.check_circle_outline,
                const Color(0xFFDFF7E6),
                textColor: const Color(0xFF22C55E),
              ),
              const SizedBox(width: 12),
              _statCard(
                'รออนุมัติ',
                '8',
                Icons.pending_outlined,
                const Color(0xFFFFF3CD),
                textColor: const Color(0xFFFFB000),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String label,
    String value,
    IconData icon,
    Color bgColor, {
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              bgColor == Colors.white ? Colors.white.withOpacity(0.2) : bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.kanit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.kanit(
                fontSize: 10,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'รายรับรวม',
                style: GoogleFonts.kanit(
                  color: const Color(0xFF6B7280),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '฿12,500',
                style: GoogleFonts.kanit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8CBC63),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ค้างชำระ: 3 ราย',
                style: GoogleFonts.kanit(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8CBC63).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.payments_outlined,
              color: Color(0xFF8CBC63),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.kanit(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF374151),
      ),
    );
  }

  Widget _bookingRequestCard(int i) {
    final shops = ['ร้านอาชียะ', 'ร้านมานี', 'ร้านสมชาย'];
    final stalls = ['B01', 'A03', 'C02'];
    final types = ['รายวัน', 'รายเดือน', 'รายสัปดาห์'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF8CBC63),
            child: Icon(Icons.store, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shops[i],
                  style: GoogleFonts.kanit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'แผง ${stalls[i]} • ${types[i]}',
                  style: GoogleFonts.kanit(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'รออนุมัติ',
              style: GoogleFonts.kanit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB45309),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _broadcastCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8CBC63).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.campaign,
              color: Color(0xFF8CBC63),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'ส่งประกาศถึงผู้เช่าทุกคน',
              style: GoogleFonts.kanit(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Tab 2: Stall Layout
// ══════════════════════════════════════════════════════════
class _StallLayoutTab extends StatefulWidget {
  const _StallLayoutTab();

  @override
  State<_StallLayoutTab> createState() => _StallLayoutTabState();
}

class _StallLayoutTabState extends State<_StallLayoutTab> {
  String _selectedZone = 'โซน A';
  final _zones = ['โซน A', 'โซน B', 'โซน C', 'โซน D'];

  final _stalls = {
    'โซน A': List.generate(
      20,
      (i) => {
        'id': 'A${(i + 1).toString().padLeft(2, '0')}',
        'isBooked': i % 3 == 0,
        'shopName': i % 3 == 0 ? 'ร้าน ${i + 1}' : '',
      },
    ),
    'โซน B': List.generate(
      15,
      (i) => {
        'id': 'B${(i + 1).toString().padLeft(2, '0')}',
        'isBooked': i % 4 == 0,
        'shopName': i % 4 == 0 ? 'ร้าน ${i + 1}' : '',
      },
    ),
    'โซน C': List.generate(
      18,
      (i) => {
        'id': 'C${(i + 1).toString().padLeft(2, '0')}',
        'isBooked': i % 2 == 0,
        'shopName': i % 2 == 0 ? 'ร้าน ${i + 1}' : '',
      },
    ),
    'โซน D': List.generate(
      12,
      (i) => {
        'id': 'D${(i + 1).toString().padLeft(2, '0')}',
        'isBooked': i % 5 == 0,
        'shopName': i % 5 == 0 ? 'ร้าน ${i + 1}' : '',
      },
    ),
  };

  @override
  Widget build(BuildContext context) {
    final stalls = _stalls[_selectedZone] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'ผังตลาด',
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF8CBC63),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Legend
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem(const Color(0xFF22C55E), 'ว่าง'),
                const SizedBox(width: 24),
                _legendItem(const Color(0xFFEF4444), 'จองแล้ว'),
              ],
            ),
          ),
          // Zone tabs
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: _zones.map((z) {
                final selected = z == _selectedZone;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      z,
                      style: GoogleFonts.kanit(
                        color: selected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: selected,
                    selectedColor: const Color(0xFF8CBC63),
                    onSelected: (_) => setState(() => _selectedZone = z),
                  ),
                );
              }).toList(),
            ),
          ),
          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemCount: stalls.length,
              itemBuilder: (_, i) {
                final stall = stalls[i];
                final isBooked = stall['isBooked'] as bool;
                return GestureDetector(
                  onTap: () => _showStallInfo(stall),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isBooked
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showStallInfo(Map<String, dynamic> stall) {
    final isBooked = stall['isBooked'] as bool;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isBooked
                        ? const Color(0xFFFEE2E2)
                        : const Color(0xFFDFF7E6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isBooked ? Icons.store : Icons.store_outlined,
                    color: isBooked
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF22C55E),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'แผง ${stall['id']}',
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            if (isBooked) ...[
              _infoRow(Icons.store, 'ร้านค้า', stall['shopName']),
              const SizedBox(height: 10),
              _infoRow(Icons.grid_view, 'บูธ', stall['id']),
              const SizedBox(height: 10),
              _infoRow(Icons.location_on, 'โซน', _selectedZone),
            ] else
              Center(
                child: Text(
                  'แผงนี้ว่างอยู่',
                  style: GoogleFonts.kanit(
                    color: const Color(0xFF22C55E),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CBC63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('ปิด', style: GoogleFonts.kanit()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, dynamic value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Text(
          '$label : ',
          style: GoogleFonts.kanit(
            color: const Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
        Text(
          value?.toString() ?? '',
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.kanit(fontSize: 13)),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// Tab 3: Booking Management
// ══════════════════════════════════════════════════════════
class _BookingTab extends StatefulWidget {
  const _BookingTab();

  @override
  State<_BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<_BookingTab> {
  final _requests = [
    {
      'shop': 'ร้านอาชียะ',
      'stall': 'B01',
      'type': 'รายวัน',
      'date': '27 ก.พ. 2026',
      'status': 'pending',
    },
    {
      'shop': 'ร้านมานี',
      'stall': 'A03',
      'type': 'รายเดือน',
      'date': 'มี.ค. 2026',
      'status': 'pending',
    },
    {
      'shop': 'ร้านสมชาย',
      'stall': 'C02',
      'type': 'รายสัปดาห์',
      'date': '1-7 มี.ค. 2026',
      'status': 'approved',
    },
    {
      'shop': 'ร้านวิไล',
      'stall': 'D05',
      'type': 'รายวัน',
      'date': '28 ก.พ. 2026',
      'status': 'rejected',
    },
  ];

  void _updateStatus(int index, String status) {
    setState(() => _requests[index]['status'] = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'การจองแผง',
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF8CBC63),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _requests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final r = _requests[i];
          final isPending = r['status'] == 'pending';
          final isApproved = r['status'] == 'approved';

          Color statusColor;
          String statusText;
          Color statusBg;

          if (isPending) {
            statusColor = const Color(0xFFB45309);
            statusBg = const Color(0xFFFFF3CD);
            statusText = 'รออนุมัติ';
          } else if (isApproved) {
            statusColor = const Color(0xFF0F7A36);
            statusBg = const Color(0xFFDFF7E6);
            statusText = 'อนุมัติแล้ว';
          } else {
            statusColor = const Color(0xFFB91C1C);
            statusBg = const Color(0xFFFEE2E2);
            statusText = 'ปฏิเสธแล้ว';
          }

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
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
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF8CBC63),
                      child: Icon(Icons.store, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r['shop']!,
                            style: GoogleFonts.kanit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'แผง ${r['stall']} • ${r['type']}',
                            style: GoogleFonts.kanit(
                              color: const Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.kanit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      r['date']!,
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                if (isPending) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFEF4444)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _updateStatus(i, 'rejected'),
                          child: Text(
                            'ปฏิเสธ',
                            style: GoogleFonts.kanit(
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8CBC63),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _updateStatus(i, 'approved'),
                          child: Text('อนุมัติ', style: GoogleFonts.kanit()),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Tab 4: Vendor Management
// ══════════════════════════════════════════════════════════
class _VendorTab extends StatelessWidget {
  const _VendorTab();

  static const _vendors = [
    {'name': 'ร้านอาชียะ', 'type': 'อาหาร', 'stall': 'B01', 'score': 92},
    {'name': 'ร้านมานี', 'type': 'เสื้อผ้า', 'stall': 'A03', 'score': 75},
    {'name': 'ร้านสมชาย', 'type': 'มือสอง', 'stall': 'C02', 'score': 45},
    {'name': 'ร้านวิไล', 'type': 'ของใช้', 'stall': 'D05', 'score': 30},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'ร้านค้าในตลาด',
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF8CBC63),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _vendors.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final v = _vendors[i];
          final score = v['score'] as int;
          final scoreColor = score >= 80
              ? const Color(0xFF22C55E)
              : score >= 60
                  ? const Color(0xFFFFB000)
                  : const Color(0xFFEF4444);

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
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
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: scoreColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$score',
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: scoreColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v['name'] as String,
                        style: GoogleFonts.kanit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${v['type']} • แผง ${v['stall']}',
                        style: GoogleFonts.kanit(
                          color: const Color(0xFF6B7280),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (score < 60)
                      IconButton(
                        icon: const Icon(
                          Icons.warning_amber,
                          color: Color(0xFFFFB000),
                          size: 20,
                        ),
                        onPressed: () => _showWarning(context, v),
                      ),
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: Color(0xFF6B7280),
                        size: 20,
                      ),
                      onPressed: () => _showDetail(context, v),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showWarning(BuildContext context, Map<String, Object> v) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('ส่งคำเตือน', style: GoogleFonts.kanit()),
        content: Text(
          'ส่งคำเตือนไปยัง ${v['name']}?',
          style: GoogleFonts.kanit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8CBC63),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'ส่งคำเตือนถึง ${v['name']} แล้ว',
                    style: GoogleFonts.kanit(),
                  ),
                  backgroundColor: const Color(0xFF8CBC63),
                ),
              );
            },
            child: Text('ส่ง', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Map<String, Object> v) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              v['name'] as String,
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _infoRow('ประเภท', v['type'] as String),
            const SizedBox(height: 8),
            _infoRow('แผง', v['stall'] as String),
            const SizedBox(height: 8),
            _infoRow('คะแนน', '${v['score']}/100'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CBC63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('ปิด', style: GoogleFonts.kanit()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: GoogleFonts.kanit(
            color: const Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// Tab 5: Broadcast
// ══════════════════════════════════════════════════════════
class _BroadcastTab extends StatefulWidget {
  const _BroadcastTab();

  @override
  State<_BroadcastTab> createState() => _BroadcastTabState();
}

class _BroadcastTabState extends State<_BroadcastTab> {
  final _msgCtrl = TextEditingController();
  String _target = 'ทุกคนในตลาด';

  final _targets = ['ทุกคนในตลาด', 'ผู้เช่าวันนี้', 'เฉพาะโซน A', 'เฉพาะโซน B'];

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'ส่งประกาศ',
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF8CBC63),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'ส่งถึง',
            style: GoogleFonts.kanit(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _target,
                isExpanded: true,
                style: GoogleFonts.kanit(),
                items: _targets
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t, style: GoogleFonts.kanit()),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _target = v!),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ข้อความ',
            style: GoogleFonts.kanit(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _msgCtrl,
            maxLines: 5,
            style: GoogleFonts.kanit(),
            decoration: InputDecoration(
              hintText: 'พิมพ์ข้อความประกาศ...',
              hintStyle: GoogleFonts.kanit(color: const Color(0xFFBDBDBD)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
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
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8CBC63),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.send),
              label: Text(
                'ส่งประกาศ',
                style: GoogleFonts.kanit(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                if (_msgCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'กรุณากรอกข้อความ',
                        style: GoogleFonts.kanit(),
                      ),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'ส่งประกาศถึง "$_target" แล้ว',
                      style: GoogleFonts.kanit(),
                    ),
                    backgroundColor: const Color(0xFF8CBC63),
                  ),
                );
                _msgCtrl.clear();
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ประกาศล่าสุด',
            style: GoogleFonts.kanit(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            2,
            (i) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ประกาศ',
                        style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        i == 0 ? 'เมื่อกี้' : 'เมื่อวาน',
                        style: GoogleFonts.kanit(
                          fontSize: 11,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    i == 0
                        ? 'วันนี้ตลาดปิดเวลา 22:00 น.'
                        : 'พรุ่งนี้มีการซ่อมแซมระบบไฟ',
                    style: GoogleFonts.kanit(
                      color: const Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
