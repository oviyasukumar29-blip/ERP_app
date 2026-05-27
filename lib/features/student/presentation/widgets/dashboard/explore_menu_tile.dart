// features/student/presentation/widgets/dashboard/explore_menu_tile.dart

import 'package:flutter/material.dart';

class ExploreMenuTile extends StatelessWidget {

  final IconData icon;
  final String title;

  const ExploreMenuTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          Icon(icon),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          const Icon(Icons.arrow_forward_ios,
              size: 18),
        ],
      ),
    );
  }
}