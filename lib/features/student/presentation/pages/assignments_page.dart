// lib/features/student/presentation/pages/assignments_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'submission_success_page.dart';
import '../models/student_assignment.dart';
import '../../../trainer/data/repositories/assignment_store.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const _green      = Color(0xFF58CC02);
const _greenDark  = Color(0xFF45A700);
const _orange     = Color(0xFFFF9600);
const _blueDark   = Color(0xFF0081C8);
const _red        = Color(0xFFFF4B4B);
const _redDark    = Color(0xFFCB3E3E);

const _bg         = Color(0xFFF9F4EC);
const _cardCream  = Color(0xFFFFFAF4);
const _tintGreen  = Color(0xFFEEFBDD);
const _tintBlue   = Color(0xFFE3F5FE);
const _tintOrange = Color(0xFFFFF3E0);
const _tintRed    = Color(0xFFFFECEC);
const _labelPrimary  = Color(0xFF1C1C1E);
const _labelTertiary = Color(0xFF8E8E93);
const _separator     = Color(0xFFE5E5EA);

TextStyle _title2({Color? color}) => GoogleFonts.fredoka(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: color ?? _labelPrimary, height: 1.2);

TextStyle _subheadline({Color? color}) => GoogleFonts.fredoka(
    fontSize: 13, fontWeight: FontWeight.w500,
    color: color ?? _labelTertiary, height: 1.4);

TextStyle _caption1({Color? color}) => GoogleFonts.fredoka(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: color ?? _labelTertiary);

BoxDecoration _tintCard(Color tint, {double radius = 18}) => BoxDecoration(
    color: tint,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: tint.withAlpha(153), width: 0.5),
    boxShadow: [
      BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 12, offset: const Offset(0, 3)),
    ]);

// ── Page ──────────────────────────────────────────────────────────────────────
class StudentAssignmentsPage extends StatefulWidget {
  const StudentAssignmentsPage({super.key});

