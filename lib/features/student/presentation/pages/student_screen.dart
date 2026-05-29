// features/student/presentation/pages/student_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'courses_page.dart';
import 'assignments_page.dart';
import 'ai_chatbot_page.dart';
import 'profile_page.dart';
import '../../../../services/dashboard_service.dart';

// ─────────────────────────────────────────────────────────────
// DESIGN TOKENS  — Nunito + bubbly-green palette
// ─────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────
// MODERN PROFESSIONAL GREEN THEME
// ─────────────────────────────────────────────────────────────

class _T {

  // PRIMARY BRAND COLORS
  static const primary        = Color(0xFF1FA45B);
  static const primaryDark    = Color(0xFF0D7A40);
  static const primaryMid     = Color(0xFF32C56F);
  static const primaryLight   = Color(0xFFEAF8F0);
  static const primarySubtle  = Color(0xFFF5FCF7);
  static const primaryGlow    = Color(0xFFB9E8CB);

  // BACKGROUND
  static const bg             = Color(0xFFF4F7F5);
  static const white          = Colors.white;
  static const cardBg         = Color(0xFFFFFFFF);

  // TEXT
  static const textDark       = Color(0xFF111827);
  static const textMid        = Color(0xFF4B5563);
  static const textGrey       = Color(0xFF6B7280);
  static const textLight      = Color(0xFFB0B7C3);

  // BORDERS
  static const border         = Color(0xFFE5E7EB);
  static const borderGreen    = Color(0xFFD3F0DF);

  // STATUS COLORS
  static const danger         = Color(0xFFEF4444);
  static const dangerLight    = Color(0xFFFEF2F2);
  static const dangerDark     = Color(0xFF991B1B);

  static const amber          = Color(0xFFF59E0B);
  static const amberLight     = Color(0xFFFFF7ED);
  static const amberDark      = Color(0xFF92400E);

  static const blue           = Color(0xFF3B82F6);
  static const blueLight      = Color(0xFFEFF6FF);
  static const blueDark       = Color(0xFF1D4ED8);

  static const purple         = Color(0xFF8B5CF6);
  static const purpleLight    = Color(0xFFF5F3FF);
  static const purpleDark     = Color(0xFF6D28D9);

  static const teal           = Color(0xFF14B8A6);
  static const tealLight      = Color(0xFFF0FDFA);
  static const tealDark       = Color(0xFF0F766E);

  static const successText    = Color(0xFF166534);
  static const successDark    = Color(0xFF14532D);

  // FONT
  static const String font = 'Poppins';

