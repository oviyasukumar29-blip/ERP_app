import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

class TrainerTile extends StatelessWidget {
  final String name;
  final String subject;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool last;
  final VoidCallback? onTap;

  const TrainerTile({
    super.key,
    required this.name,
    required this.subject,
    required this.lastMessage,
    required this.timeAgo,
    this.unreadCount = 0,
    this.last = false,
    this.onTap,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  static const _avatarColors = [
    PT.blueDeep,
    PT.purple,
    PT.green,
    PT.orange,
    PT.coral,
  ];

  Color get _avatarColor =>
      _avatarColors[name.codeUnitAt(0) % _avatarColors.length];

  @override
  Widget build(BuildContext context) {
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
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _avatarColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(name,
                            style: PT.subheadline(color: PT.labelPrimary)),
                      ),
                      Text(timeAgo, style: PT.caption2()),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subject,
                    style: PT.caption2(color: PT.blueDeep),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lastMessage,
                    style: PT.caption1(color: PT.labelTertiary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: PT.blueDeep,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$unreadCount',
                    style: GoogleFonts.fredoka(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
