// features/student/presentation/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/shared/soft_card.dart';
import '../widgets/dashboard/stats_grid.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 56, 18, 120), // top: status bar, bottom: nav bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("Good Morning,", style: textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text("Arjun Kumar", style: textTheme.displayLarge),
          const SizedBox(height: 24),

          // ── Streak Card ──────────────────────────────────────────
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Weekly Study Streak", style: textTheme.titleMedium),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "5 DAYS",
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.successText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(7, (index) {
                    final active = index < 5;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: active
                                ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 18)
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Action Buttons ───────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.upload_file_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text("Submit HW",
                          style: textTheme.titleMedium
                              ?.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.primary, width: 1.4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.smart_toy_outlined,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text("AI Tutor",
                          style: textTheme.titleMedium
                              ?.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Progress Grid ────────────────────────────────────────
          Text("Your Progress", style: textTheme.titleLarge),
          const SizedBox(height: 14),
          const StatsGrid(),

          const SizedBox(height: 28),

          // ── Pending Assignments ──────────────────────────────────
          Text("Pending Assignments", style: textTheme.titleLarge),
          const SizedBox(height: 14),

          _assignmentTile(context,
              title: "Binary Search Trees",
              subtitle: "Due Today",
              danger: true),

          const SizedBox(height: 10),

          _assignmentTile(context,
              title: "Market Analysis Essay",
              subtitle: "2 Days Left",
              danger: false),
        ],
      ),
    );
  }

  Widget _assignmentTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool danger,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: danger
                  ? AppColors.dangerLight
                  : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              danger
                  ? Icons.error_outline_rounded
                  : Icons.history_rounded,
              color: danger
                  ? AppColors.dangerText
                  : AppColors.successText,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: danger
                        ? AppColors.danger
                        : AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textLight),
        ],
      ),
    );
  }
}