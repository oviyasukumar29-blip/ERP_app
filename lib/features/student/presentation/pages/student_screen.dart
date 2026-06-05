// features/student/presentation/pages/student_screen.dart
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// APPLE WIDGET-STYLE DESIGN SYSTEM
// STRICT PALETTE: #58CC02 #FF9600 #1CB0F6 #FF4B4B #CE82FF
//                 #FFD900 #2B70C9 #FF6B35 #45A700 #CB3E3E
//                 #0081C8 #B800FF  â€” NO OTHER HEX ACCENTS
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'courses_page.dart';
import 'assignments_page.dart';
import 'ai_chatbot_page.dart';
import 'profile_page.dart';
import 'coding_playground_page.dart';
import 'certificates_page.dart';
import '../../../../services/dashboard_service.dart';

part 'dashboard_page.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// DESIGN TOKENS
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _T {
  // â”€â”€ 12 ALLOWED PALETTE COLORS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // ── 12 ALLOWED PALETTE COLORS ────────────────────────────
  static const green = Color(0xFF46A800);
  static const greenDark = Color(0xFF357800);
  static const orange = Color(0xFFF59000); // was #FF9600
  static const blue = Color(0xFF14A0E0); // was #1CB0F6
  static const blueDark = Color(0xFF0072B5); // was #0081C8
  static const blueDeep = Color(0xFF2464B8); // was #2B70C9
  static const red = Color(0xFFEC3A3A); // was #FF4B4B
  static const redDark = Color(0xFFB83535); // was #CB3E3E
  static const purple = Color(0xFFBB6EF0); // was #CE82FF
  static const purpleDark = Color(0xFFA500E8); // was #B800FF
  static const yellow = Color(0xFFE8C400); // was #FFD900
  static const coral = Color(
    0xFFEC5F28,
  ); // was #FF6B35   // was #FF6B35 — darker

  // rest stays the same...

  // â”€â”€ NEUTRAL BACKGROUNDS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const bg = Color(0xFFFDF6EC); // warm cream
  static const bgElevated = Color(0xFFFFFAF4);

  // â”€â”€ CARD TINTS (very pale â€” derived from palette) â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const tintBlue = Color(0xFFEAF8FE);
  static const tintGreen = Color(0xFFF1FBE8);
  static const tintOrange = Color(0xFFFFF1E4);
  static const tintRed = Color(0xFFFFEEEE);
  static const tintPurple = Color(0xFFF7EEFF);
  static const tintYellow = Color(0xFFFFFBE3);

  // â”€â”€ TEXT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const labelPrimary = Color(0xFF1C1C1E);
  static const labelSecondary = Color(0xFF3C3C43);
  static const labelTertiary = Color(0xFF8E8E93);
  static const labelQuaternary = Color(0xFFC7C7CC);

  // â”€â”€ SEPARATORS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const separator = Color(0xFFE5E5EA);
  static const separatorDark = Color(0xFF38383A);

  // â”€â”€ TYPOGRAPHY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static TextStyle title3({Color? color}) => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: color ?? labelPrimary,
    letterSpacing: -0.41,
    height: 1.3,
  );

  static TextStyle headline({Color? color}) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color ?? labelPrimary,
    letterSpacing: -0.24,
  );

  static TextStyle subheadline({Color? color}) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: color ?? labelTertiary,
    letterSpacing: -0.08,
    height: 1.4,
  );

  static TextStyle caption1({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: color ?? labelTertiary,
    letterSpacing: 0.07,
  );

  static TextStyle caption2({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: color ?? labelQuaternary,
    letterSpacing: 0.07,
  );

  // â”€â”€ CARD DECORATIONS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static BoxDecoration get widgetCard => BoxDecoration(
    color: bgElevated,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.06),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(.03),
        blurRadius: 6,
        spreadRadius: 0,
        offset: const Offset(0, 1),
      ),
    ],
  );

  static BoxDecoration tintCard(Color tint) => BoxDecoration(
    color: tint,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.05),
        blurRadius: 16,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// 3D ILLUSTRATIONS â€” all palette-compliant
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _3DBookIllustration extends StatelessWidget {
  final double size;
  const _3DBookIllustration({this.size = 80});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _BookPainter()),
  );
}

