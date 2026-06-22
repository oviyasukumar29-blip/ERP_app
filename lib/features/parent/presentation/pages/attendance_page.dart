// features/parent/presentation/pages/attendance_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../parent_theme.dart';
import '../../data/services/attendance_service.dart';
import '../../data/models/child_model.dart';
import '../widgets/shared/section_header.dart';
import '../widgets/shared/loading_widget.dart';
import '../widgets/shared/error_widget.dart';
import '../widgets/attendance/attendance_chart.dart';
import '../widgets/attendance/attendance_calendar.dart';
import '../widgets/attendance/absence_alert_card.dart';

class AttendancePage extends StatefulWidget {
  final String selectedChildId;
  final String selectedChildName;

  const AttendancePage({
    super.key,
    required this.selectedChildId,
    required this.selectedChildName,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _service = AttendanceService();

  List<AttendanceRecord>? _records;
  Map<String, dynamic>? _summary;
  List<AttendanceRecord>? _recentAbsences;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(AttendancePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedChildId != widget.selectedChildId) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final results = await Future.wait([
        _service.getMonthlyAttendance(widget.selectedChildId),
        _service.getAttendanceSummary(widget.selectedChildId),
        _service.getRecentAbsences(widget.selectedChildId),
      ]);
      if (!mounted) return;
      setState(() {
        _records = results[0] as List<AttendanceRecord>;
        _summary = results[1] as Map<String, dynamic>;
        _recentAbsences = results[2] as List<AttendanceRecord>;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Attendance load error: $e");
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
    return Scaffold(
      backgroundColor: PT.bg,
      appBar: AppBar(
        backgroundColor: PT.bg,
        elevation: 0,
        title: Text("Attendance", style: PT.title3()),
        iconTheme: const IconThemeData(color: PT.labelPrimary),
      ),
      body: _loading
          ? const Center(child: ParentLoadingWidget())
          : _error
              ? Center(child: ParentErrorWidget(onRetry: _load))
              : RefreshIndicator(
                  onRefresh: _load,
                  color: PT.primary,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    children: [
                      Text(
                        "${widget.selectedChildName}'s record",
                        style: PT.subheadline(color: PT.labelTertiary),
                      ),
                      const SizedBox(height: 12),
                      _SummaryStrip(summary: _summary ?? const {}),
                      const SizedBox(height: 16),
                      const SectionHeader(title: "📅 This Week"),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: PT.widgetCard,
                        child: AttendanceChart(records: _records ?? []),
                      ),
                      const SizedBox(height: 16),
                      const SectionHeader(title: "🗓️ Monthly View"),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: PT.widgetCard,
                        child: AttendanceCalendar(
                          month: DateTime.now(),
                          records: _records ?? [],
                        ),
                      ),
                      const SizedBox(height: 16),
                      AbsenceAlertCard(recentAbsences: _recentAbsences ?? []),
                    ],
                  ),
                ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  final Map<String, dynamic> summary;

  const _SummaryStrip({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBlock(
            value: "${summary["percent"] ?? 0}%",
            label: "Attendance",
            color: PT.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatBlock(
            value: "${summary["present"] ?? 0}",
            label: "Present",
            color: PT.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatBlock(
            value: "${summary["absent"] ?? 0}",
            label: "Absent",
            color: PT.red,
          ),
        ),
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatBlock({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: PT.tintCard(color.withValues(alpha: .10)),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: PT.caption2(color: color)),
        ],
      ),
    );
  }
}