  @override
  State<StudentAssignmentsPage> createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage> {
  int _selectedFilter = 0;
  final _filters     = ['All', 'Pending', 'Done', 'Overdue'];
  final _filterIcons = [
    Icons.list_rounded,
    Icons.access_time_rounded,
    Icons.check_rounded,
    Icons.warning_amber_rounded,
  ];

  // Per-student submission status: assignmentId → status string
  final Map<String, String> _myStatuses = {};

  List<StudentAssignment> get _all => AssignmentStore.instance.getAll();

  String _statusFor(StudentAssignment a) =>
      _myStatuses[a.id] ?? a.status;

  List<StudentAssignment> get _filtered {
    switch (_selectedFilter) {
      case 1: return _all.where((a) => _statusFor(a) == 'Open').toList();
      case 2: return _all.where((a) =>
          _statusFor(a) == 'Submitted' || _statusFor(a) == 'Graded').toList();
      case 3: return _all.where((a) => _statusFor(a) == 'Late').toList();
      default: return _all;
    }
  }

  void _onSubmitted(String assignmentId) {
    setState(() {
      _myStatuses[assignmentId] = 'Submitted';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onRefresh: () => setState(() {})),
            _FilterRow(
              filters: _filters,
              icons: _filterIcons,
              selected: _selectedFilter,
              onSelect: (i) => setState(() => _selectedFilter = i),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    final list = _filtered;
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📭', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('No assignments here', style: _subheadline()),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _green,
      onRefresh: () async => setState(() {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
        children: [
          _SummaryRow(all: _all, statusFor: _statusFor),
          const SizedBox(height: 16),
          ...list.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AssignmentCard(
              assignment: a,
              myStatus: _statusFor(a),
              onSubmitted: () => _onSubmitted(a.id),
            ),
          )),
        ],
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final VoidCallback onRefresh;
  const _TopBar({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: _cardCream,
        border: Border(bottom: BorderSide(color: _separator, width: 0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Track your work', style: _caption1()),
                const SizedBox(height: 4),
                Text('Assignments', style: _title2()),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRefresh,
            child: Container(
              width: 46, height: 46,
              decoration: BoxDecoration(color: _tintOrange, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.refresh_rounded, color: _orange),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter row ────────────────────────────────────────────────────────────────
class _FilterRow extends StatelessWidget {
  final List<String> filters;
  final List<IconData> icons;
  final int selected;
  final ValueChanged<int> onSelect;

  const _FilterRow({required this.filters, required this.icons,
      required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _cardCream,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(filters.length, (i) {
            final active = i == selected;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? _tintGreen : _cardCream,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: active ? _green.withAlpha(71) : _separator),
                ),
                child: Row(children: [
                  Icon(icons[i], size: 14, color: active ? _greenDark : _labelTertiary),
                  const SizedBox(width: 6),
                  Text(filters[i], style: _subheadline(color: active ? _greenDark : _labelTertiary)),
                ]),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Summary row ───────────────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final List<StudentAssignment> all;
  final String Function(StudentAssignment) statusFor;
  const _SummaryRow({required this.all, required this.statusFor});

  @override
  Widget build(BuildContext context) {
    final pending = all.where((a) => statusFor(a) == 'Open').length;
    final done    = all.where((a) =>
        statusFor(a) == 'Submitted' || statusFor(a) == 'Graded').length;
    final overdue = all.where((a) => statusFor(a) == 'Late').length;

    return Row(
      children: [
        Expanded(child: _SummaryCard(label: 'Pending', value: '$pending', color: _orange)),
        const SizedBox(width: 10),
        Expanded(child: _SummaryCard(label: 'Done',    value: '$done',    color: _green)),
        const SizedBox(width: 10),
        Expanded(child: _SummaryCard(label: 'Overdue', value: '$overdue', color: _red)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _SummaryCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _tintCard(color.withAlpha(46)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text(label, style: _caption1()),
        ],
      ),
    );
  }
}

// ── Assignment card ───────────────────────────────────────────────────────────
class _AssignmentCard extends StatefulWidget {
  final StudentAssignment assignment;
  final String myStatus;
  final VoidCallback onSubmitted;
  const _AssignmentCard({required this.assignment, required this.myStatus, required this.onSubmitted});

  @override
  State<_AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<_AssignmentCard> {
  bool _submitting = false;

  bool get _isDone => widget.myStatus == 'Submitted' || widget.myStatus == 'Graded';
  bool get _isLate => widget.myStatus == 'Late';

  Color get _badgeBg    => _isLate ? _tintRed : _isDone ? _tintGreen : _tintOrange;
  Color get _badgeColor => _isLate ? _redDark : _isDone ? _greenDark : _orange;

  @override
  Widget build(BuildContext context) {
    final a = widget.assignment;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardCream,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _isLate ? _red.withAlpha(100) : _separator,
          width: _isLate ? 1.2 : 0.8,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: _isLate ? _tintRed : _tintBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.assignment_rounded, color: _isLate ? _red : _blueDark, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.title, style: _title2()),
                    const SizedBox(height: 2),
                    Text(a.subject, style: _caption1()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: _badgeBg, borderRadius: BorderRadius.circular(16)),
                child: Text(
                  widget.myStatus,
                  style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w600, color: _badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: _separator, thickness: 0.6),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(icon: Icons.access_time_rounded, text: a.dueDate),
              const Spacer(),
              if (_isDone)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: _tintGreen, borderRadius: BorderRadius.circular(14)),
                  child: Row(children: [
                    const Icon(Icons.check_rounded, color: _greenDark, size: 14),
                    const SizedBox(width: 4),
                    Text('Done', style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: _greenDark)),
                  ]),
                )
              else
                GestureDetector(
                  onTap: _submitting ? null : _submit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _isLate ? _red : _green,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(
                        color: (_isLate ? _red : _green).withAlpha(76),
                        blurRadius: 8, offset: const Offset(0, 3),
                      )],
                    ),
                    child: _submitting
                        ? const SizedBox(width: 14, height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(
                            _isLate ? 'Submit now' : 'Submit',
                            style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _submitting = false);

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, animation, __) => const SubmissionSuccessPage(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ).then((_) => widget.onSubmitted());
  }
}

// ── Info chip ─────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _separator, width: 0.8),
      ),
      child: Row(children: [
        Icon(icon, size: 14, color: _labelTertiary),
        const SizedBox(width: 6),
        Text(text, style: _caption1()),
      ]),
    );
  }
}