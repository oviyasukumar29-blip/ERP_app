// features/parent/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../parent_theme.dart';
import '../../data/models/child_model.dart';
import '../../data/services/parent_api_service.dart';
import '../../data/services/attendance_service.dart';
import '../../data/services/fees_service.dart';
import '../../data/services/homework_service.dart';
import '../widgets/shared/section_header.dart';
import '../widgets/shared/loading_widget.dart';
import '../widgets/shared/empty_state_widget.dart';
import '../widgets/dashboard/child_card.dart';
import '../widgets/dashboard/attendance_overview_card.dart';
import '../widgets/dashboard/fees_status_card.dart';
import '../widgets/dashboard/progress_summary_card.dart';
import '../widgets/dashboard/ai_report_card.dart';
import '../../../auth/services/auth_service.dart';
import 'package:pinesphere_erp/features/auth/presentation/pages/login_screen.dart';

class DashboardPage extends StatefulWidget {
  final String selectedChildId;
  final String selectedChildName;
  final List<Map<String, dynamic>> children;
  final int selectedChildIndex;
  final VoidCallback onSwitchChild;
  final VoidCallback onOpenAttendance;
  final VoidCallback onOpenFees;
  final VoidCallback onOpenProgress;
  final VoidCallback onOpenHomework;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenCommunication;
  final VoidCallback onOpenProfile;

