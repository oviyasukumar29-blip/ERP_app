// features/student/presentation/pages/assignments_page.dart

import '../../data/services/assignment_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'submission_success_page.dart';

const _green       = Color(0xFF58CC02);
const _greenDark   = Color(0xFF45A700);
const _orange      = Color(0xFFFF9600);
const _blue        = Color(0xFF1CB0F6);
const _blueDark    = Color(0xFF0081C8);
const _blueDeep    = Color(0xFF2B70C9);
const _red         = Color(0xFFFF4B4B);
const _redDark     = Color(0xFFCB3E3E);
const _purple      = Color(0xFFCE82FF);
const _purpleDark  = Color(0xFFB800FF);
const _yellow      = Color(0xFFFFD900);
const _coral       = Color(0xFFFF6B35);

const _bg          = Color(0xFFFDF6EC);
const _cardCream   = Color(0xFFFFFAF4);

const _tintGreen   = Color(0xFFEEFBDD);
const _tintBlue    = Color(0xFFE3F5FE);
const _tintOrange  = Color(0xFFFFF3E0);
const _tintRed     = Color(0xFFFFECEC);
const _tintPurple  = Color(0xFFF8EDFF);
const _tintYellow  = Color(0xFFFFFBE0);

const _labelPrimary    = Color(0xFF1C1C1E);
const _labelSecondary  = Color(0xFF3C3C43);
const _labelTertiary   = Color(0xFF8E8E93);
const _labelQuaternary = Color(0xFFC7C7CC);
const _separator       = Color(0xFFE5E5EA);

TextStyle _title2({Color? color}) => GoogleFonts.inter(
    fontSize: 17, fontWeight: FontWeight.w600,
    color: color ?? _labelPrimary, letterSpacing: -0.41, height: 1.3);

TextStyle _subheadline({Color? color}) => GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w500,
    color: color ?? _labelTertiary, letterSpacing: -0.08, height: 1.4);

TextStyle _caption1({Color? color}) => GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: color ?? _labelTertiary, letterSpacing: 0.07);

BoxDecoration _tintCard(Color tint, {double radius = 18}) => BoxDecoration(
      color: tint,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: tint.withOpacity(.60), width: 0.5),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12, offset: const Offset(0, 3)),
      ],
    );

enum AssignmentStatus { pending, overdue, completed }

class Assignment {
  final String title;
  final String subject;
  final String teacher;
  final String badgeLabel;
  final Color badgeBg;
  final Color badgeColor;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String timeLabel;
  final String filesLabel;
  final AssignmentStatus status;
  final Color? cardBorder;
  final Color? submitColor;
  final String submitLabel;

  const Assignment({
    required this.title,
    required this.subject,
    required this.teacher,
    required this.badgeLabel,
    required this.badgeBg,
    required this.badgeColor,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.timeLabel,
    required this.filesLabel,
    required this.status,
    this.cardBorder,
    this.submitColor,
    this.submitLabel = 'Submit',
  });
}

final _pendingAssignments = [
  const Assignment(
    title: 'Algebra — Chapter 5',
    subject: 'Mathematics',
    teacher: 'Ms. Anita',
    badgeLabel: 'Due today',
    badgeBg: _tintRed,
    badgeColor: _redDark,
    iconBg: _tintPurple,
    iconColor: _purple,
    icon: Icons.functions_rounded,
    timeLabel: '11:59 PM',
    filesLabel: 'No files',
    status: AssignmentStatus.pending,
  ),
  const Assignment(
    title: "Newton's laws worksheet",
    subject: 'Physics',
    teacher: 'Mr. Rajesh',
    badgeLabel: '2 days',
    badgeBg: _tintOrange,
    badgeColor: Color(0xFF633806),
    iconBg: _tintBlue,
    iconColor: _blueDark,
    icon: Icons.science_outlined,
    timeLabel: 'Tomorrow',
    filesLabel: '1 file',
    status: AssignmentStatus.pending,
  ),
  const Assignment(
    title: 'Essay — Industrial Revolution',
    subject: 'History',
    teacher: 'Mrs. Priya',
    badgeLabel: '5 days',
    badgeBg: _tintGreen,
    badgeColor: _greenDark,
    iconBg: _tintGreen,
    iconColor: _greenDark,
    icon: Icons.edit_outlined,
    timeLabel: 'Fri, 30 May',
    filesLabel: 'No files',
    status: AssignmentStatus.pending,
  ),
];

