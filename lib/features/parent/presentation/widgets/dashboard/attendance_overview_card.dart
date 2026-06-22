
// features/parent/presentation/widgets/dashboard/attendance_overview_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

/// Compact attendance snapshot for the dashboard — mirrors the student
/// app's _MiniStat card visual language (colored icon block + value).
class AttendanceOverviewCard extends StatelessWidget {
  final int percent;
  final int present;
  final int absent;
  final VoidCallback? onTap;

  const AttendanceOverviewCard({
    super.key,
    required this.percent,
    required this.present,
    required this.absent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = percent >= 90
        ? PT.green
        : percent >= 75
            ? PT.orange
            : PT.red;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: PT.smallCard,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.event_available_rounded, color: color, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Attendance", style: PT.caption1(color: PT.labelTertiary)),
                  Text(
                    "$percent%",
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: PT.labelPrimary,
                    ),
                  ),
                  Text(
                    "$present present · $absent absent",
                    style: PT.caption2(color: PT.labelTertiary),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: PT.labelQuaternary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}