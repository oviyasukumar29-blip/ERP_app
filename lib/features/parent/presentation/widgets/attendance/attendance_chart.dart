
// features/parent/presentation/widgets/attendance/attendance_chart.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';
import '../../../data/models/child_model.dart';

/// Weekly attendance bar chart — visual language matches the student
/// app's _ActivityBars (bar heights, today highlight, day labels).
class AttendanceChart extends StatelessWidget {
  final List<AttendanceRecord> records;

  const AttendanceChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    // Group into the most recent 7 entries for a compact weekly view.
    final recent = records.length > 7
        ? records.sublist(records.length - 7)
        : records;

    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: recent.map((r) {
          final isToday = _isSameDay(r.date, DateTime.now());
          final color = PT.statusColor(r.status);
          final height = r.status == 'present'
              ? 90.0
              : r.status == 'leave'
                  ? 55.0
                  : 25.0;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    height: height,
                    decoration: BoxDecoration(
                      color: isToday ? color : color.withValues(alpha: .55),
                      borderRadius: BorderRadius.circular(20),
                      border: isToday
                          ? Border.all(color: PT.labelPrimary.withValues(alpha: .08))
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _weekdayLabel(r.date),
                    style: PT.caption2(
                      color: isToday ? PT.primary : PT.labelQuaternary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekdayLabel(DateTime date) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return labels[date.weekday - 1];
  }
}