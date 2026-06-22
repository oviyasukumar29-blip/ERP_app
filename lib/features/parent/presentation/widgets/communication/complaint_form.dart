import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

class ComplaintForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const ComplaintForm({super.key, this.onSubmit});

  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _subjectCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  String _category = 'Academic';
  bool _submitting = false;

  static const _categories = [
    ('Academic', '📚'),
    ('Behaviour', '🤝'),
    ('Facilities', '🏫'),
    ('Transport', '🚌'),
    ('Other', '📌'),
  ];

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_subjectCtrl.text.trim().isEmpty || _bodyCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate API
    if (mounted) {
      Navigator.pop(context);
      widget.onSubmit?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complaint submitted',
              style: GoogleFonts.fredoka(color: Colors.white)),
          backgroundColor: PT.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: PT.bgElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: PT.separator,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Raise a Concern', style: PT.headline()),
          const SizedBox(height: 14),
          // Category chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final label = _categories[i].$1;
                final emoji = _categories[i].$2;
                final active = _category == label;
                return GestureDetector(
                  onTap: () => setState(() => _category = label),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: active ? PT.blueDeep : PT.bg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active ? PT.blueDeep : PT.separator,
                      ),
                    ),
                    child: Text(
                      '$emoji $label',
                      style: GoogleFonts.fredoka(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : PT.labelSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          _Field(
            controller: _subjectCtrl,
            hint: 'Subject',
            maxLines: 1,
          ),
          const SizedBox(height: 10),
          _Field(
            controller: _bodyCtrl,
            hint: 'Describe your concern...',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: PT.blueDeep,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text('Submit Complaint',
                      style: GoogleFonts.fredoka(
                          fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _Field({
    required this.controller,
    required this.hint,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: PT.subheadline(color: PT.labelPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: PT.subheadline(color: PT.labelQuaternary),
        filled: true,
        fillColor: PT.bg,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: PT.separator, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: PT.separator, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: PT.blueDeep, width: 1.5),
        ),
      ),
    );
  }
}
