import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

/// Single subject progress card — shows grade, percentage bar, trend arrow.
class ProgressCard extends StatelessWidget {
  final String subject;
  final double percentage; // 0–100
  final String grade; // e.g. "A+", "B"
  final String trend; // 'up', 'down', 'stable'
  final String trendLabel; // e.g. "+5% from last term"

  const ProgressCard({
    super.key,
    required this.subject,
    required this.percentage,
    required this.grade,
    required this.trend,
    required this.trendLabel,
  });

  static const _subjectColors = {
    'math': PT.blueDeep,
    'mathematics': PT.blueDeep,
    'science': PT.green,
    'english': PT.purple,
    'history': PT.orange,
    'geography': PT.coral,
    'physics': PT.blue,
    'chemistry': PT.yellow,
    'biology': PT.greenDark,
    'computer': PT.blueDeep,
  };

  Color get _color {
    final key = subject.toLowerCase();
    for (final e in _subjectColors.entries) {
      if (key.contains(e.key)) return e.value;
    }
    return PT.blueDeep;
  }

  @override
  Widget build(BuildContext context) {
    final trendColor = trend == 'up'
        ? PT.green
        : trend == 'down'
            ? PT.red
            : PT.orange;
    final trendIcon = trend == 'up'
        ? Icons.trending_up_rounded
        : trend == 'down'
            ? Icons.trending_down_rounded
            : Icons.trending_flat_rounded;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: PT.smallCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    grade,
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject, style: PT.subheadline()),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(trendIcon, size: 12, color: trendColor),
                        const SizedBox(width: 3),
                        Text(trendLabel,
                            style: PT.caption2(color: trendColor)),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${percentage.round()}%',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 7,
              backgroundColor: PT.separator,
              valueColor: AlwaysStoppedAnimation(_color),
            ),
          ),
        ],
      ),
    );
  }
}