class _BookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Drop shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .50, h * .88),
        width: w * .70,
        height: h * .12,
      ),
      Paint()
        ..color = Colors.black.withOpacity(.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Left page â€” #FFD900 yellow tones (palette)
    final lp = Path()
      ..moveTo(w * .08, h * .22)
      ..cubicTo(w * .08, h * .14, w * .50, h * .10, w * .50, h * .18)
      ..lineTo(w * .50, h * .80)
      ..cubicTo(w * .50, h * .80, w * .08, h * .82, w * .08, h * .74)
      ..close();
    canvas.drawPath(
      lp,
      Paint()
        ..shader =
            const LinearGradient(
                  colors: [Color(0xFFFFD900), Color(0xFFFF9600)],
                ) // #FFD900 â†’ #FF9600
                .createShader(Rect.fromLTWH(0, 0, w * .50, h)),
    );
    canvas.drawPath(
      lp,
      Paint()
        ..color = const Color(0xFFFF9600)
            .withOpacity(.30) // #FF9600
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    // Line rules â€” #45A700 green at low opacity
    final ln = Paint()
      ..color = const Color(0xFF45A700).withOpacity(.20)
      ..strokeWidth = 1.0;
    for (int i = 0; i < 5; i++) {
      final y = h * (.30 + i * .10);
      canvas.drawLine(Offset(w * .14, y), Offset(w * .44, y), ln);
    }

    // Right page â€” #FF9600 â†’ #FFD900 (palette)
    final rp = Path()
      ..moveTo(w * .92, h * .22)
      ..cubicTo(w * .92, h * .14, w * .50, h * .10, w * .50, h * .18)
      ..lineTo(w * .50, h * .80)
      ..cubicTo(w * .50, h * .80, w * .92, h * .82, w * .92, h * .74)
      ..close();
    canvas.drawPath(
      rp,
      Paint()
        ..shader =
            const LinearGradient(
                  colors: [Color(0xFFFF9600), Color(0xFFFFD900)],
                ) // #FF9600 â†’ #FFD900
                .createShader(Rect.fromLTWH(w * .50, 0, w * .50, h)),
    );
    canvas.drawPath(
      rp,
      Paint()
        ..color = const Color(0xFFFFD900)
            .withOpacity(.40) // #FFD900
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    for (int i = 0; i < 5; i++) {
      final y = h * (.30 + i * .10);
      canvas.drawLine(Offset(w * .56, y), Offset(w * .86, y), ln);
    }

    // Spine â€” #1CB0F6 â†’ #0081C8 (palette)
    canvas.drawRect(
      Rect.fromLTWH(w * .46, h * .10, w * .08, h * .70),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF1CB0F6), Color(0xFF0081C8)], // palette blue
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(w * .46, 0, w * .08, h)),
    );
    // Spine highlight
    canvas.drawRect(
      Rect.fromLTWH(w * .46, h * .10, w * .025, h * .70),
      Paint()..color = Colors.white.withOpacity(.22),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _3DFireIllustration extends StatelessWidget {
  final double size;
  const _3DFireIllustration({this.size = 44});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _FirePainter()),
  );
}

