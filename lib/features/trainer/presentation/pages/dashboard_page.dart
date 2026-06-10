import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/dashboard/assignment_summary_card.dart';
import '../widgets/dashboard/attendance_summary_card.dart';
import '../widgets/dashboard/class_summary_card.dart';
import '../widgets/dashboard/schedule_overview_card.dart';
import '../widgets/dashboard/upcoming_class_card.dart';

class TrainerDashboardPage extends StatelessWidget {
  final VoidCallback? onOpenProfile;

  const TrainerDashboardPage({super.key, this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        color: _T.bg,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _TrainerTopBar(onOpenProfile: onOpenProfile),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  children: const [
                    _TrainerHeroCard(),
                    SizedBox(height: 14),
                    ClassSummaryCard(),
                    SizedBox(height: 14),
                    ScheduleOverviewCard(),
                    SizedBox(height: 14),
                    AttendanceSummaryCard(),
                    SizedBox(height: 14),
                    AssignmentSummaryCard(),
                    SizedBox(height: 14),
                    UpcomingClassCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final VoidCallback? onOpenProfile;

  const DashboardPage({super.key, this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    return TrainerDashboardPage(onOpenProfile: onOpenProfile);
  }
}

class _TrainerTopBar extends StatelessWidget {
  final VoidCallback? onOpenProfile;

  const _TrainerTopBar({this.onOpenProfile});

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
                gradient: const LinearGradient(
                  colors: [_T.blue, _T.blueDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'T',
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
                  Text('KIDLEARN', style: _T.title3()),
                  Text('Good morning, Meera', style: _T.caption1()),
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
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 13,
                ),
                const SizedBox(width: 5),
                Text(
                  'Trainer',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: -.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const _TrainerNotificationSheet(),
              );
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

class _TrainerHeroCard extends StatelessWidget {
  const _TrainerHeroCard();

  @override
  Widget build(BuildContext context) {
    const completion = .76;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _T.green,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _T.greenDark.withValues(alpha: .35),
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
                    color: Colors.white.withValues(alpha: .20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Teaching Progress',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: .90),
                      letterSpacing: .2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Python fundamentals',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _T.title3(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '76% of today plan completed',
                  style: _T.subheadline(color: Colors.white70),
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
                      widthFactor: completion,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
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
                      'Open class',
                      style: _T.caption1(color: Colors.white70),
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
          const SizedBox(width: 16),
          const _TrainerBoardIllustration(size: 84),
        ],
      ),
    );
  }
}

class _TrainerBoardIllustration extends StatelessWidget {
  final double size;

  const _TrainerBoardIllustration({this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _TrainerBoardPainter()),
    );
  }
}

class _TrainerBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .50, h * .89),
        width: w * .72,
        height: h * .12,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: .14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    final boardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * .12, h * .16, w * .76, h * .54),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      boardRect,
      Paint()
        ..shader = const LinearGradient(
          colors: [_T.blue, _T.blueDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    canvas.drawRRect(
      boardRect,
      Paint()
        ..color = Colors.white.withValues(alpha: .24)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final line = Paint()
      ..color = Colors.white.withValues(alpha: .62)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * .24, h * .31), Offset(w * .68, h * .31), line);
    canvas.drawLine(Offset(w * .24, h * .43), Offset(w * .76, h * .43), line);
    canvas.drawLine(Offset(w * .24, h * .55), Offset(w * .58, h * .55), line);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * .43, h * .70, w * .14, h * .09),
        const Radius.circular(3),
      ),
      Paint()..color = _T.orange,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * .27, h * .78, w * .46, h * .08),
        const Radius.circular(4),
      ),
      Paint()..color = _T.yellow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrainerNotificationSheet extends StatelessWidget {
  const _TrainerNotificationSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        decoration: BoxDecoration(
          color: _T.bgElevated,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: _T.separator,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text('Notifications', style: _T.title3())),
                Text('Mark all read', style: _T.subheadline(color: _T.blue)),
              ],
            ),
            const SizedBox(height: 12),
            const _NotificationTile(
              icon: Icons.assignment_turned_in_rounded,
              title: '18 submissions are ready for grading',
              subtitle: 'Advanced ML batch',
              time: '8 min ago',
              bg: _T.tintOrange,
              color: _T.orange,
            ),
            const _NotificationTile(
              icon: Icons.groups_rounded,
              title: 'Python fundamentals starts soon',
              subtitle: 'Lab 2 - 10:30 AM',
              time: '24 min ago',
              bg: _T.tintBlue,
              color: _T.blue,
            ),
            const _NotificationTile(
              icon: Icons.fact_check_rounded,
              title: 'Attendance report submitted',
              subtitle: 'Grade 7 - Batch C',
              time: '1 hr ago',
              bg: _T.tintGreen,
              color: _T.green,
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color bg;
  final Color color;
  final bool showDivider;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.bg,
    required this.color,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: showDivider ? 12 : 0),
      margin: EdgeInsets.only(bottom: showDivider ? 12 : 0),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: _T.separator, width: .5))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _T.subheadline(color: _T.labelPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: _T.caption1()),
                const SizedBox(height: 2),
                Text(time, style: _T.caption2(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _T {
  static const green = Color(0xFF46A800);
  static const greenDark = Color(0xFF357800);
  static const orange = Color(0xFFF59000);
  static const blue = Color(0xFF14A0E0);
  static const blueDeep = Color(0xFF2464B8);
  static const yellow = Color(0xFFE8C400);
  static const bg = Color(0xFFFDF6EC);
  static const bgElevated = Color(0xFFFFFAF4);
  static const tintBlue = Color(0xFFEAF8FE);
  static const tintGreen = Color(0xFFF1FBE8);
  static const tintOrange = Color(0xFFFFF1E4);
  static const labelPrimary = Color(0xFF1C1C1E);
  static const labelTertiary = Color(0xFF8E8E93);
  static const labelQuaternary = Color(0xFFC7C7CC);
  static const separator = Color(0xFFE5E5EA);

  static TextStyle title3({Color? color}) => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: color ?? labelPrimary,
    letterSpacing: -.41,
    height: 1.3,
  );

  static TextStyle subheadline({Color? color}) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: color ?? labelTertiary,
    letterSpacing: -.08,
    height: 1.4,
  );

  static TextStyle caption1({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: color ?? labelTertiary,
    letterSpacing: .07,
  );

  static TextStyle caption2({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: color ?? labelQuaternary,
    letterSpacing: .07,
  );
}
