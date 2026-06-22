// features/parent/presentation/widgets/dashboard/child_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';
import '../../../data/models/child_model.dart';

class ChildCard extends StatelessWidget {
  final ChildModel child;
  final VoidCallback? onTap;
  final double? learningProgress;

  const ChildCard({super.key, required this.child, this.onTap, this.learningProgress});

  @override
  Widget build(BuildContext context) {
    final rawProgress = (learningProgress ?? child.progressPercent).toDouble();
    final progress = rawProgress.clamp(0, 100).toDouble();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: PT.primary,
          borderRadius: BorderRadius.circular(36),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Left: text content ───────────────────────────
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        child.course.isNotEmpty
                            ? child.course
                            : "Learning Progress",
                        style: GoogleFonts.fredoka(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: .90),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      child.name,
                      style: PT.title3(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${progress.toStringAsFixed(0)}% course completed",
                      style: PT.subheadline(color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .25),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress / 100.0,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Text(
                          "View details",
                          style: PT.caption1(color: Colors.white70),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white54,
                          size: 11,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Right: overflowing image ──────────────────────
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 160,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: OverflowBox(
                    maxHeight: 230,
                    maxWidth: 220,
                    alignment: Alignment.bottomRight,
                    child: Transform.translate(
                      offset: const Offset(18, 20),
                      child: Image.asset(
                        'assets/images/student_reading.png',
                        height: 190,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}