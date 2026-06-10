import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final double attendancePercent;
  final int present;
  final int absent;
  final int late;

  const AttendanceSummaryCard({
    super.key,
    this.attendancePercent = 92,
    this.present = 136,
    this.absent = 8,
    this.late = 4,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (attendancePercent / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _D.widgetCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _D.tintGreen,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.fact_check_rounded,
                  color: _D.green,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attendance', style: _D.headline()),
                    Text('Today across all batches', style: _D.caption1()),
                  ],
                ),
              ),
              Text(
                '${attendancePercent.round()}%',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _D.green,
                  letterSpacing: -.45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: _D.green.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _D.green,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _MetricPill(
                  label: 'Present',
                  value: '$present',
                  color: _D.green,
                  tint: _D.tintGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricPill(
                  label: 'Absent',
                  value: '$absent',
                  color: _D.red,
                  tint: _D.tintRed,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricPill(
                  label: 'Late',
                  value: '$late',
                  color: _D.orange,
                  tint: _D.tintOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color tint;

  const _MetricPill({
    required this.label,
    required this.value,
    required this.color,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -.25,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: _D.caption1()),
        ],
      ),
    );
  }
}

class _D {
  static const green = Color(0xFF46A800);
  static const orange = Color(0xFFF59000);
  static const red = Color(0xFFEC3A3A);
  static const bgElevated = Color(0xFFFFFAF4);
  static const tintGreen = Color(0xFFF1FBE8);
  static const tintOrange = Color(0xFFFFF1E4);
  static const tintRed = Color(0xFFFFEEEE);
  static const labelPrimary = Color(0xFF1C1C1E);
  static const labelTertiary = Color(0xFF8E8E93);

  static TextStyle headline({Color? color}) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color ?? labelPrimary,
    letterSpacing: -.24,
  );

  static TextStyle caption1({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: color ?? labelTertiary,
    letterSpacing: .07,
  );

  static BoxDecoration get widgetCard => BoxDecoration(
    color: bgElevated,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .06),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: .03),
        blurRadius: 6,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