  // PREMIUM CARD SHADOW
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(.03),
          blurRadius: 18,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: primary.withOpacity(.04),
          blurRadius: 30,
          spreadRadius: -8,
          offset: const Offset(0, 12),
        ),
      ];

  // NAV SHADOW
  static List<BoxShadow> get navShadow => [
        BoxShadow(
          color: primary.withOpacity(.10),
          blurRadius: 28,
          spreadRadius: -8,
          offset: const Offset(0, 10),
        ),
      ];

  // DISPLAY TEXT
  static TextStyle display(
    double size, {
    Color? color,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color ?? textDark,
        letterSpacing: letterSpacing ?? -0.4,
        height: 1.2,
      );

  // TITLES
  static TextStyle title(
    double size, {
    Color? color,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? textDark,
        letterSpacing: -0.2,
        height: 1.3,
      );

  // BODY
  static TextStyle body(
    double size, {
    Color? color,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? textMid,
        height: 1.5,
      );

  // LABELS
  static TextStyle label(
    double size, {
    Color? color,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? textGrey,
        letterSpacing: .2,
      );
}
// ─────────────────────────────────────────────────────────────
// ROOT SCREEN
// ─────────────────────────────────────────────────────────────
class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final dashboardService = DashboardService();
  Map<String, dynamic>? dashboardData;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final data = await dashboardService.getDashboard();
    if (data != null) setState(() => dashboardData = data);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardPage(dashboardData: dashboardData),
      CoursesPage(),
      AssignmentsPage(),
      const AIChatbotPage(),
      const ProfilePage(),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _T.bg,
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeIn,
          child: KeyedSubtree(
            key: ValueKey(_current),
            child: pages[_current],
          ),
        ),
        bottomNavigationBar: _FloatingNavBar(
          currentIndex: _current,
          onTap: (i) => setState(() => _current = i),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DASHBOARD PAGE
// ─────────────────────────────────────────────────────────────
class _DashboardPage extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _DashboardPage({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    if (dashboardData == null) {
      return Center(
        child: CircularProgressIndicator(color: _T.primary, strokeWidth: 3),
      );
    }

   return SafeArea(
    bottom: false,
    child: Column(
      children: [

      _TopBar(dashboardData: dashboardData),

  

        Expanded(
            child: ListView(
              // ✅ Tighter padding — was 16/16/16/120
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
              children: [
                _HeroBannerCard(dashboardData: dashboardData),
                const SizedBox(height: 10),  // ✅ was 14
                _WeeklyStreakCard(dashboardData: dashboardData),
                const SizedBox(height: 10),
                _StatsGrid(dashboardData: dashboardData),
                const SizedBox(height: 4),
                const _WeeklyProgressChart(),
                const SizedBox(height: 10),
                const _AssignmentsCard(),
                const SizedBox(height: 10),
                const _LiveClassesCard(),
                const SizedBox(height: 10),
                const _QuickActionsSection(),
                
                
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
  final Map<String, dynamic>? dashboardData;
  const _TopBar({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ Reduced vertical padding — was 12/14
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: _T.white,
        border: Border(bottom: BorderSide(color: _T.border, width: .8)),
        boxShadow: [
          BoxShadow(
            color: _T.primary.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,   // ✅ was 44
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_T.primaryMid, _T.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: _T.primary.withOpacity(.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _initials(dashboardData?["student_name"]),
                style: _T.display(13, color: Colors.white, letterSpacing: .5),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning 👋', style: _T.body(10, color: _T.textGrey)),
                Text(
                  dashboardData?["student_name"] ?? 'Student',
                  style: _T.display(16, color: _T.textDark),
                ),
              ],
            ),
          ),
          GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const _NotificationPopup(),
            );
          },
          child: _CircleBtn(
            icon: Icons.notifications_outlined,
            dot: true,
          ),
        ),
        ],
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return 'S';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final bool dot;
  const _CircleBtn({required this.icon, this.dot = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _T.primarySubtle,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: _T.borderGreen, width: 1),
          ),
          child: Icon(icon, size: 20, color: _T.primaryDark),
        ),
        if (dot)
          Positioned(
            right: 7,
            top: 7,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _T.danger,
                shape: BoxShape.circle,
                border: Border.all(color: _T.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HERO BANNER  ✅ reduced internal padding & text sizes
// ─────────────────────────────────────────────────────────────
class _HeroBannerCard extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _HeroBannerCard({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),   // ✅ was 20
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D05), Color(0xFF4DB810)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),  // ✅ was 26
        boxShadow: [
          BoxShadow(
            color: _T.primary.withOpacity(.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 10)),
                      const SizedBox(width: 4),
                      Text("Today's Focus",
                          style: _T.label(9, color: const Color(0xFFD4F4A5))),
                    ],
                  ),
                ),
                const SizedBox(height: 8),   // ✅ was 12
                Text(
                  'Keep the streak alive! 🔥',   // ✅ single line, was 2 lines
                  style: _T.display(18, color: Colors.white),  // ✅ was 22
                ),
                const SizedBox(height: 4),   // ✅ was 8
                Text(
                  '3 tasks left today',
                  style: _T.body(11, color: const Color(0xFFCEF0A2)),
                ),
                const SizedBox(height: 12),  // ✅ was 16
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.07),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View tasks', style: _T.title(11, color: _T.primaryDark)),
                      const SizedBox(width: 5),
                      Icon(Icons.arrow_forward_rounded, size: 13, color: _T.primaryDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 76,    // ✅ was 88
            height: 76,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: CircularProgressIndicator(
                    value: .72,
                    strokeWidth: 7,
                    backgroundColor: Colors.white.withOpacity(.2),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('72%', style: _T.display(18, color: Colors.white)),
                    Text('done', style: _T.label(8, color: const Color(0xFFCEF0A2))),
                  ],
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
// SHARED — Card wrapper & section header
// ─────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ Tighter default padding — was 18
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(18),  // ✅ was 22
        border: Border.all(color: _T.border, width: .8),
        boxShadow: _T.cardShadow,
      ),
      child: child,
    );
  }
}

// ✅ Fixed layout bug: was SizedBox(height:6) between title and Spacer — should be width
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final String? emoji;
  const _SectionHeader({required this.title, this.action, this.emoji});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (emoji != null) ...[
          Text(emoji!, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 5),
        ],
        Text(title, style: _T.title(14, color: _T.textDark)),
        const Spacer(),  // ✅ pushes action badge to the right
        if (action != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: _T.primarySubtle,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _T.borderGreen),
            ),
            child: Text(action!, style: _T.label(10, color: _T.successText)),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WEEKLY STREAK CARD  ✅ fixed Row alignment, tighter spacing
// ─────────────────────────────────────────────────────────────
class _WeeklyStreakCard extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _WeeklyStreakCard({this.dashboardData});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final streak = dashboardData?["weekly_streak"] ?? 5;

    return _Card(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _T.amberLight,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Center(child: Text('🔥', style: TextStyle(fontSize: 16))),
              ),
              const SizedBox(width: 8),
              Text('Weekly Streak', style: _T.title(14)),
              const Spacer(),  // ✅ was missing — badge was glued to title
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _T.amberLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _T.amber.withOpacity(.3), width: .8),
                ),
                child: Text(
                  '$streak day streak 🏆',
                  style: _T.label(10, color: _T.amberDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),   // ✅ was 18
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final done = i < (streak > 5 ? 5 : streak);
              final today = i == (streak > 5 ? 5 : streak) - 1 + 1;
              return _StreakDot(day: _days[i], done: done, today: today && i == 4);
            }),
          ),
        ],
      ),
    );
  }
}

