// features/student/presentation/widgets/dashboard/stat_item_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';

class StatItemCard extends StatelessWidget {
  final String emoji;
  final String? imagePath;
  final String title;
  final String value;
  final String sub;
  final double progress;
  final Color accentColor;
  final Color accentBg;

  const StatItemCard({
    super.key,
    required this.emoji,
    this.imagePath,
    required this.title,
    required this.value,
    this.sub = '',
    this.progress = 0.5,
    this.accentColor = AppColors.primary,
    this.accentBg = AppColors.primaryLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null)
            Image.asset(imagePath!, width: 100, height: 100)
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: accentBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),

          const SizedBox(height: 4),

          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -.5,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: accentBg,
              valueColor: AlwaysStoppedAnimation(accentColor),
            ),
          ),

          const SizedBox(height: 6),

          if (sub.isNotEmpty)
            Text(
              sub,
              style: GoogleFonts.nunito(
                color: accentColor,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: .2,
              ),
            ),
        ],
      ),
    );
  }
}
