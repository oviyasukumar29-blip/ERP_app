import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

class HomeworkTile extends StatelessWidget {
  final String subject;
  final String title;
  final String dueDate;
  final String status; // 'submitted', 'pending', 'missed', 'upcoming'
  final String childName;
  final bool last;
  final VoidCallback? onTap;

  const HomeworkTile({
    super.key,
    required this.subject,
    required this.title,
    required this.dueDate,
    required this.status,
    required this.childName,
    this.last = false,
    this.onTap,
  });

  static const _subjectEmoji = {
    'math': '🔢',
    'mathematics': '🔢',
    'science': '🔬',
    'english': '📖',
    'history': '🏛️',
    'geography': '🌍',
    'physics': '⚡',
    'chemistry': '🧪',
    'biology': '🌿',
    'computer': '💻',
    'art': '🎨',
    'music': '🎵',
    'physical': '⚽',
  };

  String get _emoji {
    final key = subject.toLowerCase();
    for (final e in _subjectEmoji.entries) {
      if (key.contains(e.key)) return e.value;
    }
    return '📝';
  }

  @override
  Widget build(BuildContext context) {
    final color = PT.statusColor(status);
    final tint = PT.statusTint(status);

    return InkWell(
      onTap: onTap,
      borderRadius: last
          ? const BorderRadius.vertical(bottom: Radius.circular(36))
          : BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(
                  bottom: BorderSide(color: PT.separator, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(_emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: PT.caption1(color: PT.labelTertiary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: PT.subheadline(color: PT.labelPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 11, color: PT.labelTertiary),
                      const SizedBox(width: 3),
                      Text(dueDate, style: PT.caption2(color: PT.labelTertiary)),
                      const SizedBox(width: 8),
                      Text('· $childName',
                          style: PT.caption2(color: PT.labelQuaternary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _capitalize(status),
                style: GoogleFonts.fredoka(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
