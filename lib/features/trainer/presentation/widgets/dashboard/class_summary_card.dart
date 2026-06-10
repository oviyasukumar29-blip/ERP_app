import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassSummaryCard extends StatelessWidget {
  final int activeClasses;
  final int students;
  final int hoursToday;

  const ClassSummaryCard({
    super.key,
    this.activeClasses = 6,
    this.students = 148,
    this.hoursToday = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryTile(
            icon: Icons.groups_rounded,
            value: '$activeClasses',
            label: 'Classes',
            color: _D.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryTile(
            icon: Icons.school_rounded,
            value: '$students',
            label: 'Students',
            color: _D.yellow,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryTile(
            icon: Icons.schedule_rounded,
            value: '${hoursToday}h',
            label: 'Today',
            color: _D.purple,
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -.35,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: .72),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: .07,
            ),
          ),
        ],
      ),
    );
  }
}

class _D {
  static const green = Color(0xFF46A800);
  static const yellow = Color(0xFFE8C400);
  static const purple = Color(0xFFBB6EF0);
}
