import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorBookingPage extends StatefulWidget {
  final Map<String, dynamic> market;

  const VendorBookingPage(
      {super.key,
      required this.market,
      required String marketId,
      required String marketName});

  @override
  State<VendorBookingPage> createState() => _VendorBookingPageState();
}

class _VendorBookingPageState extends State<VendorBookingPage> {
  DateTime _selectedDate = DateTime.now();

  // ล็อคที่เลือกอยู่
  final Set<String> _selectedStalls = {};

  // ── Mock Layout Data ────────────────────────────────────
  // status: 'available' | 'pending' | 'booked'
  late final List<Map<String, dynamic>> _zones = [
    {
      'zoneName': 'ประตู 1',
      'rows': [
        _generateRowData('A', 10,
            {'A3': 'booked', 'A4': 'booked', 'A5': 'pending', 'A6': 'pending'}),
        _generateRowData('B', 10,
            {'B3': 'booked', 'B4': 'pending', 'B5': 'pending', 'B6': 'booked'}),
        _generateRowData('C', 10,
            {'C3': 'pending', 'C4': 'booked', 'C5': 'booked', 'C6': 'pending'}),
        _generateRowData('D', 10,
            {'D3': 'pending', 'D4': 'pending', 'D5': 'booked', 'D6': 'booked'}),
        _generateRowData('E', 10,
            {'E3': 'booked', 'E4': 'pending', 'E5': 'pending', 'E6': 'booked'}),
        _generateRowData('F', 10,
            {'F3': 'booked', 'F4': 'booked', 'F5': 'pending', 'F6': 'pending'}),
        _generateRowData('G', 10,
            {'G3': 'pending', 'G4': 'booked', 'G5': 'booked', 'G6': 'pending'}),
        _generateRowData('H', 10,
            {'H3': 'booked', 'H4': 'pending', 'H5': 'booked', 'H6': 'pending'}),
      ],
    },
    {
      'zoneName': 'ประตู 2',
      'rows': [
        _generateRowData('I', 10, {'I3': 'booked', 'I5': 'pending'}),
        _generateRowData('J', 10, {'J4': 'pending', 'J6': 'booked'}),
      ],
    },
  ];

  // แก้ไข: เปลี่ยนชื่อจาก _buildRow เป็น _generateRowData เพื่อไม่ให้ซ้ำกับ Widget
  static List<Map<String, dynamic>> _generateRowData(
    String rowLetter,
    int count,
    Map<String, String> overrides,
  ) {
    return List.generate(count, (i) {
      final id = '$rowLetter${i + 1}';
      return {
        'id': id,
        'status': overrides[id] ?? 'available',
      };
    });
  }

  // ── สีของแต่ละ status ─────────────────────────────────
  Color _stallColor(String status, bool isSelected) {
    if (isSelected) return const Color(0xFF2196F3); // น้ำเงิน = กำลังเลือก
    switch (status) {
      case 'available':
        return const Color(0xFF66BB6A); // เขียว
      case 'pending':
        return const Color(0xFFFFB300); // ส้มเหลือง
      case 'booked':
        return const Color(0xFFE53935); // แดง
      default:
        return Colors.grey;
    }
  }

