
// features/parent/presentation/widgets/fees/fee_summary_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

class FeeSummaryCard extends StatelessWidget {
  final num totalPaid;
  final num totalDue;

  const FeeSummaryCard({
    super.key,
    required this.totalPaid,
    required this.totalDue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PT.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Paid", style: PT.caption1(color: Colors.white70)),
                const SizedBox(height: 4),
                Text(
                  "₹${totalPaid.toStringAsFixed(0)}",
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: .25)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Outstanding", style: PT.caption1(color: Colors.white70)),
                const SizedBox(height: 4),
                Text(
                  "₹${totalDue.toStringAsFixed(0)}",
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: totalDue > 0 ? PT.yellow : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}