// features/parent/presentation/pages/parent_screen.dart
// ─────────────────────────────────────────────────────────────
// ROOT SCREEN — 5-tab scaffold mirroring StudentScreen exactly.
// Tabs: Home, Attendance, Fees, Progress, Homework
// Child switcher lives in the top app bar (ParentAppBar).
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../parent_theme.dart';
import 'dashboard_page.dart';
import 'attendance_page.dart';
import 'fees_page.dart';
import 'progress_page.dart';
import 'homework_page.dart';
import 'parent_profile_page.dart';
import 'notifications_page.dart';
import 'communication_page.dart';
import '../../data/services/parent_api_service.dart';
import '../../../auth/services/auth_service.dart';
import 'package:pinesphere_erp/features/auth/presentation/pages/login_screen.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  final _apiService = ParentApiService();

  int _currentTab = 0;
  List<Map<String, dynamic>> _children = [];
  int _selectedChildIndex = 0;
  bool _loading = true;

  // ── Nav tab items: (filled icon, outline icon, label)
  static const _navItems = [
    (Icons.house_rounded, Icons.house_outlined, 'Home'),
    (Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Attendance'),
    (Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Fees'),
    (Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Progress'),
    (Icons.menu_book_rounded, Icons.menu_book_outlined, 'Homework'),
  ];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      // getChildren() returns List<ChildModel> — convert each to a plain
      // Map so the rest of this screen (and the pages it pushes) can keep
      // working with selectedChildId / selectedChildName strings.
      final children = await _apiService.getChildren();

      // ✅ ADD THESE 3 LINES HERE
      for (final c in children) {
        debugPrint("Child: ${c.name} | progressPercent: ${c.progressPercent}");
      }

      final mapped = children
          .map((c) => {
                'id': c.id,
                'name': c.name,
                'course': c.course,
                'batch': c.batch,
                'branch': c.branch,
                'attendancePercent': c.attendancePercent,
                'feeStatus': c.feeStatus,
                'progressPercent': c.progressPercent,
                'xp': c.xp,
              })
          .toList();
      if (mounted) {
        setState(() {
          _children = mapped;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Map<String, dynamic> get _selectedChild =>
      _children.isNotEmpty ? _children[_selectedChildIndex] : {};

  String get _childId =>
      _selectedChild['id'] as String? ?? 'child_1';

  String get _childName =>
      _selectedChild['name'] as String? ?? 'Your Child';

  // ── Child switcher — shown as bottom sheet ────────────────
  void _showChildSwitcher() {
    if (_children.length <= 1) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChildSwitcherSheet(
        children: _children,
        selectedIndex: _selectedChildIndex,
        onSelect: (i) {
          setState(() => _selectedChildIndex = i);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ── Logout ────────────────────────────────────────────────
  Future<void> _logout() async {
    await AuthService().logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  // ── Build active page ─────────────────────────────────────
  Widget _buildPage() {
    if (_loading) {
      return const Scaffold(
        backgroundColor: PT.bg,
        body: Center(
          child: CircularProgressIndicator(color: PT.blueDeep),
        ),
      );
    }

    switch (_currentTab) {
      case 0:
        return DashboardPage(
          selectedChildId: _childId,
          selectedChildName: _childName,
          children: _children,
          selectedChildIndex: _selectedChildIndex,
          onSwitchChild: _showChildSwitcher,
          onOpenAttendance: () => setState(() => _currentTab = 1),
          onOpenFees: () => setState(() => _currentTab = 2),
          onOpenProgress: () => setState(() => _currentTab = 3),
          onOpenHomework: () => setState(() => _currentTab = 4),
          onOpenNotifications: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NotificationsPage(
                selectedChildId: _childId,
                selectedChildName: _childName,
              ),
            ),
          ),
          onOpenCommunication: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CommunicationPage(
                selectedChildId: _childId,
                selectedChildName: _childName,
              ),
            ),
          ),
          onOpenProfile: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ParentProfilePage(
                selectedChildId: _childId,
                selectedChildName: _childName,
                onLogout: _logout,
              ),
            ),
          ),
        );
      case 1:
        return AttendancePage(
          selectedChildId: _childId,
          selectedChildName: _childName,
        );
      case 2:
        return FeesPage(
          selectedChildId: _childId,
          selectedChildName: _childName,
        );
      case 3:
        return ProgressPage(
          selectedChildId: _childId,
          selectedChildName: _childName,
        );
      case 4:
        return HomeworkPage(
          selectedChildId: _childId,
          selectedChildName: _childName,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: PT.bg,
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeIn,
          child: KeyedSubtree(
            key: ValueKey(_currentTab),
            child: _buildPage(),
          ),
        ),
        bottomNavigationBar: _ParentNavBar(
          currentIndex: _currentTab,
          onTap: (i) => setState(() => _currentTab = i),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BOTTOM NAV — identical shape to student _AppleNavBar
// ─────────────────────────────────────────────────────────────
class _ParentNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _ParentNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.house_rounded, Icons.house_outlined, 'Home'),
    (Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Attendance'),
    (Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Fees'),
    (Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Progress'),
    (Icons.menu_book_rounded, Icons.menu_book_outlined, 'Homework'),
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
              color: Colors.white.withValues(alpha: .92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: PT.separator, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .10),
                  blurRadius: 30,
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
                                  color: PT.blueDeep.withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(9),
                                )
                              : null,
                          child: Icon(
                            active ? _items[i].$1 : _items[i].$2,
                            color: active ? PT.blueDeep : PT.labelTertiary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _items[i].$3,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color:
                                active ? PT.blueDeep : PT.labelTertiary,
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

// ─────────────────────────────────────────────────────────────
// CHILD SWITCHER SHEET
// ─────────────────────────────────────────────────────────────
class _ChildSwitcherSheet extends StatelessWidget {
  final List<Map<String, dynamic>> children;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _ChildSwitcherSheet({
    required this.children,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
      decoration: const BoxDecoration(
        color: PT.bgElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: PT.separator,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          Text('Switch Child', style: PT.headline()),
          const SizedBox(height: 14),
          ...List.generate(children.length, (i) {
            final child = children[i];
            final isSelected = i == selectedIndex;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? PT.tintBlue : PT.bg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? PT.blueDeep.withValues(alpha: .30)
                        : PT.separator,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected ? PT.blueDeep : PT.tintBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('👧', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            child['name'] as String? ?? 'Child',
                            style: PT.subheadline(color: PT.labelPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Grade ${child['grade'] ?? ''} · Section ${child['section'] ?? ''}',
                            style: PT.caption1(color: PT.labelTertiary),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: PT.blueDeep, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}