// features/student/presentation/pages/student_screen.dart
// ─────────────────────────────────────────────────────────────
// APPLE WIDGET-STYLE DESIGN SYSTEM
// STRICT PALETTE: #58CC02 #FF9600 #1CB0F6 #FF4B4B #CE82FF
//                 #FFD900 #2B70C9 #FF6B35 #45A700 #CB3E3E
//                 #0081C8 #B800FF  — NO OTHER HEX ACCENTS
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'courses_page.dart';
import 'assignments_page.dart';
import 'ai_chatbot_page.dart';
import 'profile_page.dart';
import '../../../../services/dashboard_service.dart';

// ─────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────
class _T {
  // ── 12 ALLOWED PALETTE COLORS ────────────────────────────
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

  // ── NEUTRAL BACKGROUNDS ───────────────────────────────────
  static const bg          = Color(0xFFF2F2F7);
  static const bgElevated  = Color(0xFFFFFFFF);

  // ── CARD TINTS (very pale — derived from palette) ─────────
  static const tintBlue    = Color(0xFFEAF8FE);
  static const tintGreen   = Color(0xFFF1FBE8);
  static const tintOrange  = Color(0xFFFFF1E4);
  static const tintRed     = Color(0xFFFFEEEE);
  static const tintPurple  = Color(0xFFF7EEFF);
  static const tintYellow  = Color(0xFFFFFBE3);

  // ── TEXT ─────────────────────────────────────────────────
  static const labelPrimary    = Color(0xFF1C1C1E);
  static const labelSecondary  = Color(0xFF3C3C43);
  static const labelTertiary   = Color(0xFF8E8E93);
  static const labelQuaternary = Color(0xFFC7C7CC);

  // ── SEPARATORS ───────────────────────────────────────────
  static const separator     = Color(0xFFE5E5EA);
  static const separatorDark = Color(0xFF38383A);

  // ── TYPOGRAPHY ────────────────────────────────────────────
  static TextStyle title3({Color? color}) => GoogleFonts.inter(
    fontSize: 17, fontWeight: FontWeight.w600,
    color: color ?? labelPrimary, letterSpacing: -0.41, height: 1.3,
  );

  static TextStyle headline({Color? color}) => GoogleFonts.inter(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: color ?? labelPrimary, letterSpacing: -0.24,
  );

  static TextStyle subheadline({Color? color}) => GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w500,
    color: color ?? labelTertiary, letterSpacing: -0.08, height: 1.4,
  );

  static TextStyle caption1({Color? color}) => GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: color ?? labelTertiary, letterSpacing: 0.07,
  );

  static TextStyle caption2({Color? color}) => GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w400,
    color: color ?? labelQuaternary, letterSpacing: 0.07,
  );

  // ── CARD DECORATIONS ──────────────────────────────────────
  static BoxDecoration get widgetCard => BoxDecoration(
    color: bgElevated,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 20,
          spreadRadius: 0, offset: const Offset(0, 4)),
      BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 6,
          spreadRadius: 0, offset: const Offset(0, 1)),
    ],
  );

  static BoxDecoration tintCard(Color tint) => BoxDecoration(
    color: tint,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 16,
          spreadRadius: 0, offset: const Offset(0, 4)),
    ],
  );
}

// ─────────────────────────────────────────────────────────────
// 3D ILLUSTRATIONS — all palette-compliant
// ─────────────────────────────────────────────────────────────

class _3DBookIllustration extends StatelessWidget {
  final double size;
  const _3DBookIllustration({this.size = 80});
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size, child: CustomPaint(painter: _BookPainter()));
}

