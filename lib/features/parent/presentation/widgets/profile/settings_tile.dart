import 'package:flutter/material.dart';
import '../../parent_theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool last;
  final bool showArrow;
  final bool isDestructive;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    this.subtitle,
    this.trailing,
    this.last = false,
    this.showArrow = true,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? PT.red : PT.labelPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: last
          ? const BorderRadius.vertical(bottom: Radius.circular(36))
          : BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(
                  bottom: BorderSide(color: PT.separator, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDestructive ? PT.tintRed : iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isDestructive ? PT.red : iconColor,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: PT.subheadline(color: titleColor)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(subtitle!, style: PT.caption2()),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (showArrow && trailing == null)
              const Icon(Icons.chevron_right_rounded,
                  size: 18, color: PT.labelQuaternary),
          ],
        ),
      ),
    );
  }
}
