// features/parent/presentation/pages/homework_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../parent_theme.dart';
import '../widgets/homework/homework_tile.dart';
import '../widgets/homework/deadline_card.dart';
import '../widgets/homework/assignment_tracker.dart';
import '../widgets/shared/loading_widget.dart';
import '../widgets/shared/empty_state_widget.dart';
import '../widgets/shared/parent_sub_app_bar.dart';
import '../../data/services/homework_service.dart';
import '../../data/models/child_model.dart';

class HomeworkPage extends StatefulWidget {
  final String selectedChildId;
  final String selectedChildName;

  const HomeworkPage({
    super.key,
    required this.selectedChildId,
    required this.selectedChildName,
  });

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage>
    with SingleTickerProviderStateMixin {
  final _service = HomeworkService();
  List<HomeworkItem> _homework = [];
  bool _loading = true;
  late TabController _tabController;

  static const _tabs = ['All', 'Pending', 'Submitted', 'Missed'];

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
    final data = await _service.getHomework(widget.selectedChildId);
    if (mounted) {
      setState(() {
        _homework = data;
        _loading = false;
      });
    }
  }

  List<HomeworkItem> get _filtered {
    final tab = _tabs[_tabController.index].toLowerCase();
    if (tab == 'all') return _homework;
    return _homework.where((h) => h.status.toLowerCase() == tab).toList();
  }

  int get _completedCount =>
      _homework.where((h) => h.status.toLowerCase() == 'submitted').length;

  HomeworkItem? get _nearestDeadline {
    final pending =
        _homework.where((h) => h.status.toLowerCase() == 'pending').toList();
    if (pending.isEmpty) return null;
    pending.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return pending.first;
  }

  String _dueLabel(DateTime due) {
    final now = DateTime.now();
    final diff = DateTime(due.year, due.month, due.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diff < 0) return 'Overdue';
    if (diff == 0) return 'Due today';
    if (diff == 1) return 'Due tomorrow';
    return 'Due in $diff days';
  }

  bool _isUrgent(DateTime due) {
    final diff = due.difference(DateTime.now()).inHours;
    return diff <= 24;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${date.day} ${months[date.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PT.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ParentSubAppBar(
              title: 'Homework',
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
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.fredoka(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: PT.labelTertiary,
                padding: const EdgeInsets.all(4),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
            Expanded(
              child: _loading
                  ? const ParentLoadingWidget()
                  : RefreshIndicator(
                      color: PT.blueDeep,
                      onRefresh: _load,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                        children: [
                          // Tracker (only on All tab)
                          if (_tabController.index == 0) ...[
                            AssignmentTracker(
                              completed: _completedCount,
                              total: _homework.length,
                              childName: widget.selectedChildName,
                            ),
                            const SizedBox(height: 14),
                          ],
                          // Nearest deadline alert
                          if (_tabController.index == 0 &&
                              _nearestDeadline != null) ...[
                            DeadlineCard(
                              subject: _nearestDeadline!.subject,
                              title: _nearestDeadline!.title,
                              childName: widget.selectedChildName,
                              dueLabel: _dueLabel(_nearestDeadline!.dueDate),
                              isUrgent: _isUrgent(_nearestDeadline!.dueDate),
                            ),
                            const SizedBox(height: 14),
                          ],
                          // Homework list
                          if (_filtered.isEmpty)
                            const EmptyStateWidget(
                              emoji: '📚',
                              message: 'No homework here. All caught up!',
                            )
                          else
                            Container(
                              decoration: PT.widgetCard,
                              child: Column(
                                children: List.generate(
                                  _filtered.length,
                                  (i) {
                                    final h = _filtered[i];
                                    return HomeworkTile(
                                      subject: h.subject,
                                      title: h.title,
                                      dueDate: _formatDate(h.dueDate),
                                      status: h.status,
                                      childName: widget.selectedChildName,
                                      last: i == _filtered.length - 1,
                                    );
                                  },
                                ),
                              ),
                            ),
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