class _BookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    // Drop shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * .50, h * .88), width: w * .70, height: h * .12),
      Paint()..color = Colors.black.withOpacity(.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));

    // Left page — #FFD900 yellow tones (palette)
    final lp = Path()
      ..moveTo(w * .08, h * .22)..cubicTo(w * .08, h * .14, w * .50, h * .10, w * .50, h * .18)
      ..lineTo(w * .50, h * .80)..cubicTo(w * .50, h * .80, w * .08, h * .82, w * .08, h * .74)..close();
    canvas.drawPath(lp, Paint()
      ..shader = const LinearGradient(
          colors: [Color(0xFFFFD900), Color(0xFFFF9600)]) // #FFD900 → #FF9600
          .createShader(Rect.fromLTWH(0, 0, w * .50, h)));
    canvas.drawPath(lp, Paint()
      ..color = const Color(0xFFFF9600).withOpacity(.30) // #FF9600
      ..style = PaintingStyle.stroke..strokeWidth = 1.0);
    // Line rules — #45A700 green at low opacity
    final ln = Paint()..color = const Color(0xFF45A700).withOpacity(.20)..strokeWidth = 1.0;
    for (int i = 0; i < 5; i++) {
      final y = h * (.30 + i * .10);
      canvas.drawLine(Offset(w * .14, y), Offset(w * .44, y), ln);
    }

    // Right page — #FF9600 → #FFD900 (palette)
    final rp = Path()
      ..moveTo(w * .92, h * .22)..cubicTo(w * .92, h * .14, w * .50, h * .10, w * .50, h * .18)
      ..lineTo(w * .50, h * .80)..cubicTo(w * .50, h * .80, w * .92, h * .82, w * .92, h * .74)..close();
    canvas.drawPath(rp, Paint()
      ..shader = const LinearGradient(
          colors: [Color(0xFFFF9600), Color(0xFFFFD900)]) // #FF9600 → #FFD900
          .createShader(Rect.fromLTWH(w * .50, 0, w * .50, h)));
    canvas.drawPath(rp, Paint()
      ..color = const Color(0xFFFFD900).withOpacity(.40) // #FFD900
      ..style = PaintingStyle.stroke..strokeWidth = 1.0);
    for (int i = 0; i < 5; i++) {
      final y = h * (.30 + i * .10);
      canvas.drawLine(Offset(w * .56, y), Offset(w * .86, y), ln);
    }

    // Spine — #1CB0F6 → #0081C8 (palette)
    canvas.drawRect(Rect.fromLTWH(w * .46, h * .10, w * .08, h * .70), Paint()
      ..shader = const LinearGradient(
          colors: [Color(0xFF1CB0F6), Color(0xFF0081C8)], // palette blue
          begin: Alignment.topCenter, end: Alignment.bottomCenter)
          .createShader(Rect.fromLTWH(w * .46, 0, w * .08, h)));
    // Spine highlight
    canvas.drawRect(Rect.fromLTWH(w * .46, h * .10, w * .025, h * .70),
        Paint()..color = Colors.white.withOpacity(.22));
  }
  @override bool shouldRepaint(covariant CustomPainter _) => false;
}

class _3DFireIllustration extends StatelessWidget {
  final double size;
  const _3DFireIllustration({this.size = 44});
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size, child: CustomPaint(painter: _FirePainter()));
}

class _FirePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    // Glow — #FF9600
    canvas.drawCircle(Offset(w * .50, h * .55), w * .38, Paint()
      ..color = const Color(0xFFFF9600).withOpacity(.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    // Back flame — #CB3E3E
    final bp = Path()
      ..moveTo(w * .50, h * .06)..cubicTo(w * .65, h * .18, w * .82, h * .30, w * .80, h * .52)
      ..cubicTo(w * .78, h * .68, w * .65, h * .78, w * .50, h * .82)
      ..cubicTo(w * .35, h * .78, w * .22, h * .68, w * .20, h * .52)
      ..cubicTo(w * .18, h * .30, w * .35, h * .18, w * .50, h * .06)..close();
    canvas.drawPath(bp, Paint()..color = const Color(0xFFCB3E3E));
    // Main flame — #FF9600 → #FF6B35 → #FF4B4B
    final mp = Path()
      ..moveTo(w * .50, h * .10)..cubicTo(w * .62, h * .20, w * .76, h * .34, w * .74, h * .54)
      ..cubicTo(w * .72, h * .70, w * .62, h * .80, w * .50, h * .84)
      ..cubicTo(w * .38, h * .80, w * .28, h * .70, w * .26, h * .54)
      ..cubicTo(w * .24, h * .34, w * .38, h * .20, w * .50, h * .10)..close();
    canvas.drawPath(mp, Paint()
      ..shader = const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
          colors: [Color(0xFFFF9600), Color(0xFFFF6B35), Color(0xFFFF4B4B)], stops: [0, .5, 1])
          .createShader(Rect.fromLTWH(0, 0, w, h)));
    // Inner — #FFD900 → #FF9600 → #FF6B35
    final ip = Path()
      ..moveTo(w * .50, h * .22)..cubicTo(w * .58, h * .30, w * .66, h * .42, w * .64, h * .56)
      ..cubicTo(w * .62, h * .68, w * .56, h * .75, w * .50, h * .78)
      ..cubicTo(w * .44, h * .75, w * .38, h * .68, w * .36, h * .56)
      ..cubicTo(w * .34, h * .42, w * .42, h * .30, w * .50, h * .22)..close();
    canvas.drawPath(ip, Paint()
      ..shader = const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
          colors: [Color(0xFFFFD900), Color(0xFFFF9600), Color(0xFFFF6B35)], stops: [0, .55, 1])
          .createShader(Rect.fromLTWH(0, 0, w, h)));
  }
  @override bool shouldRepaint(covariant CustomPainter _) => false;
}