class _FirePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Glow â€” #FF9600
    canvas.drawCircle(
      Offset(w * .50, h * .55),
      w * .38,
      Paint()
        ..color = const Color(0xFFFF9600).withOpacity(.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    // Back flame â€” #CB3E3E
    final bp = Path()
      ..moveTo(w * .50, h * .06)
      ..cubicTo(w * .65, h * .18, w * .82, h * .30, w * .80, h * .52)
      ..cubicTo(w * .78, h * .68, w * .65, h * .78, w * .50, h * .82)
      ..cubicTo(w * .35, h * .78, w * .22, h * .68, w * .20, h * .52)
      ..cubicTo(w * .18, h * .30, w * .35, h * .18, w * .50, h * .06)
      ..close();
    canvas.drawPath(bp, Paint()..color = const Color(0xFFCB3E3E));
    // Main flame â€” #FF9600 â†’ #FF6B35 â†’ #FF4B4B
    final mp = Path()
      ..moveTo(w * .50, h * .10)
      ..cubicTo(w * .62, h * .20, w * .76, h * .34, w * .74, h * .54)
      ..cubicTo(w * .72, h * .70, w * .62, h * .80, w * .50, h * .84)
      ..cubicTo(w * .38, h * .80, w * .28, h * .70, w * .26, h * .54)
      ..cubicTo(w * .24, h * .34, w * .38, h * .20, w * .50, h * .10)
      ..close();
    canvas.drawPath(
      mp,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFFFF9600), Color(0xFFFF6B35), Color(0xFFFF4B4B)],
          stops: [0, .5, 1],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    // Inner â€” #FFD900 â†’ #FF9600 â†’ #FF6B35
    final ip = Path()
      ..moveTo(w * .50, h * .22)
      ..cubicTo(w * .58, h * .30, w * .66, h * .42, w * .64, h * .56)
      ..cubicTo(w * .62, h * .68, w * .56, h * .75, w * .50, h * .78)
      ..cubicTo(w * .44, h * .75, w * .38, h * .68, w * .36, h * .56)
      ..cubicTo(w * .34, h * .42, w * .42, h * .30, w * .50, h * .22)
      ..close();
    canvas.drawPath(
      ip,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFFFFD900), Color(0xFFFF9600), Color(0xFFFF6B35)],
          stops: [0, .55, 1],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _BooksStackIllustration extends StatelessWidget {
  final double size;
  const _BooksStackIllustration({this.size = 56});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _BooksStackPainter()),
  );
}

class _BooksStackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // All spine/face colors from palette only
    _drawBook(
      canvas,
      Rect.fromLTWH(w * .08, h * .60, w * .84, h * .22),
      const Color(0xFF1CB0F6),
      const Color(0xFF0081C8),
      4.0,
    );
    _drawBook(
      canvas,
      Rect.fromLTWH(w * .12, h * .38, w * .76, h * .22),
      const Color(0xFF58CC02),
      const Color(0xFF45A700),
      4.0,
    );
    _drawBook(
      canvas,
      Rect.fromLTWH(w * .16, h * .18, w * .68, h * .22),
      const Color(0xFFFF9600),
      const Color(0xFFFF6B35),
      4.0,
    );
  }

  void _drawBook(
    Canvas canvas,
    Rect rect,
    Color face,
    Color spine,
    double depth,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.top + depth, depth, rect.height - depth),
      Paint()..color = spine,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()
        ..shader = LinearGradient(
          colors: [face, Color.lerp(face, Colors.white, .18)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect),
    );
    canvas.drawLine(
      Offset(rect.left + 6, rect.top + 3),
      Offset(rect.left + 6, rect.bottom - 3),
      Paint()
        ..color = Colors.white.withOpacity(.30)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// ROOT SCREEN
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
      _DashboardPage(
        dashboardData: dashboardData,
        onOpenAiTutor: () => setState(() => _current = 3),
        onOpenCoding: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CodingPlaygroundPage()),
        ),
        onOpenCertificates: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CertificatesPage()),
        ),
        onOpenProfile: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        ),
      ),
      CoursesPage(),
      AssignmentsPage(),
      const AIChatbotPage(),
      const CodingPlaygroundPage(),
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

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// DASHBOARD PAGE
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AppleNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AppleNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.house_rounded, Icons.house_outlined, 'Home'),
    (Icons.menu_book_rounded, Icons.menu_book_outlined, 'Courses'),
    (Icons.assignment_rounded, Icons.assignment_outlined, 'Tasks'),
    (Icons.auto_awesome_rounded, Icons.auto_awesome_outlined, 'AI'),
    (Icons.code_rounded, Icons.code_outlined, 'Coding'),
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
                BoxShadow(
                  color: Colors.black.withOpacity(.10),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
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
                                  borderRadius: BorderRadius.circular(9),
                                )
                              : null,
                          child: Icon(
                            active ? _items[i].$1 : _items[i].$2,
                            color: active ? _T.blue : _T.labelTertiary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _items[i].$3,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w400,
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
