part of 'student_screen.dart';

class _DashboardPage extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  final VoidCallback onOpenAiTutor;
  final VoidCallback onOpenCoding;
  final VoidCallback onOpenCertificates;
  final VoidCallback onOpenProfile;
  const _DashboardPage({
    this.dashboardData,
    required this.onOpenAiTutor,
    required this.onOpenCoding,
    required this.onOpenCertificates,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _TopBar(dashboardData: dashboardData, onOpenProfile: onOpenProfile),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                _HeroBannerCard(dashboardData: dashboardData),
                const SizedBox(height: 14),
                _WeeklyStreakCard(dashboardData: dashboardData),
                const SizedBox(height: 14),
                _StatsRow(dashboardData: dashboardData),
                const SizedBox(height: 14),
                const _ProgressChartCard(),
                const SizedBox(height: 14),
                _AssignmentsWidget(dashboardData: dashboardData),
                const SizedBox(height: 14),
                const _LiveClassesWidget(),
                const SizedBox(height: 14),
                _QuickActionsWidget(
                  onOpenAiTutor: onOpenAiTutor,
                  onOpenCoding: onOpenCoding,
                  onOpenCertificates: onOpenCertificates,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// TOP BAR
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _TopBar extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  final VoidCallback onOpenProfile;
  const _TopBar({this.dashboardData, required this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: _T.bg,
      child: Row(
        children: [
          GestureDetector(
            onTap: onOpenProfile,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                // #1CB0F6 â†’ #2B70C9 gradient (palette)
                gradient: const LinearGradient(
                  colors: [Color(0xFF1CB0F6), Color(0xFF2B70C9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "K",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onOpenProfile,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("KIDLEARN", style: _T.title3()),
                  Text(
                    dashboardData?["student_name"] != null
                        ? "Hello, ${dashboardData!["student_name"]} ðŸ‘‹"
                        : "Good morning ðŸ‘‹",
                    style: _T.caption1(),
                  ),
                ],
              ),
            ),
          ),
          // XP badge â€” #1CB0F6 (palette)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _T.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.diamond_rounded,
                  color: Colors.white,
                  size: 13,
                ),
                const SizedBox(width: 5),
                Text(
                  "${dashboardData?["xp"] ?? 0} XP",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Bell
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const _NotificationSheet(),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _T.bgElevated,
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: _T.labelTertiary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// HERO BANNER â€” #58CC02 green card
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _HeroBannerCard extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _HeroBannerCard({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    final progress = _progressValue(dashboardData?["course_progress"]);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _T.green, // #58CC02
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _T.greenDark.withOpacity(.35),
            blurRadius: 28,
            offset: const Offset(0, 8),
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
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Learning Progress",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(.90),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  dashboardData?["continue_course"] ?? "Keep Learning",
                  style: _T.title3(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  dashboardData?["course_progress_text"] ?? "0% Completed",
                  style: _T.subheadline(color: Colors.white70),
                ),
                const SizedBox(height: 14),
                // Progress bar: track = white 20%, fill = white
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.25),
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
                    Text("Continue", style: _T.caption1(color: Colors.white70)),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white54,
                      size: 11,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const _3DBookIllustration(size: 84),
        ],
      ),
    );
  }

  double _progressValue(dynamic value) {
    final number = value is num
        ? value.toDouble()
        : value is String
        ? double.tryParse(value) ?? 0
        : 0.0;
    return number.clamp(0, 100).toDouble();
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// WEEKLY STREAK CARD
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _WeeklyStreakCard extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _WeeklyStreakCard({this.dashboardData});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final streak = _intValue(dashboardData?["weekly_streak"], fallback: 0);
    final todayIndex = DateTime.now().weekday - DateTime.monday;
    final streakStartIndex = (todayIndex - streak + 1).clamp(0, 6);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _T.widgetCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Study Streak", style: _T.headline()),
                    Text("Keep it going!", style: _T.caption1()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _T.orange.withOpacity(.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 5),
                    Text(
                      '$streak days',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _T.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(7, (i) {
              final active =
                  streak > 0 && i >= streakStartIndex && i <= todayIndex;
              final isToday = i == todayIndex;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        height: 32,
                        decoration: BoxDecoration(
                          // active = #FF9600, inactive = very pale #FF9600
                          color: active
                              ? _T.orange
                              : _T.orange.withOpacity(.08),
                          borderRadius: BorderRadius.circular(9),
                          border: isToday
                              ? Border.all(color: _T.red, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: active
                              ? const Text('🔥', style: TextStyle(fontSize: 16))
                              : Text(_days[i], style: _T.caption2()),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _days[i],
                        style: _T.caption2(
                          color: active ? _T.orange : _T.labelQuaternary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  int _intValue(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// STATS ROW â€” 3 mini stat cards (font size REDUCED to 16)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _StatsRow extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _StatsRow({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniStat(
            icon: Icons.timer_rounded,
            color: _T.green,
            value: dashboardData?["study_hours"]?.toString() ?? '0',
            unit: 'hrs',
            label: 'Studied',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniStat(
            icon: Icons.emoji_events_rounded,
            color: _T.yellow,
            value: dashboardData?["attendance"]?.toString() ?? 'Present',
            unit: '',
            label: 'Attendance',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniStat(
            icon: Icons.check_circle_rounded,
            color: _T.purple,
            value: dashboardData?["assignments_done"]?.toString() ?? '0/0',
            unit: '',
            label: 'Tasks',
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String unit;
  final String label;

  const _MiniStat({
    required this.icon,
    required this.color,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.38),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 15),
          ),
          const SizedBox(height: 8),
          // â”€â”€ REDUCED font: 16 (was 20) â”€â”€
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.inter(
                    fontSize: 16, // â† reduced from 20
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: GoogleFonts.inter(
                      fontSize: 10, // â† reduced from 11
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Text(label, style: _T.caption1(color: Colors.white70)),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// PROGRESS CHART CARD
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _ProgressChartCard extends StatelessWidget {
  const _ProgressChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _T.widgetCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Weekly Activity", style: _T.headline()),
              const Spacer(),
              Text("This week", style: _T.caption1(color: _T.blue)),
            ],
          ),
          const SizedBox(height: 16),
          _ActivityBars(),
        ],
      ),
    );
  }
}

class _ActivityBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final values = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final isToday = i == DateTime.now().weekday - DateTime.monday;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400 + i * 60),
                    curve: Curves.easeOutCubic,
                    height: 70 * values[i],
                    decoration: BoxDecoration(
                      // #1CB0F6 full or 20% opacity
                      color: isToday
                          ? _T.blueDeep
                          : _T.blueDeep.withOpacity(.20),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    days[i],
                    style: _T.caption2(
                      color: isToday ? _T.blue : _T.labelQuaternary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// ASSIGNMENTS WIDGET
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AssignmentsWidget extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _AssignmentsWidget({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    final assignments = (dashboardData?["assignments"] as List?) ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: "📝 Pending Assignments",
          action: assignments.isEmpty ? "" : "See All",
        ),
        const SizedBox(height: 10),
        Container(
          decoration: _T.widgetCard,
          child: assignments.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "No pending tasks",
                    style: _T.subheadline(color: _T.labelTertiary),
                  ),
                )
              : Column(
                  children: List.generate(assignments.length, (i) {
                    final assignment = assignments[i] as Map<String, dynamic>;
                    final due = assignment["due"]?.toString() ?? "Pending";
                    return _AssignmentRow(
                      emoji: '📚',
                      title: assignment["title"]?.toString() ?? "Assignment",
                      due: due,
                      danger: due.toLowerCase().contains("today"),
                      last: i == assignments.length - 1,
                    );
                  }),
                ),
        ),
      ],
    );
  }
}

class _AssignmentRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String due;
  final bool danger;
  final bool last;

  const _AssignmentRow({
    required this.emoji,
    required this.title,
    required this.due,
    required this.danger,
    required this.last,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: _T.separator, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: danger
                  ? _T.red.withOpacity(.10)
                  : _T.green.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _T.subheadline(color: _T.labelPrimary)),
                const SizedBox(height: 2),
                Text(
                  due,
                  style: _T.caption1(color: danger ? _T.red : _T.labelTertiary),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: _T.labelQuaternary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// LIVE CLASSES WIDGET â€” grouped list style (like Pending card)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _LiveClassesWidget extends StatelessWidget {
  const _LiveClassesWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: "🎥 Live Classes", action: "View All"),
        const SizedBox(height: 10),
        Container(
          decoration: _T.widgetCard,
          child: const Column(
            children: [
              _LiveClassRow(
                emoji: '📐',
                subject: "📐 Mathematics",
                teacher: "Mr. Kumar",
                time: "10:00 AM",
                accentColor: _T.blue,
                tint: _T.tintBlue,
                isLive: true,
                last: false,
              ),
              _LiveClassRow(
                emoji: '⚗️',
                subject: "🔬 Physics",
                teacher: "Ms. Priya",
                time: "12:30 PM",
                accentColor: _T.purple,
                tint: _T.tintPurple,
                isLive: false,
                last: false,
              ),
              _LiveClassRow(
                emoji: '✏️',
                subject: "📖 English",
                teacher: "Mr. Rajan",
                time: "2:00 PM",
                accentColor: _T.green,
                tint: _T.tintGreen,
                isLive: false,
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LiveClassRow extends StatelessWidget {
  final String emoji;
  final String subject;
  final String teacher;
  final String time;
  final Color accentColor;
  final Color tint;
  final bool isLive;
  final bool last;

  const _LiveClassRow({
    required this.emoji,
    required this.subject,
    required this.teacher,
    required this.time,
    required this.accentColor,
    required this.tint,
    required this.isLive,
    required this.last,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: _T.separator, width: 0.5)),
      ),
      child: Row(
        children: [
          // Emoji icon box â€” same style as assignment row
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),

          // Subject + teacher + time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      subject,
                      style: _T.subheadline(color: _T.labelPrimary),
                    ),
                    if (isLive) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _T.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "LIVE",
                              style: GoogleFonts.inter(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  "${teacher}  Â·  $time",
                  style: _T.caption1(color: _T.labelTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Join button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isLive ? accentColor : tint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Join",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isLive ? Colors.white : accentColor,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// QUICK ACTIONS
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _QuickActionsWidget extends StatelessWidget {
  final VoidCallback onOpenAiTutor;
  final VoidCallback onOpenCoding;
  final VoidCallback onOpenCertificates;
  const _QuickActionsWidget({
    required this.onOpenAiTutor,
    required this.onOpenCoding,
    required this.onOpenCertificates,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: "Quick Actions", action: ""),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.upload_rounded,
                label: "📝 Submit",
                color: _T.green,
                tint: _T.tintGreen,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAction(
                icon: Icons.auto_awesome_rounded,
                label: "✨ AI Tutor",
                color: _T.blue,
                tint: _T.tintBlue,
                onTap: onOpenAiTutor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAction(
                icon: Icons.code_rounded,
                label: "🐍 Python",
                color: _T.purple,
                tint: _T.tintPurple,
                onTap: onOpenCoding,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.workspace_premium_rounded,
                label: "🏆 Certificate",
                color: _T.orange,
                tint: _T.tintOrange,
                onTap: onOpenCertificates,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAction(
                icon: Icons.bar_chart_rounded,
                label: "📊 Grades",
                color: _T.blueDeep,
                tint: _T.tintBlue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAction(
                icon: Icons.menu_book_rounded,
                label: "📚 Courses",
                color: _T.greenDark,
                tint: _T.tintGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color tint;
  final VoidCallback? onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.tint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 72,
        decoration: _T.tintCard(tint),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 5),
            Text(label, style: _T.caption1(color: color)),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// SECTION HEADER
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  const _SectionHeader({required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: _T.title3()),
        const Spacer(),
        if (action.isNotEmpty)
          Text(action, style: _T.subheadline(color: _T.blue)),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// NOTIFICATION SHEET
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _NotificationSheet extends StatelessWidget {
  const _NotificationSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      decoration: const BoxDecoration(
        color: _T.bgElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: _T.separator,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text("Notifications", style: _T.title3()),
              const Spacer(),
              Text("Mark all read", style: _T.subheadline(color: _T.blue)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: _T.widgetCard,
                child: Column(
                  children: const [
                    _NotifRow(
                      emoji: 'ðŸ“',
                      bg: _T.tintOrange,
                      title: 'Assignment due soon',
                      subtitle: 'Algebra Chapter 5 is due by 11:59 PM',
                      time: '10 min ago',
                      timeColor: _T.red,
                      last: false,
                    ),
                    _NotifRow(
                      emoji: 'ðŸ†',
                      bg: _T.tintGreen,
                      title: 'Marks published',
                      subtitle: 'Physics test results are now available',
                      time: '1 hr ago',
                      timeColor: _T.green,
                      last: false,
                    ),
                    _NotifRow(
                      emoji: 'ðŸ”¹',
                      bg: _T.tintBlue,
                      title: 'Live class reminder',
                      subtitle: 'English class starts in 30 minutes',
                      time: '2 hr ago',
                      timeColor: _T.blue,
                      last: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  final String emoji;
  final Color bg;
  final String title;
  final String subtitle;
  final String time;
  final Color timeColor;
  final bool last;

  const _NotifRow({
    required this.emoji,
    required this.bg,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.timeColor,
    required this.last,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: _T.separator, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 17)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _T.subheadline(color: _T.labelPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: _T.caption1(color: _T.labelTertiary)),
                const SizedBox(height: 4),
                Text(time, style: _T.caption2(color: timeColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// APPLE-STYLE NAV BAR
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
