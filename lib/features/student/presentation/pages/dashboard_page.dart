part of 'student_screen.dart';



class _DashboardPage extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  final String? studentName;
  final VoidCallback onOpenAiTutor;
  final VoidCallback onOpenCoding;
  final VoidCallback onOpenCertificates;
  final VoidCallback onOpenProfile;
  const _DashboardPage({
    this.dashboardData,
    this.studentName,
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
class _TopBar extends StatefulWidget {
  final Map<String, dynamic>? dashboardData;
  final VoidCallback onOpenProfile;
  const _TopBar({this.dashboardData, required this.onOpenProfile});

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  String _studentName = '';

  @override
  void initState() {
    super.initState();
    _loadStudentName();
  }

  Future<void> _loadStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('student_name') ?? '';
    if (mounted) {
      setState(() => _studentName = name);
    }
  }

  String get _displayName {
    if (widget.dashboardData?["student_name"] != null) {
      return widget.dashboardData!["student_name"] ?? '';
    }
    return _studentName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: _T.bg,
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onOpenProfile,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE8D5FF), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/student_profile.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: widget.onOpenProfile,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("KIDLEARN", style: _T.title3()),
                  Text(
                    _displayName.isNotEmpty
                        ? "Hello, $_displayName 👋"
                        : "Good morning 👋",
                    style: _T.title3().copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
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
                  "${widget.dashboardData?["xp"] ?? 0} XP",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          // AFTER
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
                if (confirm == true && context.mounted) {
                await AuthService().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _T.bgElevated,
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: _T.labelTertiary,
                size: 18,
              ),
            ),
          ),

          const SizedBox(width: 8),
          // NOTE: Three-dots overflow removed per UX request; trainer live classes
          // are available from the main navigation tab.
        ],
      ),
    );
  }
}


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
        color: const Color(0xFF58CC02),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
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
                      "Learning Progress",
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
                        "Continue",
                        style: _T.caption1(color: Colors.white70),
                      ),
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
          ),
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

    return Transform.translate(
      offset: const Offset(0, -3),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: _T.widgetCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 46,
                  height: 46,
                  child: OverflowBox(
                    maxWidth: 72,
                    maxHeight: 72,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/fire_mascot.png',
                      width: 72,
                      height: 72,
                    ),
                  ),
                ),
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
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _T.orange.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/fire_mascot.png',
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 6),
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
                          height: 42,
                          decoration: BoxDecoration(
                            color: active
                                ? _T.orange
                                : _T.orange.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(18),
                            border: isToday
                                ? Border.all(color: _T.red, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: active
                                ? Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Image.asset(
                                      'assets/images/fire_mascot.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                  )
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
// ─────────────────────────────────────────────────────────────
// STATS ROW – 3 mini stat cards (overflow fixed)
// ─────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────
// STATS ROW – 3 mini stat cards (overflow fixed)
// ─────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────
// STATS ROW – 3 mini stat cards (same size, bigger picture)
// ─────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _StatsRow({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _MiniStat(
              imagePath: 'assets/images/clock_icon.png',
              backgroundColor: _T.green,
              value: dashboardData?["study_hours"]?.toString() ?? '0',
              title: 'Hours Today',
              subtitle: 'logged',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MiniStat(
              imagePath: 'assets/images/trophy_icon.png',
              backgroundColor: _T.yellow,
              value: dashboardData?["attendance"]?.toString() ?? 'Present',
              title: 'Present',
              subtitle: '',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MiniStat(
              imagePath: 'assets/images/tick_icon.png',
              backgroundColor: _T.purple,
              value: dashboardData?["assignments_done"]?.toString() ?? '0/0',
              title: 'Tasks',
              subtitle: '',
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final String value;
  final String title;
  final String subtitle;

  const _MiniStat({
    required this.imagePath,
    required this.backgroundColor,
    required this.value,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: const Offset(-6, -6),
            child: Image.asset(
              imagePath,
              width: 54,
              height: 54,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2A2A2A),
              height: 1.0,
            ),
          ),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.fredoka(
              fontSize: 9,
              height: 1.2,
              color: Colors.black54,
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: GoogleFonts.fredoka(
                fontSize: 9,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
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

class _ActivityBars extends StatefulWidget {
  @override
  State<_ActivityBars> createState() => _ActivityBarsState();
}

class _ActivityBarsState extends State<_ActivityBars> {
  List<double> _hours = List.filled(7, 0.0);
  final _service = StudyTimeService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final hours = await _service.getWeeklyHours();
    if (mounted) setState(() => _hours = hours);
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = _hours.reduce((a, b) => a > b ? a : b);
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final isToday = i == DateTime.now().weekday - DateTime.monday;
          final barH = maxVal > 0 ? (_hours[i] / maxVal) * 90 : 0.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_hours[i] > 0)
                    Text(
                      '${_hours[i].toStringAsFixed(1)}h',
                      style: GoogleFonts.nunito(
                          fontSize: 8, fontWeight: FontWeight.w700,
                          color: _T.blue),
                    ),
                  const SizedBox(height: 2),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400 + i * 60),
                    curve: Curves.easeOutCubic,
                    height: barH,
                    decoration: BoxDecoration(
                      color: isToday
                          ? _T.blueDeep
                          : _T.blueDeep.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(days[i], style: _T.caption2(
                      color: isToday ? _T.blue : _T.labelQuaternary)),
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: danger
                  ? _T.red.withValues(alpha: .10)
                  : _T.green.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
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
class _LiveClassesWidget extends StatefulWidget {
  const _LiveClassesWidget();

  @override
  State<_LiveClassesWidget> createState() => _LiveClassesWidgetState();
}

class _LiveClassesWidgetState extends State<_LiveClassesWidget> {
  late final LiveClassesService _liveClassesService = LiveClassesService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: "🎥 Live Classes", action: "View All"),
        const SizedBox(height: 10),
        FutureBuilder<List<LiveClass>>(
          future: _liveClassesService.fetchLiveClasses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                decoration: _T.widgetCard,
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            final classes = snapshot.data ?? [];
            
            if (classes.isEmpty) {
              return Container(
                decoration: _T.widgetCard,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No live classes scheduled',
                    style: _T.caption1(color: _T.labelTertiary),
                  ),
                ),
              );
            }

            return Container(
              decoration: _T.widgetCard,
              child: Column(
                children: List.generate(
                  classes.length,
                  (index) => LiveClassCard(
                    subject: classes[index].title,
                    teacher: classes[index].teacherName,
                    time: _formatTime(classes[index].startTime ?? ''),
                    isLive: classes[index].isLive,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getEmojiForSubject(String subject) {
    if (subject.toLowerCase().contains('math')) return '📐';
    if (subject.toLowerCase().contains('physics')) return '⚗️';
    if (subject.toLowerCase().contains('english')) return '✏️';
    return '📚';
  }

  Color _getColorForIndex(int index) {
    final colors = [_T.blue, _T.purple, _T.green];
    return colors[index % colors.length];
  }

  Color _getTintColorForIndex(int index) {
    final tints = [_T.tintBlue, _T.tintPurple, _T.tintGreen];
    return tints[index % tints.length];
  }

  String _formatTime(String? schedule) {
    if (schedule == null) return 'TBD';
    try {
      final dt = DateTime.parse(schedule);
      return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';
    } catch (e) {
      return 'TBD';
    }
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(20),
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
                  "$teacher  Â·  $time",
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isLive ? accentColor : tint,
                borderRadius: BorderRadius.circular(30),
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
        height: 95,
        decoration: _T.tintCard(tint),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
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
