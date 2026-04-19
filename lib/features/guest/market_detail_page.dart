import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StallInfo {
  final String stallId;
  final bool isBooked;
  final String shopName;
  final String boothNo;

  const StallInfo({
    required this.stallId,
    required this.isBooked,
    this.shopName = '',
    this.boothNo = '',
  });
}

class MarketDetailPage extends StatefulWidget {
  final dynamic market;
  const MarketDetailPage({super.key, required this.market});

  @override
  State<MarketDetailPage> createState() => _MarketDetailPageState();
}

class _MarketDetailPageState extends State<MarketDetailPage> {
  late List<List<StallInfo>> _stallRows;

  @override
  void initState() {
    super.initState();
    _stallRows = _generateStallData();
  }

  List<List<StallInfo>> _generateStallData() {
    List<List<StallInfo>> rows = [];
    for (int r = 1; r <= 12; r++) {
      List<StallInfo> row = [];
      for (int c = 1; c <= 12; c++) {
        bool booked = false;
        // จัดสีแดงโซนกลางและจุดอื่นๆ ตามภาพเป๊ะๆ
        if (c >= 5 && c <= 8) booked = true;
        if (r == 5 && c == 6) booked = false; // จุดเขียวในโซนแดง
        if (r >= 8 && r <= 10 && (c == 9 || c == 10)) booked = true;
        if (r == 10 && c == 10) booked = false;

        row.add(StallInfo(
          stallId: 'L$r-$c',
          isBooked: booked,
          shopName: booked ? 'ร้านค้าตัวอย่าง' : '',
          boothNo: booked ? 'A$r-$c' : '',
        ));
      }
      rows.add(row);
    }
    return rows;
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
          child: Column(
            children: [
              _buildHeaderWithImage(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text('ถ.พหล',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      _buildRoadDivider(),
                      const SizedBox(height: 12),
                      _buildGateLabel('ประตู 1'),
                      const SizedBox(height: 25),

                      // ตารางล็อก 12x12 แบ่งกลุ่มตามภาพ
                      ..._stallRows.map((row) => _buildStallRow(row)).toList(),

                      const SizedBox(height: 25),
                      _buildGateLabel('ประตู 2'),
                      const SizedBox(height: 12),
                      _buildRoadDivider(),
                      const SizedBox(height: 4),
                      const Text('ถ.แจ้งวัฒนะ',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
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

  Widget _buildHeaderWithImage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: [
              // ส่วนข้อมูลตลาด
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // รูปภาพตลาด
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 130,
                        height: 130,
                        color: const Color(0xFFE5E7EB),
                        child: Image.network(
                          'https://via.placeholder.com/300', // ใส่ URL รูปจริงที่นี่
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.storefront,
                                  size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // รายละเอียด
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.market?.name ?? 'ตลาดจตุจักร(โซนกลางคืน)',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text('ระยะทาง : จตุจักร 1.2กม.',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13)),
                          Text('วันนี้ 17.00-23.00 น.',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13)),
                          const SizedBox(height: 12),
                          Row(
                            children: const [
                              Icon(Icons.location_on,
                                  size: 18, color: Color(0xFF22C55E)),
                              SizedBox(width: 4),
                              Text('แผนที่',
                                  style: TextStyle(
                                      color: Color(0xFF22C55E),
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // ปุ่มย้อนกลับแบบ Overlay บนรูป
              Positioned(
                top: 24,
                left: 24,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          // Legend ว่าง/จองแล้ว
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem(const Color(0xFF22C55E), 'ว่าง'),
                const SizedBox(width: 40),
                _legendItem(const Color(0xFFEF4444), 'จองแล้ว'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStallRow(List<StallInfo> stalls) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStallGroup(stalls.sublist(0, 4)),
          _buildStallGroup(stalls.sublist(4, 8)),
          _buildStallGroup(stalls.sublist(8, 12)),
        ],
      ),
    );
  }

  Widget _buildStallGroup(List<StallInfo> group) {
    return Row(
      children: [
        _buildPair(group[0], group[1]),
        const SizedBox(width: 12),
        _buildPair(group[2], group[3]),
      ],
    );
  }

  Widget _buildPair(StallInfo s1, StallInfo s2) {
    return Row(
      children: [
        _buildStallDot(s1),
        const SizedBox(width: 5),
        _buildStallDot(s2),
      ],
    );
  }

  Widget _buildStallDot(StallInfo stall) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color:
            stall.isBooked ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 0.5),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildGateLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD1D5DB),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRoadDivider() {
    return Container(
      height: 8,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          color: const Color(0xFF9CA3AF),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
