// features/parent/presentation/pages/progress_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../parent_theme.dart';
import '../widgets/progress/academic_report_card.dart';
import '../widgets/progress/progress_card.dart';
import '../widgets/progress/marks_chart.dart';
import '../widgets/progress/skill_chart.dart';
import '../widgets/shared/loading_widget.dart';
import '../widgets/shared/empty_state_widget.dart';
import '../widgets/shared/parent_sub_app_bar.dart';
import '../../data/services/progress_service.dart';
import '../../data/models/child_model.dart';

class ProgressPage extends StatefulWidget {
  final String selectedChildId;
  final String selectedChildName;

  const ProgressPage({
    super.key,
    required this.selectedChildId,
    required this.selectedChildName,
  });

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  final _service = ProgressService();

  List<ProgressMark> _marks = [];
  Map<String, num> _skills = {};
  String _aiSummary = '';
  num _overallProgress = 0;
  bool _loading = true;

  late TabController _tabController;

  static const _tabs = ['Overview', 'Subjects', 'Skills'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _service.getMarks(widget.selectedChildId),
      _service.getSkillGraph(widget.selectedChildId),
      _service.getAiWeeklySummary(widget.selectedChildId),
      _service.getOverallProgress(widget.selectedChildId),
    ]);
    if (mounted) {
      setState(() {
        _marks = results[0] as List<ProgressMark>;
        _skills = results[1] as Map<String, num>;
        _aiSummary = results[2] as String;
        _overallProgress = results[3] as num;
        _loading = false;
      });
      print('DEBUG: loaded ${_marks.length} marks: ${_marks.map((m) => m.subject).toList()}');
    }
  }

  String _gradeFor(num percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    final hasData = _marks.isNotEmpty || _skills.isNotEmpty;

    return Scaffold(
      backgroundColor: PT.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ParentSubAppBar(
              title: 'Progress',
              subtitle: widget.selectedChildName,
              showBackButton: true,
            ),
            // Tab bar
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              height: 40,
              decoration: BoxDecoration(
                color: PT.separator.withValues(alpha: .4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (_) => setState(() {}),
                indicator: BoxDecoration(
                  color: PT.blueDeep,
                  borderRadius: BorderRadius.circular(11),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.fredoka(
                    fontSize: 12, fontWeight: FontWeight.w600),
                unselectedLabelStyle: GoogleFonts.fredoka(
                    fontSize: 12, fontWeight: FontWeight.w500),
                labelColor: Colors.white,
                unselectedLabelColor: PT.labelTertiary,
                padding: const EdgeInsets.all(4),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
            Expanded(
              child: _loading
                  ? const ParentLoadingWidget()
                  : !hasData
                      ? const EmptyStateWidget(
                          emoji: '📊',
                          message:
                              'No progress data. Results will appear here after exams.',
                        )
                      : RefreshIndicator(
                          color: PT.blueDeep,
                          onRefresh: _load,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _OverviewTab(
                                marks: _marks,
                                overallProgress: _overallProgress,
                                aiSummary: _aiSummary,
                                gradeFor: _gradeFor,
                              ),
                              _SubjectsTab(marks: _marks, gradeFor: _gradeFor),
                              _SkillsTab(skills: _skills),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Overview Tab ─────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final List<ProgressMark> marks;
  final num overallProgress;
  final String aiSummary;
  final String Function(num) gradeFor;

  const _OverviewTab({
    required this.marks,
    required this.overallProgress,
    required this.aiSummary,
    required this.gradeFor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
      children: [
        AcademicReportCard(
          overallGrade: gradeFor(overallProgress),
          overallPercentage: overallProgress.toDouble(),
          // Placeholder until a real ranking endpoint exists.
          classRank: 5,
          totalStudents: 30,
          teacherRemark: aiSummary.isNotEmpty
              ? aiSummary
              : 'Shows consistent improvement across all subjects.',
          term: 'Term 1 · 2024–25',
        ),
        const SizedBox(height: 16),
        if (marks.isNotEmpty)
          MarksChart(
            marks: marks
                .map((m) => {
                      'label': m.subject,
                      'score': m.score,
                      'max': m.maxScore,
                    })
                .toList(),
          ),
      ],
    );
  }
}

// ── Subjects Tab ──────────────────────────────────────────────
class _SubjectsTab extends StatelessWidget {
  final List<ProgressMark> marks;
  final String Function(num) gradeFor;

  const _SubjectsTab({required this.marks, required this.gradeFor});

  @override
  Widget build(BuildContext context) {
    if (marks.isEmpty) {
      return const EmptyStateWidget(
        emoji: '📚',
        message: 'No subject data. Subject results appear after exams.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
      children: marks.map((m) {
        final percentage = (m.score / m.maxScore) * 100;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ProgressCard(
            subject: m.subject,
            percentage: percentage,
            grade: gradeFor(percentage),
            // No historical comparison data available yet — default to
            // a neutral trend rather than fabricating a direction.
            trend: 'stable',
            trendLabel: 'This term',
          ),
        );
      }).toList(),
    );
  }
}

// ── Skills Tab ────────────────────────────────────────────────
class _SkillsTab extends StatelessWidget {
  final Map<String, num> skills;
  const _SkillsTab({required this.skills});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const EmptyStateWidget(
        emoji: '🌟',
        message: 'No skill data yet. Skill assessments will appear here.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
      children: [
        SkillChart(
          skills: skills.entries
             .map((e) => {'name': e.key, 'value': e.value})
              .toList(),
        ),
      ],
    );
  }
}