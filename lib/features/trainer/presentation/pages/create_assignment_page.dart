// lib/features/trainer/presentation/pages/create_assignment_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinesphere_erp/core/theme/app_colors.dart';
import '../../../student/presentation/models/student_assignment.dart';

class CreateAssignmentPage extends StatefulWidget {
  final String? trainerId;
  final String? trainerName;

  const CreateAssignmentPage({super.key, this.trainerId, this.trainerName});

  @override
  State<CreateAssignmentPage> createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
  final _formKey             = GlobalKey<FormState>();
  final _titleController      = TextEditingController();
  final _subjectController    = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController    = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void _publish() {
    if (!_formKey.currentState!.validate()) return;

    // Use StudentAssignment — the shared model both sides use
    final assignment = StudentAssignment(
      id:          '${widget.trainerId ?? 'trainer'}-${DateTime.now().millisecondsSinceEpoch}',
      title:       _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      subject:     _subjectController.text.trim().isEmpty ? 'General' : _subjectController.text.trim(),
      dueDate:     _dueDateController.text.trim().isEmpty ? 'No deadline' : _dueDateController.text.trim(),
      status:      'Open',
    );

    Navigator.pop(context, assignment);
  }

  InputDecoration _dec(String label) => InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.inter(color: AppColors.textGrey),
    filled: true,
    fillColor: AppColors.white,
    border:        OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.border)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight.withAlpha(40),
      appBar: AppBar(
        title: Text('Create Assignment', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border, width: .8),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Assignment details',
                      style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: _dec('Title'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _subjectController,
                    decoration: _dec('Subject (e.g. Mathematics)'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: _dec('Description'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a description' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dueDateController,
                    decoration: _dec('Due Date'),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _publish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Publish Assignment',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.white)),
                    ),
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