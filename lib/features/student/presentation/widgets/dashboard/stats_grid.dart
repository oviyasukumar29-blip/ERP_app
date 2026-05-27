// features/student/presentation/widgets/dashboard/stats_grid.dart

import 'package:flutter/material.dart';
import 'stat_item_card.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.18, // was 1.08 — gives cards breathing room
      children: const [
        StatItemCard(
          icon: Icons.menu_book_rounded,
          title: "Courses",
          value: "8",
        ),
        StatItemCard(
          icon: Icons.timer_rounded,
          title: "Hours Studied",
          value: "124",
        ),
        StatItemCard(
          icon: Icons.assignment_rounded,
          title: "Assignments",
          value: "42",
        ),
        StatItemCard(
          icon: Icons.percent_rounded,
          title: "Attendance",
          value: "94%",
        ),
      ],
    );
  }
}