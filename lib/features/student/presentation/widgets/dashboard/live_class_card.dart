// features/student/presentation/widgets/dashboard/live_class_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class LiveClassCard extends StatelessWidget {

  const LiveClassCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [

          Container(
            height: 80,
            width: 60,

            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Text("AUG"),
                SizedBox(height: 6),

                Text(
                  "24",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  "Advanced Algorithms",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Prof. Sarah Jenkins",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [

                    Expanded(
                      child: Container(
                        height: 45,

                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius:
                              BorderRadius.circular(
                                  14),
                        ),

                        child: const Center(
                          child: Text(
                            "JOIN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Text(
                      "10:30 AM",
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}