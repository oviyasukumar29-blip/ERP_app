// features/student/presentation/widgets/dashboard/streak_card.dart

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../shared/soft_card.dart';

class StreakCard extends StatelessWidget {

  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {

    final textTheme =
        Theme.of(context).textTheme;

    return SoftCard(

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              Text(
                "Study Streak",
                style: textTheme.titleMedium,
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: AppColors.primaryLight,

                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Text(
                  "5 DAYS",

                  style: textTheme.labelSmall
                      ?.copyWith(
                    color: AppColors.successText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: List.generate(
              7,
              (index) {

                final active = index < 5;

                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),

                    child: AspectRatio(
                      aspectRatio: 1,

                      child: Container(
                        decoration: BoxDecoration(

                          color: active
                              ? AppColors.primary
                              : Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),

                          border: Border.all(
                            color: active
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),

                        child: active
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}