class _BooksStackIllustration extends StatelessWidget {
  final double size;
  const _BooksStackIllustration({this.size = 56});
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size, child: CustomPaint(painter: _BooksStackPainter()));
}

class _BooksStackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    // All spine/face colors from palette only
    _drawBook(canvas, Rect.fromLTWH(w*.08,h*.60,w*.84,h*.22),
        const Color(0xFF1CB0F6), const Color(0xFF0081C8), 4.0);
    _drawBook(canvas, Rect.fromLTWH(w*.12,h*.38,w*.76,h*.22),
        const Color(0xFF58CC02), const Color(0xFF45A700), 4.0);
    _drawBook(canvas, Rect.fromLTWH(w*.16,h*.18,w*.68,h*.22),
        const Color(0xFFFF9600), const Color(0xFFFF6B35), 4.0);
  }
  void _drawBook(Canvas canvas, Rect rect, Color face, Color spine, double depth) {
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.top + depth, depth, rect.height - depth),
      Paint()..color = spine);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(3)), Paint()
      ..shader = LinearGradient(colors: [face, Color.lerp(face, Colors.white, .18)!],
          begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(rect));
    canvas.drawLine(Offset(rect.left + 6, rect.top + 3), Offset(rect.left + 6, rect.bottom - 3),
      Paint()..color = Colors.white.withOpacity(.30)..strokeWidth = 2);
  }
  @override bool shouldRepaint(covariant CustomPainter _) => false;
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
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await dashboardService.getDashboard();
      if (data != null) setState(() => dashboardData = data);
    } catch (e) {
      debugPrint("Dashboard error: $e");
    }
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
          child: KeyedSubtree(key: ValueKey(_current), child: pages[_current]),
        ),
        bottomNavigationBar: _AppleNavBar(
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
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _TopBar(dashboardData: dashboardData),
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
                const _AssignmentsWidget(),
                const SizedBox(height: 14),
                const _LiveClassesWidget(),
                const SizedBox(height: 14),
                const _QuickActionsWidget(),
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: _T.bg,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const _NotificationSheet(),
            ),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                // #1CB0F6 → #2B70C9 gradient (palette)
                gradient: const LinearGradient(
                  colors: [Color(0xFF1CB0F6), Color(0xFF2B70C9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text("K", style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w700, fontSize: 17)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("KIDLEARN", style: _T.title3()),
                Text(
                  dashboardData?["student_name"] != null
                    ? "Hello, ${dashboardData!["student_name"]} 👋"
                    : "Good morning 👋",
                  style: _T.caption1(),
                ),
              ],
            ),
          ),
          // XP badge — #1CB0F6 (palette)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _T.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.diamond_rounded, color: Colors.white, size: 13),
                const SizedBox(width: 5),
                Text(
                  "${dashboardData?["xp"] ?? 1240} XP",
                  style: GoogleFonts.inter(color: Colors.white,
                      fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: -0.2),
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
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _T.bgElevated,
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.06),
                      blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: const Icon(Icons.notifications_rounded,
                  color: _T.labelTertiary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HERO BANNER — #58CC02 green card
// ─────────────────────────────────────────────────────────────
class _HeroBannerCard extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _HeroBannerCard({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _T.green,  // #58CC02
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: _T.greenDark.withOpacity(.35),
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
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("Learning Progress",
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(.90), letterSpacing: 0.2)),
                ),
                const SizedBox(height: 10),
                Text(
                  dashboardData?["continue_course"] ?? "Keep Learning",
                  style: _T.title3(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  dashboardData?["course_progress_text"] ?? "72% Completed",
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
                      widthFactor: (dashboardData?["course_progress"] ?? 72) / 100.0,
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
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white54, size: 11),
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
}

// ─────────────────────────────────────────────────────────────
// WEEKLY STREAK CARD
// ─────────────────────────────────────────────────────────────
class _WeeklyStreakCard extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _WeeklyStreakCard({this.dashboardData});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final streak = (dashboardData?["weekly_streak"] ?? 4) as int;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _T.widgetCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _3DFireIllustration(size: 38),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _T.orange.withOpacity(.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('🔥 $streak days',
                  style: GoogleFonts.inter(fontSize: 12,
                      fontWeight: FontWeight.w700, color: _T.orange)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(7, (i) {
              final active = i < streak;
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
                        ),
                        child: Center(
                          child: active
                            ? const Icon(Icons.local_fire_department_rounded,
                                color: Colors.white, size: 15)
                            : Text(_days[i], style: _T.caption2()),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(_days[i],
                        style: _T.caption2(
                            color: active ? _T.orange : _T.labelQuaternary)),
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
}

// ─────────────────────────────────────────────────────────────
// STATS ROW — 3 mini stat cards (font size REDUCED to 16)
// ─────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  const _StatsRow({this.dashboardData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MiniStat(
          icon: Icons.timer_rounded, color: _T.green,
          value: dashboardData?["study_hours"]?.toString() ?? '12.5',
          unit: 'hrs', label: 'Studied',
        )),
        const SizedBox(width: 10),
        Expanded(child: _MiniStat(
          icon: Icons.emoji_events_rounded, color: _T.yellow,
          value: dashboardData?["attendance"]?.toString() ?? '92',
          unit: '%', label: 'Attendance',
        )),
        const SizedBox(width: 10),
        Expanded(child: _MiniStat(
          icon: Icons.check_circle_rounded, color: _T.purple,
          value: dashboardData?["assignments_done"]?.toString() ?? '8/11',
          unit: '', label: 'Tasks',
        )),
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
    required this.icon, required this.color,
    required this.value, required this.unit, required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: color.withOpacity(.38),
              blurRadius: 16, spreadRadius: 0, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 15),
          ),
          const SizedBox(height: 8),
          // ── REDUCED font: 16 (was 20) ──
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: value,
                style: GoogleFonts.inter(
                  fontSize: 16,               // ← reduced from 20
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              if (unit.isNotEmpty) TextSpan(
                text: ' $unit',
                style: GoogleFonts.inter(
                  fontSize: 10,               // ← reduced from 11
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 1),
          Text(label, style: _T.caption1(color: Colors.white70)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROGRESS CHART CARD
// ─────────────────────────────────────────────────────────────
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
    final values = [0.4, 0.65, 0.5, 0.9, 0.7, 0.3, 0.55];
    final days   = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final isToday = i == 3;
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
                      color: isToday ? _T.blueDeep : _T.blueDeep.withOpacity(.20),                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(days[i],
                    style: _T.caption2(
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

// ─────────────────────────────────────────────────────────────
// ASSIGNMENTS WIDGET
// ─────────────────────────────────────────────────────────────
class _AssignmentsWidget extends StatelessWidget {
  const _AssignmentsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: "Pending", action: "See All"),
        const SizedBox(height: 10),
        Container(
          decoration: _T.widgetCard,
          child: const Column(
            children: [
              _AssignmentRow(emoji: '🧮', title: "Binary Search Trees",
                  due: "Due Today", danger: true, last: false),
              _AssignmentRow(emoji: '✍️', title: "Market Analysis Essay",
                  due: "2 Days Left", danger: false, last: false),
              _AssignmentRow(emoji: '🔬', title: "Newton's Laws Worksheet",
                  due: "5 Days Left", danger: false, last: true),
            ],
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
    required this.emoji, required this.title, required this.due,
    required this.danger, required this.last,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: last ? null : Border(
            bottom: BorderSide(color: _T.separator, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: danger
                ? _T.red.withOpacity(.10)
                : _T.green.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _T.subheadline(color: _T.labelPrimary)),
                const SizedBox(height: 2),
                Text(due, style: _T.caption1(
                    color: danger ? _T.red : _T.labelTertiary)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: _T.labelQuaternary, size: 18),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LIVE CLASSES WIDGET — grouped list style (like Pending card)
// ─────────────────────────────────────────────────────────────
class _LiveClassesWidget extends StatelessWidget {
  const _LiveClassesWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: "Live Classes", action: "View All"),
        const SizedBox(height: 10),
        Container(
          decoration: _T.widgetCard,
          child: const Column(
            children: [
              _LiveClassRow(
                emoji: '📐',
                subject: "Mathematics",
                teacher: "Mr. Kumar",
                time: "10:00 AM",
                accentColor: _T.blue,
                tint: _T.tintBlue,
                isLive: true,
                last: false,
              ),
              _LiveClassRow(
                emoji: '🔬',
                subject: "Physics",
                teacher: "Ms. Priya",
                time: "12:30 PM",
                accentColor: _T.purple,
                tint: _T.tintPurple,
                isLive: false,
                last: false,
              ),
              _LiveClassRow(
                emoji: '📖',
                subject: "English",
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
          // Emoji icon box — same style as assignment row
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),

          // Subject + teacher + time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(subject, style: _T.subheadline(color: _T.labelPrimary)),
                    if (isLive) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _T.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5, height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text("LIVE",
                              style: GoogleFonts.inter(
                                fontSize: 8, fontWeight: FontWeight.w800,
                                color: Colors.white, letterSpacing: 0.5)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text("${teacher}  ·  $time",
                  style: _T.caption1(color: _T.labelTertiary)),
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

// ─────────────────────────────────────────────────────────────
// QUICK ACTIONS
// ─────────────────────────────────────────────────────────────
class _QuickActionsWidget extends StatelessWidget {
  const _QuickActionsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: "Quick Actions", action: ""),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _QuickAction(icon: Icons.upload_rounded,
                label: "Submit HW", color: _T.green, tint: _T.tintGreen)),
            const SizedBox(width: 10),
            Expanded(child: _QuickAction(icon: Icons.auto_awesome_rounded,
                label: "AI Tutor", color: _T.blue, tint: _T.tintBlue)),
            const SizedBox(width: 10),
            Expanded(child: _QuickAction(icon: Icons.bar_chart_rounded,
                label: "Grades", color: _T.purple, tint: _T.tintPurple)),
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

  const _QuickAction({
    required this.icon, required this.label,
    required this.color, required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────
// NOTIFICATION SHEET
// ─────────────────────────────────────────────────────────────
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
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: _T.separator, borderRadius: BorderRadius.circular(20)),
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
                    _NotifRow(emoji: '📝', bg: _T.tintOrange,
                      title: 'Assignment due soon',
                      subtitle: 'Algebra Chapter 5 is due by 11:59 PM',
                      time: '10 min ago', timeColor: _T.red, last: false),
                    _NotifRow(emoji: '🏆', bg: _T.tintGreen,
                      title: 'Marks published',
                      subtitle: 'Physics test results are now available',
                      time: '1 hr ago', timeColor: _T.green, last: false),
                    _NotifRow(emoji: '🔹', bg: _T.tintBlue,
                      title: 'Live class reminder',
                      subtitle: 'English class starts in 30 minutes',
                      time: '2 hr ago', timeColor: _T.blue, last: true),
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
    required this.emoji, required this.bg, required this.title,
    required this.subtitle, required this.time,
    required this.timeColor, required this.last,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: last ? null : Border(
            bottom: BorderSide(color: _T.separator, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(11)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 17))),
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

// ─────────────────────────────────────────────────────────────
// APPLE-STYLE NAV BAR
// ─────────────────────────────────────────────────────────────
class _AppleNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AppleNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.house_rounded,        Icons.house_outlined,       'Home'),
    (Icons.menu_book_rounded,    Icons.menu_book_outlined,   'Courses'),
    (Icons.assignment_rounded,   Icons.assignment_outlined,  'Tasks'),
    (Icons.auto_awesome_rounded, Icons.auto_awesome_outlined,'AI'),
    (Icons.person_rounded,       Icons.person_outline_rounded,'Profile'),
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
              color: Colors.white.withOpacity(.92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _T.separator, width: 0.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.10),
                    blurRadius: 30, spreadRadius: 0, offset: const Offset(0, 8)),
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
                                color: _T.blue.withOpacity(.12),
                                borderRadius: BorderRadius.circular(9))
                            : null,
                          child: Icon(
                            active ? _items[i].$1 : _items[i].$2,
                            color: active ? _T.blue : _T.labelTertiary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(_items[i].$3,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                            color: active ? _T.blue : _T.labelTertiary,
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