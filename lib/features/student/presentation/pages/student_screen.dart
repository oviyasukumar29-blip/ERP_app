// features/student/presentation/pages/student_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'courses_page.dart';
import 'assignments_page.dart';
import 'ai_chatbot_page.dart';
import 'profile_page.dart';

// ─────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────
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
  static const textLight     = Color(0xFFBBBBBB);

  static const border        = Color(0xFFE8E8E8);
  static const borderGreen   = Color(0xFFCCE8B0);

  static const danger        = Color(0xFFE24B4A);
  static const dangerLight   = Color(0xFFFCEBEB);
  static const dangerDark    = Color(0xFF791F1F);

  static const amber         = Color(0xFFEF9F27);
  static const amberLight    = Color(0xFFFAEEDA);
  static const amberDark     = Color(0xFF633806);

  static const blue          = Color(0xFF378ADD);
  static const blueLight     = Color(0xFFE6F1FB);
  static const blueDark      = Color(0xFF0C447C);

  static const purple        = Color(0xFF7F77DD);
  static const purpleLight   = Color(0xFFEEEDFE);
  static const purpleDark    = Color(0xFF3C3489);

  static const teal          = Color(0xFF1D9E75);
  static const tealLight     = Color(0xFFE1F5EE);
  static const tealDark      = Color(0xFF0F6E56);

  static const successText   = Color(0xFF3B6D11);
  static const successDark   = Color(0xFF27500A);

  static final navShadow = BoxShadow(
    color: primary.withOpacity(.15),
    blurRadius: 28,
    offset: const Offset(0, 10),
  );
}

