
// features/parent/presentation/widgets/attendance/attendance_calendar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';
import '../../../data/models/child_model.dart';

/// Full month grid — each day colored by attendance status. Tapping a
/// day shows the status in a small tooltip-style snackbar.
class AttendanceCalendar extends StatelessWidget {
  final DateTime month;
  final List<AttendanceRecord> records;

  const AttendanceCalendar({
    super.key,
    required this.month,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = (firstDay.weekday - 1) % 7; // Monday-first grid

    final byDay = {for (final r in records) r.date.day: r.status};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d, style: PT.caption2(color: PT.labelTertiary)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1,
          ),
          itemCount: leadingBlanks + daysInMonth,
          itemBuilder: (context, index) {
            if (index < leadingBlanks) return const SizedBox.shrink();
            final day = index - leadingBlanks + 1;
            final status = byDay[day];
            final color = status != null ? PT.statusColor(status) : null;
            final isFuture =
                DateTime(month.year, month.month, day).isAfter(DateTime.now());

            return Container(
              decoration: BoxDecoration(
                color: isFuture
                    ? Colors.transparent
                    : (color?.withValues(alpha: .15) ?? PT.separator.withValues(alpha: .3)),
                borderRadius: BorderRadius.circular(10),
                border: isFuture
                    ? Border.all(color: PT.separator, width: 1)
                    : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isFuture
                        ? PT.labelQuaternary
                        : (color ?? PT.labelTertiary),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 6,
          children: const [
            _LegendDot(color: PT.green, label: 'Present'),
            _LegendDot(color: PT.red, label: 'Absent'),
            _LegendDot(color: PT.yellow, label: 'Leave'),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: PT.caption2(color: PT.labelTertiary)),
      ],
    );
  }
}