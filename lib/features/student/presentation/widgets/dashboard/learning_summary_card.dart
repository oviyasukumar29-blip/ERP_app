// features/student/presentation/widgets/dashboard/learning_summary_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class LearningSummaryCard extends StatelessWidget {

  const LearningSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_rounded,
                    color: Colors.white, size: 13),
                SizedBox(width: 5),
                Text(
                  "Top 5% researcher",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Academic Standing",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Your consistent performance has placed you in the top 5% of active researchers.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 22),

          const Row(
            children: [

              _StatColumn(label: "GLOBAL RANK", value: "#142"),

              _Divider(),

              _StatColumn(label: "POINTS EARNED", value: "12.4k"),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {

  final String label;
  final String value;

  const _StatColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {

  const _Divider();

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 0.5,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white.withOpacity(0.25),
    );
  }
}