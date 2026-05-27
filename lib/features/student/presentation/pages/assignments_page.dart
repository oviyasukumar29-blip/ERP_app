// features/student/presentation/pages/assignments_page.dart

import 'package:flutter/material.dart';

// ─── Palette ────────────────────────────────────────────────────────────────
const _bg = Color(0xFFF7F8F5);
const _white = Color(0xFFFFFFFF);
const _border = Color(0xFFE8E8E8);
const _green = Color(0xFF45960A);
const _greenLight = Color(0xFFEAF3DE);
const _greenMid = Color(0xFFC0DD97);
const _greenDark = Color(0xFF27500A);
const _greenDeep = Color(0xFF3B6D11);
const _greenFaint = Color(0xFFF0FAE8);
const _red = Color(0xFFE24B4A);
const _redLight = Color(0xFFFCEBEB);
const _redDark = Color(0xFF791F1F);
const _orange = Color(0xFFEF9F27);
const _orangeLight = Color(0xFFFAEEDA);
const _orangeDark = Color(0xFF633806);
const _purple = Color(0xFF3C3489);
const _purpleLight = Color(0xFFEEEDFE);
const _blue = Color(0xFF0C447C);
const _blueLight = Color(0xFFE6F1FB);
const _text = Color(0xFF111111);
const _subText = Color(0xFF888888);

// ─── Data models ────────────────────────────────────────────────────────────
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
    badgeBg: _redLight,
    badgeColor: _redDark,
    iconBg: _purpleLight,
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
    badgeBg: _orangeLight,
    badgeColor: _orangeDark,
    iconBg: _blueLight,
    iconColor: _blue,
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
    badgeBg: _greenLight,
    badgeColor: _greenDark,
    iconBg: _greenLight,
    iconColor: _greenDark,
    icon: Icons.edit_outlined,
    timeLabel: 'Fri, 30 May',
    filesLabel: 'No files',
    status: AssignmentStatus.pending,
  ),
];

final _overdueAssignments = [
  const Assignment(
    title: 'Chemistry lab report',
    subject: 'Chemistry',
    teacher: 'Mrs. Priya',
    badgeLabel: 'Overdue',
    badgeBg: _redLight,
    badgeColor: _redDark,
    iconBg: _redLight,
    iconColor: _redDark,
    icon: Icons.biotech_outlined,
    timeLabel: 'Was Mon',
    filesLabel: '2 files',
    status: AssignmentStatus.overdue,
    cardBorder: Color(0xFFF09595),
    submitColor: _red,
    submitLabel: 'Submit now',
  ),
];

// ─── Page ────────────────────────────────────────────────────────────────────
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
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            _FilterRow(
              filters: _filters,
              icons: _filterIcons,
              selected: _selectedFilter,
              onSelect: (i) => setState(() => _selectedFilter = i),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 30),
                children: [
                  _SummaryRow(),
                  const SizedBox(height: 14),
                  _SectionHeader(label: 'Pending'),
                  const SizedBox(height: 10),
                  ..._pendingAssignments.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _AssignmentCard(assignment: a),
                      )),
                  const SizedBox(height: 4),
                  _SectionHeader(label: 'Overdue'),
                  const SizedBox(height: 10),
                  ..._overdueAssignments.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _AssignmentCard(assignment: a),
                      )),
                  const SizedBox(height: 4),
                  _SectionHeader(label: 'Completed', showAction: true),
                  const SizedBox(height: 10),
                  _CompletedBanner(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top bar ─────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track your work',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _subText,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Assignments',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _text,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _greenFaint,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _greenMid),
            ),
            child: const Icon(Icons.tune_rounded, color: _green, size: 20),
          ),
        ],
      ),
    );
  }
}

// ─── Filter chips ─────────────────────────────────────────────────────────────
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
    return Container(
      color: _white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
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
                    color: active ? _greenLight : _white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? const Color(0xFF97C459) : _border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icons[i],
                        size: 13,
                        color: active ? _greenDark : _subText,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        filters[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: active ? _greenDark : _subText,
                        ),
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

// ─── Summary row ──────────────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SumCard(value: '3', label: 'Pending', valueColor: _red)),
        const SizedBox(width: 8),
        Expanded(child: _SumCard(value: '8', label: 'Completed', valueColor: _green)),
        const SizedBox(width: 8),
        Expanded(child: _SumCard(value: '1', label: 'Overdue', valueColor: _orange)),
      ],
    );
  }
}

class _SumCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _SumCard({required this.value, required this.label, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: valueColor,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: _subText,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final bool showAction;

  const _SectionHeader({required this.label, this.showAction = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: _text,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (showAction)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _greenFaint,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'View all',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _green,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Assignment card ──────────────────────────────────────────────────────────
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
        color: _white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: a.cardBorder ?? _border,
          width: isOverdue ? 1.0 : 0.5,
        ),
      ),
      child: Column(
        children: [
          // Top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: a.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(a.icon, color: a.iconColor, size: 20),
              ),
              const SizedBox(width: 11),
              // Title + sub
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _text,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${a.subject} · ${a.teacher}',
                      style: const TextStyle(fontSize: 11, color: _subText),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: a.badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  a.badgeLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: a.badgeColor,
                  ),
                ),
              ),
            ],
          ),
          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 11),
            child: Divider(color: _border, height: 0.5, thickness: 0.5),
          ),
          // Footer row
          Row(
            children: [
              _Chip(
                icon: Icons.access_time_rounded,
                label: a.timeLabel,
                color: isOverdue ? _red : _subText,
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
    this.color = _subText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final String label;
  final Color color;

  const _SubmitButton({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _white,
          ),
        ),
      ),
    );
  }
}

// ─── Completed banner ─────────────────────────────────────────────────────────
class _CompletedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        color: _greenFaint,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _greenMid, width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: _greenLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: _greenDark,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '8 assignments done',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _greenDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Great work this week!',
            style: TextStyle(
              fontSize: 11,
              color: _greenDeep,
            ),
          ),
        ],
      ),
    );
  }
}