// features/student/presentation/pages/courses_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../services/course_service.dart';

class _A {
  static const green = Color(0xFF46A800);
  static const greenDark = Color(0xFF357800);
  static const orange = Color(0xFFF59000);
  static const blue = Color(0xFF14A0E0);
  static const blueDark = Color(0xFF0072B5);
  static const blueDeep = Color(0xFF2464B8);
  static const red = Color(0xFFEC3A3A);
  static const purple = Color(0xFFBB6EF0);
  static const purpleDark = Color(0xFFA500E8);
  static const bg = Color(0xFFFDF6EC);
  static const bgElevated = Color(0xFFFFFAF4);
  static const tintBlue = Color(0xFFEAF8FE);
  static const tintGreen = Color(0xFFF1FBE8);
  static const tintOrange = Color(0xFFFFF1E4);
  static const tintPurple = Color(0xFFF7EEFF);
  static const labelPrimary = Color(0xFF1C1C1E);
  static const labelSecondary = Color(0xFF3C3C43);
  static const labelTertiary = Color(0xFF8E8E93);
  static const labelQuaternary = Color(0xFFC7C7CC);
  static const separator = Color(0xFFE5E5EA);

  static TextStyle title2({Color? color}) => GoogleFonts.fredoka(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? labelPrimary,
        height: 1.2,
      );

  static TextStyle headline({Color? color}) => GoogleFonts.fredoka(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color ?? labelPrimary,
      );

  static TextStyle subheadline({Color? color}) => GoogleFonts.fredoka(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? labelSecondary,
        height: 1.4,
      );

  static TextStyle caption1({Color? color}) => GoogleFonts.fredoka(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color ?? labelTertiary,
      );

  static TextStyle caption2({Color? color}) => GoogleFonts.fredoka(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color ?? labelTertiary,
      );

