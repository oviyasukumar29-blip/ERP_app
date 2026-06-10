// lib/features/trainer/presentation/pages/assignments_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinesphere_erp/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_assignment_page.dart';
import '../../../student/presentation/models/student_assignment.dart';
import '../../data/repositories/assignment_store.dart';
import '../widgets/assignments/submission_summary_card.dart';
import '../widgets/assignments/upload_assignment_card.dart';

class TrainerAssignmentsPage extends StatefulWidget {
  const TrainerAssignmentsPage({super.key});

  @override
  State<TrainerAssignmentsPage> createState() => _TrainerAssignmentsPageState();
}

class _TrainerAssignmentsPageState extends State<TrainerAssignmentsPage> {
  bool _isLoading = true;
  String? _trainerId;
  String? _trainerName;

  @override
  void initState() {
    super.initState();
    _initContext();
  }

  Future<void> _initContext() async {
    final prefs = await SharedPreferences.getInstance();
    _trainerId   = prefs.getString('trainer_id')   ?? 'trainer-1';
    _trainerName = prefs.getString('trainer_name') ?? 'Trainer';
    await prefs.setString('trainer_id',   _trainerId!);
    await prefs.setString('trainer_name', _trainerName!);
    if (mounted) setState(() => _isLoading = false);
  }

  List<StudentAssignment> get _myAssignments =>
      AssignmentStore.instance.getByTrainer(_trainerId ?? '');

  List<StudentAssignment> _byStatus(String status) =>
      _myAssignments.where((a) => a.status == status).toList();

  Future<void> _handleCreate() async {
    final created = await Navigator.push<StudentAssignment>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateAssignmentPage(
          trainerId:   _trainerId,
          trainerName: _trainerName,
        ),
      ),
    );
    if (created != null && mounted) {
      AssignmentStore.instance.add(created);
      setState(() {});
    }
  }

  Future<void> _handleViewSubmissions(StudentAssignment assignment) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '${assignment.title} — Submissions',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('Due: ${assignment.dueDate}',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey)),
              const Divider(height: 24),
              Text('No submissions data available.',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textGrey)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.inter(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedSection() {
    final list = _myAssignments;
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: AppColors.primary.withAlpha(100)),
            const SizedBox(height: 16),
            Text('No assignments yet',
                style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textGrey)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📚 Your Assignments',
            style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const SizedBox(height: 16),
        ...list.map((a) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border, width: 1.5),
              boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(15), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.title,
                              style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Text(a.subject,
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        const Icon(Icons.schedule, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(a.dueDate.split(',')[0],
                            style: GoogleFonts.inter(fontSize: 11, color: Colors.amber.shade900, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(a.description,
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.textGrey, height: 1.5)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleViewSubmissions(a),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('👁 View Submissions',
                        style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.white)),
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('📝 Assignments',
            style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              children: [
                SubmissionSummaryCard(
                  submitted:         _byStatus('Submitted').length,
                  reviewPending:     _byStatus('Submitted').length,
                  pendingSubmission: _byStatus('Open').length + _byStatus('Late').length,
                ),
                const SizedBox(height: 16),
                UploadAssignmentCard(onUpload: _handleCreate),
                const SizedBox(height: 24),
                _buildAssignedSection(),
              ],
            ),
    );
  }
}