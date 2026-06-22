import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

/// Compact card shown at top of homework page for nearest upcoming deadline.
class DeadlineCard extends StatelessWidget {
  final String subject;
  final String title;
  final String childName;
  final String dueLabel; // e.g. "Due today at 11:59 PM"
  final bool isUrgent; // true → red accent, false → orange

  const DeadlineCard({
    super.key,
    required this.subject,
    required this.title,
    required this.childName,
    required this.dueLabel,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isUrgent ? PT.red : PT.orange;
    final tint = isUrgent ? PT.tintRed : PT.tintOrange;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: .30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .20),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text('⏰', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isUrgent ? 'URGENT' : 'UPCOMING',
                    style: GoogleFonts.fredoka(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: PT.headline(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$subject · $childName',
                  style: PT.caption1(
                      color: Colors.white.withValues(alpha: .80)),
                ),
                const SizedBox(height: 4),
                Text(
                  dueLabel,
                  style: PT.caption2(
                      color: Colors.white.withValues(alpha: .70)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
