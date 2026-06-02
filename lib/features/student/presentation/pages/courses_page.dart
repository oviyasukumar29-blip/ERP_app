// features/student/presentation/pages/courses_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Exact 12-color palette from dashboard_page.dart ────────
class _A {
  // ── STRICT PALETTE ──────────────────────────────────────
  static const green       = Color(0xFF58CC02);
  static const greenDark   = Color(0xFF45A700);
  static const orange      = Color(0xFFFF9600);
  static const blue        = Color(0xFF1CB0F6);
  static const blueDark    = Color(0xFF0081C8);
  static const blueDeep    = Color(0xFF2B70C9);
  static const red         = Color(0xFFFF4B4B);
  static const redDark     = Color(0xFFCB3E3E);
  static const purple      = Color(0xFFCE82FF);
  static const purpleDark  = Color(0xFFB800FF);
  static const yellow      = Color(0xFFFFD900);
  static const coral       = Color(0xFFFF6B35);

  // ── CREAM BACKGROUNDS ───────────────────────────────────
  static const bg        = Color(0xFFFDF6EC);
  static const cardCream = Color(0xFFFFFAF4);

  // ── CARD TINTS — derived from palette ───────────────────
  static const tintGreen  = Color(0xFFEEFBDD);
  static const tintBlue   = Color(0xFFE3F5FE);
  static const tintOrange = Color(0xFFFFF3E0);
  static const tintRed    = Color(0xFFFFECEC);
  static const tintPurple = Color(0xFFF8EDFF);

  // ── TEXT ────────────────────────────────────────────────
  static const labelPrimary    = Color(0xFF1C1C1E);
  static const labelSecondary  = Color(0xFF3C3C43);
  static const labelTertiary   = Color(0xFF8E8E93);
  static const labelQuaternary = Color(0xFFC7C7CC);
  static const separator       = Color(0xFFE5E5EA);

  // ── TYPOGRAPHY — Inter everywhere ───────────────────────
  static TextStyle title2({Color? color}) => GoogleFonts.inter(
      fontSize: 17, fontWeight: FontWeight.w600,
      color: color ?? labelPrimary, letterSpacing: -0.41, height: 1.3);

  static TextStyle title3({Color? color}) => GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w600,
      color: color ?? labelPrimary, letterSpacing: -0.24, height: 1.4);

  static TextStyle subheadline({Color? color}) => GoogleFonts.inter(
      fontSize: 13, fontWeight: FontWeight.w500,
      color: color ?? labelTertiary, letterSpacing: -0.08, height: 1.4);

  static TextStyle caption1({Color? color}) => GoogleFonts.inter(
      fontSize: 11, fontWeight: FontWeight.w500,
      color: color ?? labelTertiary, letterSpacing: 0.07);

  static TextStyle caption2({Color? color}) => GoogleFonts.inter(
      fontSize: 11, fontWeight: FontWeight.w400,
      color: color ?? labelQuaternary, letterSpacing: 0.07);

  // ── CARD DECORATIONS ────────────────────────────────────
  static BoxDecoration widgetCard({double radius = 20}) => BoxDecoration(
        color: cardCream,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
            color: const Color(0xFFFF9600).withOpacity(.12), width: 0.8),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1CB0F6).withOpacity(.06),
              blurRadius: 20, offset: const Offset(0, 4)),
          BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 6, offset: const Offset(0, 1)),
        ],
      );
}