final _overdueAssignments = [
  Assignment(
    title: 'Chemistry lab report',
    subject: 'Chemistry',
    teacher: 'Mrs. Priya',
    badgeLabel: 'Overdue',
    badgeBg: _tintRed,
    badgeColor: _redDark,
    iconBg: _tintRed,
    iconColor: _red,
    icon: Icons.biotech_outlined,
    timeLabel: 'Was Mon',
    filesLabel: '2 files',
    status: AssignmentStatus.overdue,
    cardBorder: _red,
    submitColor: _red,
    submitLabel: 'Submit now',
  ),
];

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Pending', 'Done', 'Overdue'];
  final _filterIcons = [
    Icons.list_rounded,
    Icons.access_time_rounded,
    Icons.check_rounded,
    Icons.warning_amber_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDF6EC), Color(0xFFFAF0E4)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const _TopBar(),
              _FilterRow(
                filters: _filters,
                icons: _filterIcons,
                selected: _selectedFilter,
                onSelect: (i) => setState(() => _selectedFilter = i),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
                  children: [
                    _SummaryRow(),
                    const SizedBox(height: 14),
                    const _SectionHeader(label: 'Pending'),
                    const SizedBox(height: 10),
                    ..._pendingAssignments.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AssignmentCard(assignment: a),
                        )),
                    const SizedBox(height: 4),
                    const _SectionHeader(label: 'Overdue'),
                    const SizedBox(height: 10),
                    ..._overdueAssignments.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AssignmentCard(assignment: a),
                        )),
                    const SizedBox(height: 4),
                    const _SectionHeader(label: 'Completed', showAction: true),
                    const SizedBox(height: 10),
                    const _CompletedBanner(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      decoration: BoxDecoration(
        color: _cardCream,
        border: Border(bottom: BorderSide(color: _separator, width: .5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Track your work', style: _caption1()),
                const SizedBox(height: 2),
                Text(
                  'Assignments',
                  style: GoogleFonts.inter(
                      fontSize: 22, fontWeight: FontWeight.w600,
                      color: _labelPrimary, letterSpacing: -0.5, height: 1.1),
                ),
              ],
            ),
          ),
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: _tintOrange,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: _orange.withOpacity(.25), width: 1),
              boxShadow: [
                BoxShadow(color: _orange.withOpacity(.10),
                    blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: const Icon(Icons.tune_rounded, color: _orange, size: 20),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final List<String> filters;
  final List<IconData> icons;
  final int selected;
  final ValueChanged<int> onSelect;

  const _FilterRow({
    required this.filters,
    required this.icons,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _cardCream,
        border: Border(bottom: BorderSide(color: _separator, width: .5)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
        child: Row(
          children: List.generate(filters.length, (i) {
            final active = i == selected;
            return Padding(
              padding: EdgeInsets.only(right: i < filters.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? _tintGreen : _cardCream,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? _green.withOpacity(.40) : _separator,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(icons[i], size: 13,
                          color: active ? _greenDark : _labelTertiary),
                      const SizedBox(width: 5),
                      Text(
                        filters[i],
                        style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600,
                            color: active ? _greenDark : _labelTertiary),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SumCard(value: '3', label: 'Pending',   valueColor: _red)),
        const SizedBox(width: 8),
        Expanded(child: _SumCard(value: '8', label: 'Completed', valueColor: _green)),
        const SizedBox(width: 8),
        Expanded(child: _SumCard(value: '1', label: 'Overdue',   valueColor: _orange)),
      ],
    );
  }
}

class _SumCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _SumCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _tintCard(valueColor.withOpacity(.10), radius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
                fontSize: 22, fontWeight: FontWeight.w600,
                color: valueColor, letterSpacing: -0.5, height: 1.1),
          ),
          const SizedBox(height: 3),
          Text(label, style: _caption1()),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final bool showAction;

  const _SectionHeader({required this.label, this.showAction = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: _title2())),
        if (showAction)
          Text('View all', style: _subheadline(color: _blue)),
      ],
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  const _AssignmentCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final a = assignment;
    final isOverdue = a.status == AssignmentStatus.overdue;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardCream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: a.cardBorder ?? _orange.withOpacity(.12),
          width: isOverdue ? 1.0 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1CB0F6).withOpacity(.06),
              blurRadius: 20, offset: const Offset(0, 4)),
          BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 6, offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                    color: a.iconBg,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(a.icon, color: a.iconColor, size: 20),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.title,
                        style: GoogleFonts.inter(
                            fontSize: 13, fontWeight: FontWeight.w600,
                            color: _labelPrimary, letterSpacing: -0.1)),
                    const SizedBox(height: 3),
                    Text('${a.subject} · ${a.teacher}',
                        style: _caption1()),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                    color: a.badgeBg,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(a.badgeLabel,
                    style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w600,
                        color: a.badgeColor)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Divider(color: _separator, height: 0.5, thickness: 0.5),
          ),
          Row(
            children: [
              _Chip(
                icon: Icons.access_time_rounded,
                label: a.timeLabel,
                color: isOverdue ? _red : _labelTertiary,
              ),
              const SizedBox(width: 8),
              _Chip(
                icon: Icons.attach_file_rounded,
                label: a.filesLabel,
              ),
              const Spacer(),
              _SubmitButton(
                label: a.submitLabel,
                color: a.submitColor ?? _green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Chip({
    required this.icon,
    required this.label,
    this.color = _labelTertiary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final String label;
  final Color color;

  const _SubmitButton({required this.label, required this.color});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isSubmitted) return;

        final success = await AssignmentService().submitAssignment(1);

        if (success) {
          setState(() => isSubmitted = true);

          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 900),
              pageBuilder: (_, animation, __) => const SubmissionSuccessPage(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animation, curve: Curves.easeOutBack),
                  ),
                  child: child,
                ),
              ),
            ),
          );
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success ? 'Assignment submitted' : 'Submission failed',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: success ? _green : _red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSubmitted ? _labelTertiary : widget.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSubmitted
              ? []
              : [
                  BoxShadow(
                      color: widget.color.withOpacity(.30),
                      blurRadius: 8, offset: const Offset(0, 3)),
                ],
        ),
        child: Text(
          isSubmitted ? 'Submitted' : widget.label,
          style: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
    );
  }
}

class _CompletedBanner extends StatelessWidget {
  const _CompletedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        color: _tintGreen,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _green.withOpacity(.25), width: 0.5),
        boxShadow: [
          BoxShadow(color: _green.withOpacity(.08),
              blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: _green.withOpacity(.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: _greenDark, size: 26),
          ),
          const SizedBox(height: 8),
          Text('8 assignments done',
              style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: _greenDark)),
          const SizedBox(height: 4),
          Text('Great work this week!', style: _caption1(color: _green)),
        ],
      ),
    );
  }
}