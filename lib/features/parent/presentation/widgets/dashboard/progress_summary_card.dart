
// features/parent/presentation/widgets/dashboard/progress_summary_card.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';
import '../shared/section_header.dart';

/// Mini skill-bar summary for the dashboard — full detail lives on the
/// Progress page (skill_chart.dart); this is the "at a glance" version.
class ProgressSummaryCard extends StatelessWidget {
  final Map<String, num> skillScores;
  final VoidCallback? onSeeAll;

  const ProgressSummaryCard({
    super.key,
    required this.skillScores,
    this.onSeeAll,
  });

  static const _colors = [PT.blueDeep, PT.purple, PT.orange, PT.green, PT.coral];

  @override
  Widget build(BuildContext context) {
    final entries = skillScores.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "🧠 Skill Progress",
          action: entries.isEmpty ? "" : "See All",
          onActionTap: onSeeAll,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: PT.widgetCard,
          child: entries.isEmpty
              ? Text(
                  "No progress data yet",
                  style: PT.subheadline(color: PT.labelTertiary),
                )
              : Column(
                  children: List.generate(entries.length, (i) {
                    final e = entries[i];
                    final color = _colors[i % _colors.length];
                    final value = e.value.clamp(0, 100).toDouble();
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: i == entries.length - 1 ? 0 : 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(e.key, style: PT.subheadline(color: PT.labelPrimary)),
                              const Spacer(),
                              Text(
                                "${e.value.round()}%",
                                style: PT.caption1(color: color),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Stack(
                            children: [
                              Container(
                                height: 7,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: value / 100.0,
                                child: Container(
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
        ),
      ],
    );
  }
}