  void _onStallTap(Map<String, dynamic> stall) {
    if (stall['status'] != 'available') return; // กดได้เฉพาะว่าง
    setState(() {
      if (_selectedStalls.contains(stall['id'])) {
        _selectedStalls.remove(stall['id']);
      } else {
        _selectedStalls.add(stall['id']);
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8CBC63),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _confirmBooking() {
    if (_selectedStalls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'กรุณาเลือกล็อคที่ต้องการจอง',
            style: GoogleFonts.kanit(),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    _showConfirmDialog();
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '✅ ยืนยันการจอง',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.market['name'] ?? 'ตลาด',
              style: GoogleFonts.kanit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'วันที่: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: GoogleFonts.kanit(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'ล็อคที่เลือก: ${_selectedStalls.join(', ')}',
              style: GoogleFonts.kanit(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'จำนวน: ${_selectedStalls.length} ล็อค',
              style: GoogleFonts.kanit(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'ราคารวม: ฿${_selectedStalls.length * (widget.market['pricePerDay'] ?? 300)}',
              style: GoogleFonts.kanit(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8CBC63),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.kanit(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8CBC63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _showSuccessSnackbar();
            },
            child: Text(
              'ยืนยัน',
              style: GoogleFonts.kanit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar() {
    setState(() => _selectedStalls.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🎉 ส่งคำขอจองสำเร็จ รอเจ้าของตลาดอนุมัติ',
          style: GoogleFonts.kanit(),
        ),
        backgroundColor: const Color(0xFF8CBC63),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Column(
        children: [
          _buildHeader(),
          _buildDatePicker(),
          _buildLegend(),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._zones.map((zone) => _buildZone(zone)),
                  _buildBottomNote(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ══════════════════════════════════════════════════════════
  // Widget Builders
  // ══════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 160,
          color: const Color(0xFF2E7D32),
          child: widget.market['bannerUrl'] != null
              ? Image.network(
                  widget.market['bannerUrl'],
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                )
              : _buildMockBanner(),
        ),
        Positioned(
          top: 40,
          left: 12,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'จอง',
                    style: GoogleFonts.kanit(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.92)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.market['name'] ?? 'ตลาด',
                  style: GoogleFonts.kanit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMockBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF388E3C), Color(0xFF66BB6A)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store_mall_directory_rounded,
                size: 48, color: Colors.white70),
            Text(
              widget.market['name'] ?? 'ตลาด',
              style: GoogleFonts.kanit(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: GoogleFonts.kanit(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_month_rounded,
                    size: 18, color: Color(0xFF8CBC63)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem(const Color(0xFF66BB6A), 'ว่าง'),
          const SizedBox(width: 20),
          _legendItem(const Color(0xFFFFB300), 'รอชำระเงิน'),
          const SizedBox(width: 20),
          _legendItem(const Color(0xFFE53935), 'จองแล้ว'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.kanit(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildZone(Map<String, dynamic> zone) {
    // แก้ไข: รับ List ของ List
    final rows = zone['rows'] as List<List<Map<String, dynamic>>>;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFBDBDBD))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  zone['zoneName'],
                  style: GoogleFonts.kanit(fontSize: 12, color: Colors.grey),
                ),
              ),
              const Expanded(child: Divider(color: Color(0xFFBDBDBD))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            // แก้ไขจุดนี้: ลบ as String ออก
            children: rows.map((row) => _buildRow(row)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(List<Map<String, dynamic>> stalls) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: stalls.map((stall) {
          final isSelected = _selectedStalls.contains(stall['id']);
          final color = _stallColor(stall['status'], isSelected);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () => _onStallTap(stall),
              child: Container(
                width: isSelected ? 28 : 24,
                height: isSelected ? 28 : 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFBDBDBD))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('ก.แจ้งวัตถุประสงค์',
                style: GoogleFonts.kanit(fontSize: 12, color: Colors.grey)),
          ),
          const Expanded(child: Divider(color: Color(0xFFBDBDBD))),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final totalPrice =
        _selectedStalls.length * (widget.market['pricePerDay'] ?? 300);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedStalls.isEmpty
                      ? 'ยังไม่ได้เลือกล็อค'
                      : 'เลือก ${_selectedStalls.length} ล็อค',
                  style: GoogleFonts.kanit(fontSize: 13, color: Colors.grey),
                ),
                if (_selectedStalls.isNotEmpty)
                  Text('฿$totalPrice',
                      style: GoogleFonts.kanit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8CBC63))),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _selectedStalls.isEmpty ? null : _confirmBooking,
            child: Text('จองล็อค', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }
}
