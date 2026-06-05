// features/student/presentation/widgets/dashboard/streak_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../shared/soft_card.dart';

class StreakCard extends StatelessWidget {
  final int streakDays;
  final List<bool> weekActivity;

  const StreakCard({
    super.key,
    required this.streakDays,
    required this.weekActivity,
  });


  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAEEDA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('🔥', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Weekly Streak',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  letterSpacing: -.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAEEDA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFEF9F27).withOpacity(.3),
                      width: .8),
                ),
                child: Text(
                  '$streakDays day streak 🏆',
                  style: GoogleFonts.nunito(
                    color: const Color(0xFF633806),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: .2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final active = weekActivity[i];

              
                  final today = i == 1;

              final done = active;

              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: today
                          ? AppColors.primary
                          : done
                              ? AppColors.primaryLight
                              : Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: active
                            ? AppColors.primary.withOpacity(.4)
                            : AppColors.border,
                        width: active ? 1.8 : 1,
                      ),
                      boxShadow: today
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                   child: Center(
                    child: today && active
                        ? const Text(
                            '🔥',
                            style: TextStyle(fontSize: 16),
                          )
                        : active
                            ? Icon(
                                Icons.check_rounded,
                                size: 17,
                                color: AppColors.successText,
                              )
                            : null,
                  ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _dayLabels[i],
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      color: active
                          ? AppColors.primary
                          : AppColors.textLight,
                      fontWeight:
                          active ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
