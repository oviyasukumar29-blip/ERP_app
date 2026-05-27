// features/student/presentation/widgets/dashboard/stat_item_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class StatItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(13), // was 16
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,   // ← KEY FIX: stops overflow
        children: [
          Container(
            padding: const EdgeInsets.all(10), // was 14
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14), // was 18
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 22, // was 28
            ),
          ),
          const SizedBox(height: 10), // was 16
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 12, // was 15
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 3), // was 6
          Text(
            value,
            style: textTheme.displayLarge?.copyWith(
              fontSize: 22, // was 28
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}