// ─────────────────────────────────────────────────────────────
// COURSES PAGE
// ─────────────────────────────────────────────────────────────
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDF6EC), Color(0xFFFAF0E4)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                children: const [
                  _ContinueLearningCard(),
                  SizedBox(height: 16),
                  _SectionHeader(title: 'Enrolled courses', action: 'View all'),
                  SizedBox(height: 12),
                  _CourseCard(
                    iconColor: _A.blue,
                    progressColor: _A.blue,
                    progressTextColor: _A.blueDark,
                    icon: Icons.calculate_rounded,
                    title: 'Advanced Mathematics',
                    subtitle: '12 chapters · 3 quizzes left',
                    teacher: 'Ms. Anita',
                    progress: .72,
                    progressText: '72%',
                  ),
                  SizedBox(height: 12),
                  _CourseCard(
                    iconColor: _A.green,
                    progressColor: _A.green,
                    progressTextColor: _A.greenDark,
                    icon: Icons.science_rounded,
                    title: 'Physics Fundamentals',
                    subtitle: '8 chapters · 1 assignment pending',
                    teacher: 'Mr. Rajesh',
                    progress: .58,
                    progressText: '58%',
                  ),
                  SizedBox(height: 12),
                  _CourseCard(
                    iconColor: _A.purple,
                    progressColor: _A.purple,
                    progressTextColor: _A.purpleDark,
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
                    iconColor: _A.greenDark,
                    icon: Icons.smart_toy_rounded,
                  ),
                  SizedBox(height: 12),
                  _RecommendedCourse(
                    title: 'Creative Writing Masterclass',
                    lessons: '18 lessons',
                    rating: '4.7',
                    iconColor: _A.red,
                    icon: Icons.edit_note_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      decoration: BoxDecoration(
        color: _A.cardCream,
        border: Border(bottom: BorderSide(color: _A.separator, width: .5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My learning', style: _A.caption1()),
                const SizedBox(height: 2),
                Text('Courses',
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.w600,
                        color: _A.labelPrimary, letterSpacing: -.4)),
              ],
            ),
          ),
          // Search — orange tint, matches dashboard header icon style
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: _A.tintOrange,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                  color: _A.orange.withOpacity(.25), width: 1),
              boxShadow: [
                BoxShadow(color: _A.orange.withOpacity(.10),
                    blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: const Icon(Icons.search_rounded,
                color: _A.orange, size: 22),
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
        Text(title, style: _A.title2()),
        const Spacer(),
        if (action != null)
          // "View all" — #1CB0F6 blue, same as dashboard "See All"
          Text(action!, style: _A.subheadline(color: _A.blue)),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // #58CC02 — same green as dashboard hero card
        color: _A.green,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: _A.greenDark.withOpacity(.35),
              blurRadius: 28, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Continue learning',
                      style: GoogleFonts.inter(
                          fontSize: 10, fontWeight: FontWeight.w700,
                          color: Colors.white, letterSpacing: .3)),
                ),
                const SizedBox(height: 10),
                Text('Mathematics —\nAlgebra',
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.w600,
                        color: Colors.white, height: 1.2,
                        letterSpacing: -.4)),
                const SizedBox(height: 6),
                Text('Chapter 5 · Quadratic equations',
                    style: _A.caption1(color: Colors.white70)),
                const SizedBox(height: 14),
                // Progress bar — white on #58CC02 bg
                Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.25),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: .68,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('68% completed',
                    style: _A.caption1(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Play button — #45A700 greenDark
          Container(
            width: 62, height: 62,
            decoration: BoxDecoration(
              color: _A.greenDark,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: _A.greenDark.withOpacity(.40),
                    blurRadius: 16, offset: const Offset(0, 5)),
              ],
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 34),
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
      decoration: _A.widgetCard(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon box tint is 12% opacity of the palette color
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(
                color: iconColor.withOpacity(.12),
                borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 14,
                        color: _A.labelPrimary, letterSpacing: -.2)),
                const SizedBox(height: 4),
                Text(subtitle, style: _A.caption1()),
                const SizedBox(height: 3),
                Text(teacher,
                    style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w500,
                        color: _A.labelSecondary)),
                const SizedBox(height: 10),
                // Stack-based bar (matches dashboard style)
                Stack(
                  children: [
                    Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: progressColor.withOpacity(.12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: progressColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(progressText,
                    style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w700,
                        color: progressTextColor)),
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
  final IconData icon;
  final Color iconColor;

  const _RecommendedCourse({
    required this.title,
    required this.lessons,
    required this.rating,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _A.widgetCard(radius: 18),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
                color: iconColor.withOpacity(.12),
                borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 13,
                        color: _A.labelPrimary, letterSpacing: -.2)),
                const SizedBox(height: 5),
                Text(lessons, style: _A.caption1()),
              ],
            ),
          ),
          // Rating pill — #FF9600 orange star
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: _A.tintOrange,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: _A.orange.withOpacity(.20), width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded,
                    color: _A.orange, size: 14),
                const SizedBox(width: 3),
                Text(rating,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color(0xFF633806))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}