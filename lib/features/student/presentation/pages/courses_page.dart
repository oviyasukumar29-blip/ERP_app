// features/student/presentation/pages/courses_page.dart

import 'package:flutter/material.dart';

// ─── Design tokens (shared with student_screen.dart) ───
class _T {
  static const primary       = Color(0xFF45960A);
  static const primaryDark   = Color(0xFF2E6A06);
  static const primaryLight  = Color(0xFFEAF3DE);
  static const primarySubtle = Color(0xFFF0FAE8);
  static const primaryGlow   = Color(0xFFC0DD97);

  static const bg            = Color(0xFFF7F8F5);
  static const white         = Colors.white;

  static const textDark      = Color(0xFF111111);
  static const textGrey      = Color(0xFF888888);
  static const textMid       = Color(0xFF666666);

  static const border        = Color(0xFFE8E8E8);

  static const blue          = Color(0xFF378ADD);
  static const blueLight     = Color(0xFFE6F1FB);
  static const blueDark      = Color(0xFF0C447C);
  static const blueMid       = Color(0xFF185FA5);

  static const purple        = Color(0xFF7F77DD);
  static const purpleLight   = Color(0xFFEEEDFE);
  static const purpleDark    = Color(0xFF3C3489);
  static const purpleMid     = Color(0xFF534AB7);

  static const successDark   = Color(0xFF27500A);
  static const successText   = Color(0xFF3B6D11);

  static const dangerLight   = Color(0xFFFCEBEB);
  static const dangerDark    = Color(0xFF791F1F);

  static const amber         = Color(0xFFEF9F27);
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 110),
                children: const [
                  _ContinueLearningCard(),
                  SizedBox(height: 16),
                  _SectionHeader(title: 'Enrolled courses', action: 'View all'),
                  SizedBox(height: 12),
                  _CourseCard(
                    iconBg: _T.blueLight,
                    iconColor: _T.blueDark,
                    progressColor: _T.blue,
                    progressTextColor: _T.blueMid,
                    icon: Icons.calculate_rounded,
                    title: 'Advanced Mathematics',
                    subtitle: '12 chapters · 3 quizzes left',
                    teacher: 'Ms. Anita',
                    progress: .72,
                    progressText: '72%',
                  ),
                  SizedBox(height: 12),
                  _CourseCard(
                    iconBg: _T.primaryLight,
                    iconColor: _T.successDark,
                    progressColor: _T.primary,
                    progressTextColor: _T.successText,
                    icon: Icons.science_rounded,
                    title: 'Physics Fundamentals',
                    subtitle: '8 chapters · 1 assignment pending',
                    teacher: 'Mr. Rajesh',
                    progress: .58,
                    progressText: '58%',
                  ),
                  SizedBox(height: 12),
                  _CourseCard(
                    iconBg: _T.purpleLight,
                    iconColor: _T.purpleDark,
                    progressColor: _T.purple,
                    progressTextColor: _T.purpleMid,
                    icon: Icons.language_rounded,
                    title: 'English Communication',
                    subtitle: '15 lessons · Speaking practice',
                    teacher: 'Mrs. Priya',
                    progress: .84,
                    progressText: '84%',
                  ),
                  SizedBox(height: 20),
                  _SectionHeader(title: 'Recommended for you'),
                  SizedBox(height: 12),
                  _RecommendedCourse(
                    title: 'Artificial Intelligence Basics',
                    lessons: '24 lessons',
                    rating: '4.8',
                    iconBg: _T.primaryLight,
                    icon: Icons.smart_toy_rounded,
                    iconColor: _T.successDark,
                  ),
                  SizedBox(height: 12),
                  _RecommendedCourse(
                    title: 'Creative Writing Masterclass',
                    lessons: '18 lessons',
                    rating: '4.7',
                    iconBg: _T.dangerLight,
                    icon: Icons.edit_note_rounded,
                    iconColor: _T.dangerDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}

// ─────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      decoration: const BoxDecoration(
        color: _T.white,
        border: Border(bottom: BorderSide(color: _T.border, width: .5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'My learning',
                  style: TextStyle(
                    fontSize: 11,
                    color: _T.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _T.textDark,
                    letterSpacing: -.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _T.primarySubtle,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _T.primaryGlow, width: 1),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: _T.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;

  const _SectionHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: _T.textDark,
            letterSpacing: -.2,
          ),
        ),
        const SizedBox(height: 6),
        if (action != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _T.primarySubtle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              action!,
              style: const TextStyle(
                color: _T.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CONTINUE LEARNING HERO
// ─────────────────────────────────────────────────────────────
class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _T.primaryDark,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // chip label
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _T.primary.withOpacity(.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Continue learning',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _T.primaryGlow,
                      letterSpacing: .3,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Mathematics —\nAlgebra',
                  style: TextStyle(
                    color: _T.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -.4,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Chapter 5 · Quadratic equations',
                  style: TextStyle(
                    color: _T.primaryGlow,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: .68,
                    minHeight: 6,
                    backgroundColor: _T.primary.withOpacity(.25),
                    valueColor: const AlwaysStoppedAnimation(_T.white),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '68% completed',
                  style: TextStyle(
                    color: _T.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Play button
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: _T.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: _T.white,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ENROLLED COURSE CARD
// ─────────────────────────────────────────────────────────────
class _CourseCard extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final Color progressColor;
  final Color progressTextColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final String teacher;
  final double progress;
  final String progressText;

  const _CourseCard({
    required this.iconBg,
    required this.iconColor,
    required this.progressColor,
    required this.progressTextColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.teacher,
    required this.progress,
    required this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _T.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _T.border, width: .5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: _T.textDark,
                    letterSpacing: -.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _T.textGrey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  teacher,
                  style: const TextStyle(
                    color: _T.textMid,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFEEEEEE),
                    valueColor: AlwaysStoppedAnimation(progressColor),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  progressText,
                  style: TextStyle(
                    color: progressTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RECOMMENDED COURSE CARD
// ─────────────────────────────────────────────────────────────
class _RecommendedCourse extends StatelessWidget {
  final String title;
  final String lessons;
  final String rating;
  final Color iconBg;
  final IconData icon;
  final Color iconColor;

  const _RecommendedCourse({
    required this.title,
    required this.lessons,
    required this.rating,
    required this.iconBg,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _T.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _T.border, width: .5),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: _T.textDark,
                    letterSpacing: -.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  lessons,
                  style: const TextStyle(
                    color: _T.textGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Rating pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFAEEDA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: _T.amber,
                  size: 14,
                ),
                const SizedBox(width: 3),
                Text(
                  rating,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: Color(0xFF633806),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}