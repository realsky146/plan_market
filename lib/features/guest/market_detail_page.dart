import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketDetailPage extends StatefulWidget {
  final Map<String, dynamic> market;

  const MarketDetailPage({super.key, required this.market});

  @override
  State<MarketDetailPage> createState() => _MarketDetailPageState();
}

class _MarketDetailPageState extends State<MarketDetailPage> {
  // Mock ผังล็อค
  final List<Map<String, dynamic>> _stalls = List.generate(
    30,
    (i) => {
      'id': 'S${(i + 1).toString().padLeft(2, '0')}',
      'status': i % 5 == 0
          ? 'booked'
          : i % 4 == 0
              ? 'pending'
              : 'available',
    },
  );

  Color _stallColor(String status) {
    switch (status) {
      case 'available':
        return const Color(0xFF66BB6A);
      case 'pending':
        return const Color(0xFFFFB300);
      case 'booked':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final market = widget.market;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        body: SafeArea(
          child: Column(
            children: [
              // ── Header ─────────────────────────────────
              _buildHeader(context, market),

              // ── Legend ─────────────────────────────────
              _buildLegend(),

              // ── Stall Grid ─────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildZoneLabel('โซน A'),
                      const SizedBox(height: 8),
                      _buildStallGrid(),
                      const SizedBox(height: 16),
                      _buildZoneLabel('โซน B'),
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

  Widget _buildHeader(BuildContext context, Map<String, dynamic> market) {
    return Stack(
      children: [
        // Banner
        Container(
          height: 160,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.store_mall_directory_rounded,
              size: 60,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ),

        // Back Button
        Positioned(
          top: 12,
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
                  const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'กลับ',
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Market Info (ด้านขวา)
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(12),
            color: Colors.white.withOpacity(0.92),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  market['name'] ?? 'ตลาด',
                  style: GoogleFonts.kanit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '📍 ${market['location'] ?? '-'}',
                  style: GoogleFonts.kanit(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '🕐 ${market['openTime'] ?? '-'}',
                  style: GoogleFonts.kanit(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFF8CBC63),
                      size: 16,
                    ),
                    Text(
                      ' แผนที่',
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: const Color(0xFF8CBC63),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
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
          style: GoogleFonts.kanit(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildZoneLabel(String label) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFBDBDBD))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: GoogleFonts.kanit(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFBDBDBD))),
      ],
    );
  }

  Widget _buildStallGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: _stalls.length,
      itemBuilder: (_, i) {
        final stall = _stalls[i];
        return Container(
          decoration: BoxDecoration(
            color: _stallColor(stall['status']),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