  const DashboardPage({
    super.key,
    required this.selectedChildId,
    required this.selectedChildName,
    required this.children,
    required this.selectedChildIndex,
    required this.onSwitchChild,
    required this.onOpenAttendance,
    required this.onOpenFees,
    required this.onOpenProgress,
    required this.onOpenHomework,
    required this.onOpenNotifications,
    required this.onOpenCommunication,
    required this.onOpenProfile,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _api = ParentApiService();
  final _attendanceService = AttendanceService();
  final _feesService = FeesService();
  final _homeworkService = HomeworkService();

  Map<String, dynamic>? _summary;
  Map<String, dynamic>? _attendanceSummary;
  Map<String, dynamic>? _feeSummary;
  Map<String, int>? _homeworkSummary;

  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void didUpdateWidget(DashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedChildId != widget.selectedChildId) {
      _loadAll();
    }
  }

  // Builds a ChildModel from the currently-selected child's map.
  // progressPercent comes from getChildren() → real backend data → per-child
  // progress_percent, so it is already correct per child without needing
  // getDashboardSummary to be wired up.
  ChildModel get _selectedChildModel {
    final raw = widget.children.isNotEmpty
        ? widget.children[widget.selectedChildIndex]
        : <String, dynamic>{};
    return ChildModel(
      id: raw['id'] as String? ?? widget.selectedChildId,
      name: raw['name'] as String? ?? widget.selectedChildName,
      course: raw['course'] as String? ?? '',
      batch: raw['batch'] as String? ?? '',
      branch: raw['branch'] as String? ?? '',
      attendancePercent: (raw['attendancePercent'] as num?)?.toInt() ?? 0,
      feeStatus: raw['feeStatus'] as String? ?? 'pending',
      // ✅ This is the field ChildCard uses for the progress bar.
      //    It is populated from the real /parent/{id}/children endpoint
      //    via getChildren(), so each child will show their own value.
      progressPercent: (raw['progressPercent'] as num?)?.toInt() ?? 0,
      xp: (raw['xp'] as num?)?.toInt() ?? 0,
    );
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final results = await Future.wait([
        _api.getDashboardSummary(widget.selectedChildId),
        _attendanceService.getAttendanceSummary(widget.selectedChildId),
        _feesService.getFeeSummary(widget.selectedChildId),
        _homeworkService.getHomeworkSummary(widget.selectedChildId),
      ]);
      if (!mounted) return;
      setState(() {
        _summary = results[0] as Map<String, dynamic>;
        _attendanceSummary = results[1] as Map<String, dynamic>;
        _feeSummary = results[2] as Map<String, dynamic>;
        _homeworkSummary = results[3] as Map<String, int>;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Parent dashboard error: $e");
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: ParentLoadingWidget(message: "Loading dashboard..."),
      );
    }
    if (_error) {
      return Center(
        child: EmptyStateWidget(
          emoji: '⚠️',
          message: "Couldn't load the dashboard. Pull down to retry.",
        ),
      );
    }

    final skillScores = (_summary?["skill_scores"] as Map?)
            ?.map((k, v) => MapEntry(k.toString(), (v as num))) ??
        <String, num>{};

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _TopBar(
            childName: widget.selectedChildName,
            onOpenProfile: widget.onOpenProfile,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadAll,
              color: PT.primary,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                children: [
                  // ✅ FIX: learningProgress is intentionally NOT passed here.
                  //
                  //    Previously, learningProgress was set from
                  //    _summary?['course_progress'], but getDashboardSummary()
                  //    is still a mock that returns 0 for every child — so it
                  //    was overriding the real per-child value with zero.
                  //
                  //    Without learningProgress, ChildCard falls back to
                  //    child.progressPercent, which comes from _selectedChildModel
                  //    → widget.children[selectedChildIndex]['progressPercent']
                  //    → the real /parent/{id}/children endpoint via getChildren().
                  //
                  //    When getDashboardSummary() is wired to a real endpoint,
                  //    re-add: learningProgress: (cp != null && cp > 0) ? cp.toDouble() : null
                  ChildCard(
                    child: _selectedChildModel,
                    onTap: widget.onOpenProgress,
                  ),
                  const SizedBox(height: 14),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: AttendanceOverviewCard(
                            percent: (_attendanceSummary?["percent"] as num?)?.toInt() ?? 0,
                            present: (_attendanceSummary?["present"] as num?)?.toInt() ?? 0,
                            absent: (_attendanceSummary?["absent"] as num?)?.toInt() ?? 0,
                            onTap: widget.onOpenAttendance,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FeesStatusCard(
                            dueAmount: (_feeSummary?["total_due"] as num?) ?? 0,
                            status: _feeSummary?["status"] as String? ?? "pending",
                            nextDueDate: _feeSummary?["next_due_date"] as DateTime?,
                            onTap: widget.onOpenFees,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  AiReportCard(
                    summary: _summary?["ai_summary"] as String? ??
                        "AI summary will appear here once available.",
                    onViewFullReport: widget.onOpenProgress,
                  ),
                  const SizedBox(height: 14),
                  ProgressSummaryCard(
                    skillScores: skillScores,
                    onSeeAll: widget.onOpenProgress,
                  ),
                  const SizedBox(height: 14),
                  _HomeworkSummaryRow(
                    summary: _homeworkSummary ?? const {},
                    onTap: widget.onOpenHomework,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeworkSummaryRow extends StatelessWidget {
  final Map<String, int> summary;
  final VoidCallback onTap;

  const _HomeworkSummaryRow({required this.summary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "📝 Homework", action: "See All", onActionTap: onTap),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _HwChip(
                label: "Pending",
                count: summary["pending"] ?? 0,
                color: PT.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _HwChip(
                label: "Submitted",
                count: summary["submitted"] ?? 0,
                color: PT.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _HwChip(
                label: "Missed",
                count: summary["missed"] ?? 0,
                color: PT.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HwChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _HwChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: PT.tintCard(color.withValues(alpha: .10)),
      child: Column(
        children: [
          Text(
            "$count",
            style: PT.numeric(color: color, size: 18),
          ),
          const SizedBox(height: 2),
          Text(label, style: PT.caption2(color: color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TOP BAR — Parent Dashboard Header
// ─────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String childName;
  final VoidCallback onOpenProfile;

  const _TopBar({required this.childName, required this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: PT.bg,
      child: Row(
        children: [
          GestureDetector(
            onTap: onOpenProfile,
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
              onTap: onOpenProfile,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PINESPHERE", style: PT.title3()),
                  Text(
                    childName.isNotEmpty
                        ? "Parent of $childName 👋"
                        : "Welcome back 👋",
                    style: PT.title3().copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: PT.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.family_restroom_rounded,
                  color: Colors.white,
                  size: 13,
                ),
                const SizedBox(width: 5),
                Text(
                  "Parent",
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
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
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
                color: PT.bgElevated,
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
                color: PT.labelTertiary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}