
// features/parent/presentation/widgets/dashboard/ai_report_card.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';

/// Surfaces the platform's "Weekly AI-generated performance summary"
/// feature (from the Parent Portal spec) directly on the dashboard.
class AiReportCard extends StatelessWidget {
  final String summary;
  final VoidCallback? onViewFullReport;

  const AiReportCard({
    super.key,
    required this.summary,
    this.onViewFullReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [PT.tintPurple, Color.lerp(PT.tintPurple, Colors.white, 0.3)!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: PT.purple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text("AI Weekly Summary", style: PT.headline(color: PT.purpleDark)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: PT.subheadline(color: PT.labelSecondary).copyWith(height: 1.4),
          ),
          if (onViewFullReport != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onViewFullReport,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("View full report", style: PT.caption1(color: PT.purpleDark)),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: PT.purpleDark,
                    size: 10,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}