import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

class NotificationFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  static const _filters = [
    ('All', '🔔'),
    ('Attendance', '📅'),
    ('Fees', '💰'),
    ('Homework', '📝'),
    ('Progress', '📊'),
  ];

  const NotificationFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final label = _filters[i].$1;
          final emoji = _filters[i].$2;
          final active = selected == label;

          return GestureDetector(
            onTap: () => onChanged(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: active ? PT.blueDeep : PT.bgElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? PT.blueDeep : PT.separator,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: GoogleFonts.fredoka(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : PT.labelSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
