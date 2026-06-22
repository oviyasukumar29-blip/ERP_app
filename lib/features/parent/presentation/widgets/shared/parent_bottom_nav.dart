
// features/parent/presentation/widgets/shared/parent_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

/// Bottom navigation for the Parent module — same Apple-widget pill
/// nav bar language as the student app, with parent-relevant tabs:
/// Home, Attendance, Fees, Progress, Homework.
class ParentBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ParentBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.house_rounded, Icons.house_outlined, 'Home'),
    (Icons.event_available_rounded, Icons.event_available_outlined, 'Attendance'),
    (Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Fees'),
    (Icons.insights_rounded, Icons.insights_outlined, 'Progress'),
    (Icons.assignment_rounded, Icons.assignment_outlined, 'Homework'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: PT.separator, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .10),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (i) {
                final active = currentIndex == i;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(i);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          width: active ? 40 : 26,
                          height: active ? 30 : 26,
                          decoration: active
                              ? BoxDecoration(
                                  color: PT.primary.withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(9),
                                )
                              : null,
                          child: Icon(
                            active ? _items[i].$1 : _items[i].$2,
                            color: active ? PT.primary : PT.labelTertiary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _items[i].$3,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w400,
                            color: active ? PT.primary : PT.labelTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}