class _StreakDot extends StatelessWidget {
  final String day;
  final bool done;
  final bool today;
  const _StreakDot({required this.day, this.done = false, this.today = false});

  @override
  Widget build(BuildContext context) {
    final active = done || today;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 36,    // ✅ was 38
          height: 36,
          decoration: BoxDecoration(
            color: today
                ? _T.primary
                : done
                    ? _T.primaryLight
                    : _T.bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? _T.primaryGlow : _T.border,
              width: active ? 1.5 : 1,
            ),
            boxShadow: today
                ? [BoxShadow(color: _T.primary.withOpacity(.3), blurRadius: 8, offset: const Offset(0, 3))]
                : [],
          ),
          child: Center(
            child: done
                ? Icon(Icons.check_rounded, size: 16, color: today ? Colors.white : _T.successDark)
                : today
                    ? const Text('✨', style: TextStyle(fontSize: 14))
                    : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: TextStyle(
            fontFamily: _T.font,
            fontSize: 10,
            color: active ? _T.primary : _T.textLight,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STATS GRID  ✅ better aspect ratio — was 0.95 (too tall)
// ─────────────────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _StatsGrid({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.15,   // ✅ was 0.95 — cards were too tall
      crossAxisSpacing: 10,     // ✅ was 12
      mainAxisSpacing: 10,
      children: [
        _StatCard(
          emoji: '📚',
          accentColor: _T.blue,
          accentBg: _T.blueLight,
          value: dashboardData?["courses_enrolled"]?.toString() ?? '4',
          label: 'Courses Enrolled',
          sub: '3 in progress',
          progress: .60,
        ),
        _StatCard(
          emoji: '⏱️',
          accentColor: _T.primary,
          accentBg: _T.primaryLight,
          value: dashboardData?["study_hours"]?.toString() ?? '12.5h',
          label: 'Studied This Week',
          sub: 'Goal: 16h',
          progress: .75,
        ),
        _StatCard(
          emoji: '📝',
          accentColor: _T.purple,
          accentBg: _T.purpleLight,
          value: dashboardData?["assignments_done"]?.toString() ?? '8/11',
          label: 'Assignments Done',
          sub: '3 pending',
          progress: .73,
        ),
        _StatCard(
          emoji: '🎯',
          accentColor: _T.teal,
          accentBg: _T.tealLight,
          value: dashboardData?["attendance"]?.toString() ?? '92%',
          label: 'Attendance',
          sub: 'Excellent!',
          progress: .92,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final Color accentColor;
  final Color accentBg;
  final String value;
  final String label;
  final String sub;
  final double progress;

  const _StatCard({
    required this.emoji,
    required this.accentColor,
    required this.accentBg,
    required this.value,
    required this.label,
    required this.sub,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),   // ✅ was 14
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _T.border, width: .8),
        boxShadow: _T.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,    // ✅ was 38
            height: 34,
            decoration: BoxDecoration(
              color: accentBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(height: 8),    // ✅ was 10
          Text(value, style: _T.display(20, color: _T.textDark)),   // ✅ was 22
          const SizedBox(height: 2),
          Text(label, style: _T.body(9, color: _T.textGrey), maxLines: 1),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: accentBg,
              valueColor: AlwaysStoppedAnimation(accentColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(sub, style: _T.label(9, color: accentColor)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WEEKLY PROGRESS CHART  ✅ reduced chart height
// ─────────────────────────────────────────────────────────────
class _WeeklyProgressChart extends StatelessWidget {
  const _WeeklyProgressChart();

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _values = [40, 80, 55, 90, 60, 35, 20];

  @override
  Widget build(BuildContext context) {
    final maxVal = _values.reduce((a, b) => a > b ? a : b);

    return _Card(
      child: Column(
        children: [
          _SectionHeader(
            title: 'Weekly Progress',
            emoji: '📊',
            action: 'This week',
          ),
          const SizedBox(height: 14),   // ✅ was 18
          SizedBox(
            height: 90,    // ✅ was 110
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_values.length, (i) {
                final isMax = _values[i] == maxVal;
                final barH = (_values[i] / maxVal) * 90;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isMax)
                          Container(
                            margin: const EdgeInsets.only(bottom: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: _T.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text('🏆', style: TextStyle(fontSize: 8)),
                          ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400 + i * 60),
                          curve: Curves.easeOutCubic,
                          height: barH,
                          decoration: BoxDecoration(
                            color: isMax ? _T.primary : _T.primaryLight,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(7)),
                            boxShadow: isMax
                                ? [BoxShadow(color: _T.primary.withOpacity(.28), blurRadius: 6, offset: const Offset(0, -2))]
                                : [],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _days[i].substring(0, 1),
                          style: TextStyle(
                            fontFamily: _T.font,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isMax ? _T.primary : _T.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ASSIGNMENTS CARD  ✅ tighter tile vertical padding
// ─────────────────────────────────────────────────────────────
class _AssignmentsCard extends StatelessWidget {
  const _AssignmentsCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: const [
          _SectionHeader(title: 'Pending Assignments', emoji: '📋', action: 'View all'),
          SizedBox(height: 10),   // ✅ was 14
          _AssignTile(
            emoji: '🧮',
            accentBg: Color(0xFFEEEDFE),
            accentColor: Color(0xFF3C3489),
            title: 'Algebra — Chapter 5',
            subject: 'Mathematics',
            badge: 'Due today',
            badgeBg: Color(0xFFFCEBEB),
            badgeColor: Color(0xFF791F1F),
          ),
          _AssignTile(
            emoji: '🔬',
            accentBg: Color(0xFFE6F1FB),
            accentColor: Color(0xFF0C447C),
            title: "Newton's laws worksheet",
            subject: 'Physics',
            badge: '2 days',
            badgeBg: Color(0xFFFAEEDA),
            badgeColor: Color(0xFF633806),
          ),
          _AssignTile(
            emoji: '✍️',
            accentBg: Color(0xFFE8F5DC),
            accentColor: Color(0xFF1A4706),
            title: 'Essay — Industrial Rev.',
            subject: 'History',
            badge: '5 days',
            badgeBg: Color(0xFFE8F5DC),
            badgeColor: Color(0xFF1A4706),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _AssignTile extends StatelessWidget {
  final String emoji;
  final Color accentBg;
  final Color accentColor;
  final String title;
  final String subject;
  final String badge;
  final Color badgeBg;
  final Color badgeColor;
  final bool isLast;

  const _AssignTile({
    required this.emoji,
    required this.accentBg,
    required this.accentColor,
    required this.title,
    required this.subject,
    required this.badge,
    required this.badgeBg,
    required this.badgeColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),   // ✅ was 12
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: _T.border, width: .8)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,    // ✅ was 44
            height: 40,
            decoration: BoxDecoration(
              color: accentBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _T.title(12, color: _T.textDark)),
                const SizedBox(height: 2),
                Text(subject, style: _T.body(10, color: _T.textGrey)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge, style: _T.label(10, color: badgeColor)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LIVE CLASSES CARD
// ─────────────────────────────────────────────────────────────
class _LiveClassesCard extends StatelessWidget {
  const _LiveClassesCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: const [
          _SectionHeader(title: 'Live Classes Today', emoji: '🎥', action: 'Full schedule'),
          SizedBox(height: 10),
          _LiveTile(
            title: 'Chemistry — Periodic table',
            teacher: 'Mrs. Priya',
            detail: '32 students joined',
            live: true,
          ),
          _LiveTile(
            title: 'English — Essay writing',
            teacher: 'Mr. Raj',
            detail: 'Starts at 11:30 AM',
            time: '11:30',
          ),
          _LiveTile(
            title: 'Mathematics — Calculus',
            teacher: 'Ms. Anita',
            detail: 'Starts at 2:00 PM',
            time: '2:00',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _LiveTile extends StatelessWidget {
  final String title;
  final String teacher;
  final String detail;
  final bool live;
  final String? time;
  final bool isLast;

  const _LiveTile({
    required this.title,
    required this.teacher,
    required this.detail,
    this.live = false,
    this.time,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),   // ✅ was 12
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: _T.border, width: .8)),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: live ? _T.danger : _T.amber,
              shape: BoxShape.circle,
              boxShadow: live
                  ? [BoxShadow(color: _T.danger.withOpacity(.4), blurRadius: 7, spreadRadius: 1)]
                  : [],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _T.title(12, color: _T.textDark)),
                const SizedBox(height: 2),
                Text('$teacher · $detail', style: _T.body(10, color: _T.textGrey)),
              ],
            ),
          ),
          if (live)
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_T.primaryMid, _T.primaryDark]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: _T.primary.withOpacity(.3), blurRadius: 7, offset: const Offset(0, 2))
                  ],
                ),
                child: Text('Join 🚀', style: _T.title(11, color: Colors.white)),
              ),
            )
          else
            Text(time ?? '', style: _T.title(11, color: _T.textGrey)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// QUICK ACTIONS  ✅ better aspect ratio
// ─────────────────────────────────────────────────────────────
class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Quick Actions', emoji: '⚡'),
        const SizedBox(height: 10),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 2.4,   // ✅ was 2.0 — buttons were too tall
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: const [
            _QuickBtn(
              emoji: '📤',
              label: 'Submit Homework',
              accentBg: Color(0xFFEEEDFE),
              accentColor: Color(0xFF3C3489),
            ),
            _QuickBtn(
              emoji: '🤖',
              label: 'Ask AI Tutor',
              accentBg: Color(0xFFE8F5DC),
              accentColor: Color(0xFF256E04),
            ),
            _QuickBtn(
              emoji: '🧩',
              label: 'Practice Quiz',
              accentBg: Color(0xFFE1F5EE),
              accentColor: Color(0xFF0F6E56),
            ),
            _QuickBtn(
              emoji: '🏅',
              label: 'My Certificates',
              accentBg: Color(0xFFFAEEDA),
              accentColor: Color(0xFF633806),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final String emoji;
  final String label;
  final Color accentBg;
  final Color accentColor;

  const _QuickBtn({
    required this.emoji,
    required this.label,
    required this.accentBg,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _T.border, width: .8),
        boxShadow: _T.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 32,    // ✅ was 36
            height: 32,
            decoration: BoxDecoration(
              color: accentBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 15))),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: _T.title(11, color: _T.textDark), maxLines: 2),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// NOTIFICATIONS CARD
// ─────────────────────────────────────────────────────────────
class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: const [
          _SectionHeader(title: 'Notifications', emoji: '🔔', action: 'All'),
          SizedBox(height: 10),
          _NotifTile(
            emoji: '⚠️',
            bgColor: Color(0xFFFCEBEB),
            title: 'Assignment due today',
            subtitle: 'Algebra Chapter 5 is due by 11:59 PM',
            time: '10 min ago',
            timeColor: Color(0xFFE24B4A),
          ),
          _NotifTile(
            emoji: '🏆',
            bgColor: Color(0xFFE8F5DC),
            title: 'Marks published',
            subtitle: 'Physics test results are now available',
            time: '1 hr ago',
            timeColor: Color(0xFF3A9E09),
          ),
          _NotifTile(
            emoji: '📹',
            bgColor: Color(0xFFE6F1FB),
            title: 'Live class reminder',
            subtitle: 'English class starts in 30 minutes',
            time: '2 hr ago',
            timeColor: Color(0xFF378ADD),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final String emoji;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String time;
  final Color timeColor;
  final bool isLast;

  const _NotifTile({
    required this.emoji,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.timeColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),   // ✅ was 12
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: _T.border, width: .8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,    // ✅ was 42
            height: 38,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _T.title(12, color: _T.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: _T.body(10, color: _T.textGrey)),
                const SizedBox(height: 4),
                Text(time, style: _T.label(10, color: timeColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _NotificationPopup extends StatelessWidget {
  const _NotificationPopup();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: _T.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [

          // TOP HANDLE
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: _T.border,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 18),

          // TITLE
          Row(
            children: [
              Text(
                "Notifications",
                style: _T.display(20),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // LIST
          const Expanded(
            child: SingleChildScrollView(
              child: _NotificationsCard(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FLOATING NAV BAR
// ─────────────────────────────────────────────────────────────
class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _FloatingNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'Courses'),
    (Icons.assignment_outlined, Icons.assignment_rounded, 'Tasks'),
    (Icons.smart_toy_outlined, Icons.smart_toy_rounded, 'AI'),
    (Icons.person_outline, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),  // ✅ was 16/0/16/12
        child: Container(
          height: 66,   // ✅ was 72
          decoration: BoxDecoration(
            color: _T.white,
            borderRadius: BorderRadius.circular(24),  // ✅ was 28
            border: Border.all(color: _T.borderGreen, width: 1.5),
            boxShadow: _T.navShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (i) => _NavTile(
                icon: _items[i].$1,
                activeIcon: _items[i].$2,
                label: _items[i].$3,
                active: currentIndex == i,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(i);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,    // ✅ was 64
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: active ? 44 : 34,   // ✅ was 48/38
              height: 30,                // ✅ was 34
              decoration: BoxDecoration(
                color: active ? _T.primaryLight : Colors.transparent,
                borderRadius: BorderRadius.circular(11),
                boxShadow: active
                    ? [BoxShadow(color: _T.primary.withOpacity(.13), blurRadius: 6, offset: const Offset(0, 2))]
                    : [],
              ),
              child: Icon(
                active ? activeIcon : icon,
                color: active ? _T.primary : _T.textLight,
                size: active ? 20 : 19,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: _T.font,
                fontSize: 9,    // ✅ was 10
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? _T.primary : _T.textLight,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}