// ─────────────────────────────────────────────────────────────
// ROOT
// ─────────────────────────────────────────────────────────────
class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int _current = 0;

  final _pages = const [
    _DashboardPage(),
    CoursesPage(),
    AssignmentsPage(),
    const AIChatbotPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _T.bg,
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeIn,
          child: KeyedSubtree(
            key: ValueKey(_current),
            child: _pages[_current],
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
// DASHBOARD
// ─────────────────────────────────────────────────────────────
class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

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
                _HeroBanner(),
                SizedBox(height: 12),
                _WeeklyStreakCard(),
                SizedBox(height: 12),
                _StatsGrid(),
                SizedBox(height: 12),
                _AssignmentsCard(),
                SizedBox(height: 12),
                _LiveClassesCard(),
                SizedBox(height: 12),
                _QuickActions(),
                SizedBox(height: 12),
                _NotificationsCard(),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _T.primaryLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _T.primaryGlow, width: 1.5),
            ),
            child: const Center(
              child: Text(
                'AK',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _T.primaryDark,
                  letterSpacing: .3,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good morning 👋',
                  style: TextStyle(
                    fontSize: 11,
                    color: _T.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Arjun Kumar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _T.textDark,
                    letterSpacing: -.3,
                  ),
                ),
              ],
            ),
          ),
          _IconBtn(icon: Icons.notifications_none_rounded, dot: true),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool dot;

  const _IconBtn({required this.icon, this.dot = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _T.bg,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: _T.border, width: .6),
          ),
          child: Icon(icon, size: 22, color: _T.textDark),
        ),
        if (dot)
          Positioned(
            right: 6,
            top: 6,
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
// HERO BANNER
// ─────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _T.primary.withOpacity(.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Today's focus",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _T.primaryGlow,
                      letterSpacing: .4,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Keep the streak\nalive! 🔥',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _T.white,
                    height: 1.2,
                    letterSpacing: -.3,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '3 tasks left to complete today',
                  style: TextStyle(
                    fontSize: 11,
                    color: _T.primaryGlow,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _T.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'View tasks →',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _T.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: .72,
                  strokeWidth: 7,
                  backgroundColor: _T.primary.withOpacity(.25),
                  valueColor: const AlwaysStoppedAnimation(_T.primaryGlow),
                  strokeCap: StrokeCap.round,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '72%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _T.white,
                        letterSpacing: -.5,
                      ),
                    ),
                    Text(
                      'done',
                      style: TextStyle(
                        fontSize: 9,
                        color: _T.primaryGlow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────
class _CardBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _CardBox({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _T.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _T.border, width: .5),
      ),
      child: child,
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: _T.textDark,
            letterSpacing: -.2,
          ),
        ),
        const Spacer(),
        if (action != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
// WEEKLY STREAK
// ─────────────────────────────────────────────────────────────
class _WeeklyStreakCard extends StatelessWidget {
  const _WeeklyStreakCard();

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _T.amberLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFBA7517),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Weekly streak',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: -.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _T.amberLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 11)),
                    SizedBox(width: 4),
                    Text(
                      '5 day streak',
                      style: TextStyle(
                        color: _T.amberDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _StreakDay(day: 'Mon', done: true),
              _StreakDay(day: 'Tue', done: true),
              _StreakDay(day: 'Wed', done: true),
              _StreakDay(day: 'Thu', done: true),
              _StreakDay(day: 'Fri', today: true),
              _StreakDay(day: 'Sat'),
              _StreakDay(day: 'Sun'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakDay extends StatelessWidget {
  final String day;
  final bool done;
  final bool today;

  const _StreakDay({required this.day, this.done = false, this.today = false});

  @override
  Widget build(BuildContext context) {
    final active = done || today;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: today ? _T.primary : done ? _T.primaryLight : _T.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? _T.primaryGlow : _T.border,
              width: active ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: done
                ? Icon(Icons.check_rounded,
                    size: 16,
                    color: today ? _T.white : _T.successDark)
                : today
                    ? const Text(
                        '5',
                        style: TextStyle(
                          color: _T.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      )
                    : null,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          day,
          style: TextStyle(
            fontSize: 10,
            color: active ? _T.primary : _T.textLight,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STATS GRID  ← overflow fix applied here
// ─────────────────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.05,   // ← was 1.15, increased height
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: const [
        _StatCard(
          icon: Icons.menu_book_rounded,
          iconColor: _T.blueDark,
          iconBg: _T.blueLight,
          value: '4',
          label: 'Courses enrolled',
          sub: '3 in progress',
          progress: .60,
          progressColor: _T.blue,
        ),
        _StatCard(
          icon: Icons.schedule_rounded,
          iconColor: _T.successText,
          iconBg: _T.primarySubtle,
          value: '12.5h',
          label: 'Studied this week',
          sub: 'Goal: 16h',
          progress: .75,
          progressColor: _T.primary,
        ),
        _StatCard(
          icon: Icons.assignment_turned_in_rounded,
          iconColor: _T.purpleDark,
          iconBg: _T.purpleLight,
          value: '8/11',
          label: 'Assignments done',
          sub: '3 pending',
          progress: .73,
          progressColor: _T.purple,
        ),
        _StatCard(
          icon: Icons.calendar_month_rounded,
          iconColor: _T.tealDark,
          iconBg: _T.tealLight,
          value: '92%',
          label: 'Attendance',
          sub: 'This month',
          progress: .92,
          progressColor: _T.teal,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final String sub;
  final double progress;
  final Color progressColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    required this.sub,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),   // ← was 14, reduced
      decoration: BoxDecoration(
        color: _T.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _T.border, width: .5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 17),  // ← was 18
          ),
          const SizedBox(height: 8),   // ← was 10
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,             // ← was 22
              fontWeight: FontWeight.w800,
              color: _T.textDark,
              letterSpacing: -.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,             // ← was 11
              color: _T.textGrey,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),   // ← was 10
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,             // ← was 5
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
          const SizedBox(height: 6),   // ← was 7
          Text(
            sub,
            style: TextStyle(
              color: iconColor,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ASSIGNMENTS CARD (dashboard preview)
// ─────────────────────────────────────────────────────────────
class _AssignmentsCard extends StatelessWidget {
  const _AssignmentsCard();

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      child: Column(
        children: const [
          _SectionHeader(title: 'Pending assignments', action: 'View all'),
          SizedBox(height: 12),
          _AssignmentTile(
            icon: Icons.calculate_rounded,
            iconBg: _T.purpleLight,
            iconColor: _T.purpleDark,
            title: 'Algebra — Chapter 5',
            subtitle: 'Mathematics · Due today',
            badge: 'Due today',
            badgeBg: _T.dangerLight,
            badgeText: _T.dangerDark,
          ),
          _AssignmentTile(
            icon: Icons.science_rounded,
            iconBg: _T.blueLight,
            iconColor: _T.blueDark,
            title: "Newton's laws worksheet",
            subtitle: 'Physics · Due in 2 days',
            badge: '2 days',
            badgeBg: _T.amberLight,
            badgeText: _T.amberDark,
          ),
          _AssignmentTile(
            icon: Icons.edit_note_rounded,
            iconBg: _T.primaryLight,
            iconColor: _T.successDark,
            title: 'Essay — Industrial Rev.',
            subtitle: 'History · Due in 5 days',
            badge: '5 days',
            badgeBg: _T.primaryLight,
            badgeText: _T.successDark,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _AssignmentTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeBg;
  final Color badgeText;
  final bool isLast;

  const _AssignmentTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeBg,
    required this.badgeText,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: _T.border, width: .5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _T.textDark)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: _T.textGrey)),
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
            child: Text(badge,
                style: TextStyle(
                    color: badgeText,
                    fontWeight: FontWeight.w700,
                    fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LIVE CLASSES
// ─────────────────────────────────────────────────────────────
class _LiveClassesCard extends StatelessWidget {
  const _LiveClassesCard();

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      child: Column(
        children: const [
          _SectionHeader(title: 'Live classes today', action: 'Full schedule'),
          SizedBox(height: 12),
          _LiveClassTile(
            title: 'Chemistry — Periodic table',
            subtitle: 'Mrs. Priya · Live now · 32 joined',
            live: true,
          ),
          _LiveClassTile(
            title: 'English — Essay writing',
            subtitle: 'Mr. Raj · Starts at 11:30 AM',
            time: '11:30',
          ),
          _LiveClassTile(
            title: 'Mathematics — Calculus',
            subtitle: 'Ms. Anita · Starts at 2:00 PM',
            time: '2:00',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _LiveClassTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool live;
  final String? time;
  final bool isLast;

  const _LiveClassTile({
    required this.title,
    required this.subtitle,
    this.live = false,
    this.time,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: _T.border, width: .5)),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: live ? _T.danger : _T.amber,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _T.textDark)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: _T.textGrey)),
              ],
            ),
          ),
          if (live)
            GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: _T.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Join',
                    style: TextStyle(
                        color: _T.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            )
          else
            Text(time ?? '',
                style: const TextStyle(
                    color: _T.textGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// QUICK ACTIONS
// ─────────────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Quick actions'),
        const SizedBox(height: 12),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 2.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: const [
            _QuickActionButton(
              icon: Icons.upload_rounded,
              iconColor: _T.purpleDark,
              iconBg: _T.purpleLight,
              label: 'Submit homework',
            ),
            _QuickActionButton(
              icon: Icons.smart_toy_rounded,
              iconColor: _T.successDark,
              iconBg: _T.primaryLight,
              label: 'Ask AI tutor',
            ),
            _QuickActionButton(
              icon: Icons.quiz_rounded,
              iconColor: _T.tealDark,
              iconBg: _T.tealLight,
              label: 'Practice quiz',
            ),
            _QuickActionButton(
              icon: Icons.workspace_premium_rounded,
              iconColor: _T.amberDark,
              iconBg: _T.amberLight,
              label: 'My certificates',
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;

  const _QuickActionButton({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: _T.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _T.border, width: .5),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: _T.textDark)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// NOTIFICATIONS
// ─────────────────────────────────────────────────────────────
class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard();

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      child: Column(
        children: const [
          _SectionHeader(title: 'Notifications', action: 'All'),
          SizedBox(height: 12),
          _NotificationTile(
            icon: Icons.error_outline_rounded,
            iconBg: _T.dangerLight,
            iconColor: _T.dangerDark,
            title: 'Assignment due today',
            subtitle: 'Algebra Chapter 5 is due by 11:59 PM',
            time: '10 min ago',
          ),
          _NotificationTile(
            icon: Icons.workspace_premium_rounded,
            iconBg: _T.primaryLight,
            iconColor: _T.successDark,
            title: 'Marks published',
            subtitle: 'Physics test results are now available',
            time: '1 hr ago',
          ),
          _NotificationTile(
            icon: Icons.videocam_rounded,
            iconBg: _T.blueLight,
            iconColor: _T.blueDark,
            title: 'Live class reminder',
            subtitle: 'English class starts in 30 minutes',
            time: '2 hr ago',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isLast;

  const _NotificationTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: _T.border, width: .5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: _T.textDark)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: _T.textGrey, fontSize: 11, height: 1.4)),
                const SizedBox(height: 5),
                Text(time,
                    style: const TextStyle(
                        color: _T.textLight, fontSize: 10)),
              ],
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
    (Icons.home_outlined,       Icons.home_rounded,       'Home'),
    (Icons.menu_book_outlined,  Icons.menu_book_rounded,  'Courses'),
    (Icons.assignment_outlined, Icons.assignment_rounded, 'Tasks'),
    (Icons.smart_toy_outlined,  Icons.smart_toy_rounded,  'AI'),
    (Icons.person_outline,      Icons.person_rounded,     'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: _T.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _T.borderGreen, width: 1.5),
            boxShadow: [_T.navShadow],
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
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: active ? 46 : 36,
              height: 32,
              decoration: BoxDecoration(
                color: active ? _T.primaryLight : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                active ? activeIcon : icon,
                color: active ? _T.primary : const Color(0xFFC0D8A8),
                size: active ? 22 : 20,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                color: active ? _T.primary : const Color(0xFFC0D8A8),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PLACEHOLDER PAGES
// ─────────────────────────────────────────────────────────────