  static BoxDecoration get widgetCard => BoxDecoration(
        color: bgElevated,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: .8),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      );
}

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final CourseService _courseService = CourseService();
  List<Map<String, dynamic>> _courses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _courseService.getCourses();
    if (!mounted) return;
    setState(() {
      _courses = courses;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _A.bg,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: RefreshIndicator(
                color: _A.blue,
                onRefresh: _loadCourses,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                  children: [
                    _ContinueLearningCard(
                      course: _courses.isNotEmpty ? _courses.first : null,
                      onStart: () => _openVideo(
                        _courses.isNotEmpty ? _courses.first : _emptyCourse(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _SectionHeader(
                      title: '📚 Enrolled Courses',
                      action: 'View all',
                    ),
                    const SizedBox(height: 12),
                    if (_loading)
                      const _CourseLoadingCard()
                    else if (_courses.isEmpty)
                      const _EmptyCoursesCard()
                    else
                      ...List.generate(_courses.length, (index) {
                        final course = _courses[index];
                        final color = [_A.blue, _A.green, _A.purple][index % 3];
                        final dark = [
                          _A.blueDark,
                          _A.greenDark,
                          _A.purpleDark,
                        ][index % 3];
                        final icon = [
                          Icons.calculate_rounded,
                          Icons.science_rounded,
                          Icons.smart_toy_rounded,
                        ][index % 3];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CourseCard(
                            iconColor: color,
                            progressColor: color,
                            progressTextColor: dark,
                            icon: icon,
                            title: course["title"]?.toString() ?? "Course",
                            subtitle:
                                course["description"]?.toString() ??
                                "No description",
                            teacher: "Pinesphere Trainer",
                            watchedHours:
                                "${course["watched_hours"] ?? 0} hrs watched",
                            progress:
                                ((course["progress"] as num?)?.toDouble() ??
                                    0) /
                                100,
                            progressText: "${course["progress"] ?? 0}%",
                            onTap: () => _openVideo(course),
                          ),
                        );
                      }),
                    const SizedBox(height: 8),
                    const _SectionHeader(title: '✨ Recommended For You'),
                    const SizedBox(height: 12),
                    const _RecommendedCourse(
                      title: 'Artificial Intelligence Basics',
                      lessons: '24 lessons',
                      rating: '4.8',
                      iconColor: _A.greenDark,
                      icon: Icons.smart_toy_rounded,
                    ),
                    const SizedBox(height: 12),
                    const _RecommendedCourse(
                      title: 'Creative Writing Masterclass',
                      lessons: '18 lessons',
                      rating: '4.7',
                      iconColor: _A.red,
                      icon: Icons.edit_note_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _emptyCourse() => {
    "title": "Start learning",
    "description": "No course video assigned yet",
    "duration": "0 hrs",
    "progress": 0,
    "watched_hours": "0",
    "video_title": "Course introduction",
    "video_url": "https://samplelib.com/lib/preview/mp4/sample-5s.mp4",
  };

  void _openVideo(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VideoLessonSheet(course: course),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: _A.bg,
        border: Border(bottom: BorderSide(color: _A.separator, width: .5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _A.tintPurple,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.menu_book_rounded, color: _A.purple, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My learning', style: _A.caption1()),
                const SizedBox(height: 4),
                Text('Courses', style: _A.title2()),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _A.tintBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.search_rounded, color: _A.blue, size: 22),
          ),
        ],
      ),
    );
  }
}

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
          Text(action!, style: _A.subheadline(color: _A.blue)),
      ],
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  final Map<String, dynamic>? course;
  final VoidCallback onStart;

  const _ContinueLearningCard({required this.course, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final title = course?["title"]?.toString() ?? "Start learning";
    final progress = course?["progress"] ?? 0;

    return GestureDetector(
      onTap: onStart,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _A.green,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: _A.greenDark.withValues(alpha: .30),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: .35),
              blurRadius: 10,
              offset: const Offset(-2, -2),
            ),
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
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .22),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      '▶ Continue learning',
                      style: GoogleFonts.fredoka(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: _A.title2().copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${course?["watched_hours"] ?? 0} hrs watched',
                    style: _A.caption1(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
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
                        widthFactor:
                            ((progress as num?)?.toDouble() ?? 0) / 100,
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
                  const SizedBox(height: 8),
                  Text(
                    '$progress% completed',
                    style: _A.caption1(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: _A.greenDark,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _A.greenDark.withValues(alpha: .40),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Color iconColor;
  final Color progressColor;
  final Color progressTextColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final String teacher;
  final String watchedHours;
  final double progress;
  final String progressText;
  final VoidCallback onTap;

  const _CourseCard({
    required this.iconColor,
    required this.progressColor,
    required this.progressTextColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.teacher,
    required this.watchedHours,
    required this.progress,
    required this.progressText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _A.widgetCard,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: _A.headline()),
                  const SizedBox(height: 5),
                  Text(subtitle, style: _A.caption1()),
                  const SizedBox(height: 4),
                  Text('$teacher · $watchedHours', style: _A.caption2()),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: progressColor.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress.clamp(0, 1),
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
                  Text(
                    progressText,
                    style: _A.caption2(color: progressTextColor),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.play_circle_fill_rounded,
              color: _A.blue,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoLessonSheet extends StatelessWidget {
  final Map<String, dynamic> course;
  const _VideoLessonSheet({required this.course});

  @override
  Widget build(BuildContext context) {
    final title =
        course["video_title"]?.toString() ??
        "${course["title"] ?? "Course"} introduction";
    final videoUrl =
        course["video_url"]?.toString() ??
        "https://samplelib.com/lib/preview/mp4/sample-5s.mp4";

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _A.bgElevated,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('🎬 Lesson Video', style: _A.title2()),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: _A.labelPrimary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                    size: 76,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(title, style: _A.title2()),
            const SizedBox(height: 4),
            Text(
              '${course["title"] ?? "Course"} · ${course["duration"] ?? "0 hrs"}',
              style: _A.subheadline(),
            ),
            const SizedBox(height: 8),
            Text(
              'Sample video: $videoUrl',
              style: _A.caption1(color: _A.blueDark),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _A.tintBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_rounded, color: _A.blue),
                  const SizedBox(width: 8),
                  Text(
                    '${course["watched_hours"] ?? 0} hrs watched so far',
                    style: _A.subheadline(color: _A.blueDark),
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

class _CourseLoadingCard extends StatelessWidget {
  const _CourseLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _A.widgetCard,
      child: Row(
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 3, color: _A.blue),
          ),
          const SizedBox(width: 12),
          Text('Loading courses...', style: _A.subheadline()),
        ],
      ),
    );
  }
}

class _EmptyCoursesCard extends StatelessWidget {
  const _EmptyCoursesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _A.widgetCard,
      child: Text(
        'No courses assigned yet',
        style: _A.subheadline(color: _A.labelTertiary),
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(16),
      decoration: _A.widgetCard,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _A.headline()),
                const SizedBox(height: 5),
                Text(lessons, style: _A.caption1()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: _A.tintOrange,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: _A.orange, size: 14),
                const SizedBox(width: 5),
                Text(
                  rating,
                  style: _A.caption2(color: _A.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
