// features/student/presentation/widgets/dashboard/live_class_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class LiveClassCard extends StatelessWidget {
  final String subject;
  final String teacher;
  final String time;
  final bool isLive;
  final int studentsJoined;

  const LiveClassCard({
    super.key,
    required this.subject,
    required this.teacher,
    required this.time,
    this.isLive = false,
    this.studentsJoined = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: .8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Date box ─────────────────────────────────────────
          Container(
            width: 56,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primary.withOpacity(.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'AUG',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.successText,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '24',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    height: 1,
                    letterSpacing: -.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // ── Details ──────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Live badge
                if (isLive)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE24B4A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'LIVE NOW',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF791F1F),
                            letterSpacing: .5,
                          ),
                        ),
                        if (studentsJoined > 0) ...[
                          const Text(
                            ' · ',
                            style: TextStyle(
                                color: Color(0xFF791F1F), fontSize: 9),
                          ),
                          Text(
                            '$studentsJoined joined',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF791F1F),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                Text(
                  subject,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.textDark,
                    letterSpacing: -.2,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  teacher,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    color: AppColors.textGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: isLive
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF4DB810),
                                      Color(0xFF256E04)
                                    ],
                                  )
                                : null,
                            color: isLive
                                ? null
                                : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: isLive
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withOpacity(.35),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              isLive ? 'Join Now 🚀' : 'Set Reminder',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: isLive
                                    ? Colors.white
                                    : AppColors.successText,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!isLive) ...[
                      const SizedBox(width: 10),
                      Text(
                        time,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          color: AppColors.textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}