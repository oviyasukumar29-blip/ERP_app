// features/student/presentation/widgets/dashboard/pending_assignment_tile.dart

import 'package:flutter/material.dart';

class PendingAssignmentTile extends StatelessWidget {

  final String title;
  final String subtitle;
  final bool danger;

  const PendingAssignmentTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.danger,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          Container(
            height: 50,
            width: 50,

            decoration: BoxDecoration(
              color: danger
                  ? Colors.red.shade50
                  : Colors.green.shade50,

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Icon(
              danger
                  ? Icons.error
                  : Icons.history,

              color: danger
                  ? Colors.red
                  : Colors.green,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: danger
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios,
              size: 18),
        ],
      ),
    );
  }
}