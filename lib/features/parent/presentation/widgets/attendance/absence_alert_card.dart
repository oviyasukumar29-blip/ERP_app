
// features/parent/presentation/widgets/attendance/absence_alert_card.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';
import '../../../data/models/child_model.dart';

/// Surfaces recent absences/leaves so parents don't have to dig through
/// the calendar to notice a pattern worth following up on.
class AbsenceAlertCard extends StatelessWidget {
  final List<AttendanceRecord> recentAbsences;

  const AbsenceAlertCard({super.key, required this.recentAbsences});

  @override
  Widget build(BuildContext context) {
    if (recentAbsences.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: PT.tintCard(PT.tintGreen),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: PT.green, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "No recent absences — great attendance streak!",
                style: PT.subheadline(color: PT.greenDark),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: PT.tintCard(PT.tintRed),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: PT.red, size: 20),
              const SizedBox(width: 8),
              Text("Recent absences", style: PT.headline(color: PT.redDark)),
            ],
          ),
          const SizedBox(height: 10),
          ...recentAbsences.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "${_formatDate(r.date)} — ${r.status == 'leave' ? 'On leave' : 'Absent'}",
                  style: PT.caption1(color: PT.labelSecondary),
                ),
              )),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${date.day} ${months[date.month - 1]}";
  }
}