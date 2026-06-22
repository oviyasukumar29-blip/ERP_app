import 'package:flutter/material.dart';
import '../../parent_theme.dart';

class NotificationTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String body;
  final String timeAgo;
  final String category; // 'attendance', 'fees', 'homework', 'progress', 'general'
  final bool isRead;
  final bool last;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationTile({
    super.key,
    required this.emoji,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.category,
    this.isRead = false,
    this.last = false,
    this.onTap,
    this.onDismiss,
  });

  Color get _categoryColor {
    switch (category) {
      case 'attendance':
        return PT.orange;
      case 'fees':
        return PT.red;
      case 'homework':
        return PT.blueDeep;
      case 'progress':
        return PT.green;
      default:
        return PT.purple;
    }
  }

  Color get _categoryTint {
    switch (category) {
      case 'attendance':
        return PT.tintOrange;
      case 'fees':
        return PT.tintRed;
      case 'homework':
        return PT.tintBlue;
      case 'progress':
        return PT.tintGreen;
      default:
        return PT.tintPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('notif_${title}_$timeAgo'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: PT.red.withValues(alpha: .10),
        child: const Icon(Icons.delete_outline_rounded,
            color: PT.red, size: 22),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isRead ? null : _categoryTint.withValues(alpha: .40),
            border: last
                ? null
                : Border(
                    bottom: BorderSide(color: PT.separator, width: 0.5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _categoryTint,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child:
                      Text(emoji, style: const TextStyle(fontSize: 18)),
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
                          child: Text(
                            title,
                            style: PT.subheadline(color: PT.labelPrimary),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _categoryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      body,
                      style: PT.caption1(color: PT.labelTertiary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      timeAgo,
                      style: PT.caption2(color: _categoryColor),
                    ),
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
