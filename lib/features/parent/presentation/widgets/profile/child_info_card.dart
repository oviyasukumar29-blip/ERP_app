import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

class ChildInfoCard extends StatelessWidget {
  final String name;
  final String grade;
  final String section;
  final String rollNumber;
  final String dateOfBirth;
  final String bloodGroup;

  const ChildInfoCard({
    super.key,
    required this.name,
    required this.grade,
    required this.section,
    required this.rollNumber,
    required this.dateOfBirth,
    required this.bloodGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: PT.widgetCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: PT.tintBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: PT.blueDeep.withValues(alpha: .20), width: 2),
                ),
                child: const Center(
                  child: Text('👧', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: PT.headline()),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: PT.tintBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Grade $grade – Section $section',
                        style: GoogleFonts.fredoka(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: PT.blueDeep,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: PT.separator, height: 1),
          const SizedBox(height: 14),
          _InfoRow(label: 'Roll Number', value: rollNumber),
          const SizedBox(height: 10),
          _InfoRow(label: 'Date of Birth', value: dateOfBirth),
          const SizedBox(height: 10),
          _InfoRow(label: 'Blood Group', value: bloodGroup,
              valueColor: PT.red),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: PT.caption1(color: PT.labelTertiary))),
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? PT.labelPrimary,
          ),
        ),
      ],
    );
  }
}
