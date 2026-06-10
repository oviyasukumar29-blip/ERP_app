import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignmentSummaryCard extends StatelessWidget {
  final int pendingReview;
  final int gradedToday;
  final int draftsReady;

  const AssignmentSummaryCard({
    super.key,
    this.pendingReview = 24,
    this.gradedToday = 18,
    this.draftsReady = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _D.widgetCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Assignments', style: _D.title3())),
              Text('Review queue', style: _D.subheadline(color: _D.blue)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _AssignmentMetric(
                  icon: Icons.pending_actions_rounded,
                  value: '$pendingReview',
                  label: 'Pending',
                  color: _D.orange,
                  tint: _D.tintOrange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _AssignmentMetric(
                  icon: Icons.check_circle_rounded,
                  value: '$gradedToday',
                  label: 'Graded',
                  color: _D.green,
                  tint: _D.tintGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: _D.tintBlue,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _D.blue.withValues(alpha: .18),
                width: .5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.upload_file_rounded,
                    color: _D.blue,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ready to publish',
                        style: _D.subheadline(color: _D.labelPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$draftsReady assignment drafts prepared',
                        style: _D.caption1(),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: _D.blue,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentMetric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color tint;

  const _AssignmentMetric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: -.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text(label, style: _D.caption1()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _D {
  static const green = Color(0xFF46A800);
  static const orange = Color(0xFFF59000);
  static const blue = Color(0xFF14A0E0);
  static const bgElevated = Color(0xFFFFFAF4);
  static const tintGreen = Color(0xFFF1FBE8);
  static const tintOrange = Color(0xFFFFF1E4);
  static const tintBlue = Color(0xFFEAF8FE);
  static const labelPrimary = Color(0xFF1C1C1E);
  static const labelTertiary = Color(0xFF8E8E93);

  static TextStyle title3({Color? color}) => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: color ?? labelPrimary,
    letterSpacing: -.41,
    height: 1.3,
  );

  static TextStyle subheadline({Color? color}) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: color ?? labelTertiary,
    letterSpacing: -.08,
    height: 1.4,
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
