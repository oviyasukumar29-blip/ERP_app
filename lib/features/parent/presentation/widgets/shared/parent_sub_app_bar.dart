// features/parent/presentation/widgets/shared/parent_sub_app_bar.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';

/// Simple header for parent sub-pages reached via Navigator.push
/// (Communication, Homework, Notifications, Progress, etc.).
/// Distinct from ParentAppBar, which is the root-tab bar with the
/// multi-child switcher — this one just shows a title/subtitle,
/// optional back button, and an optional trailing action.
class ParentSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final Widget? trailing;

  const ParentSubAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.trailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: PT.bgElevated,
      child: Row(
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: PT.labelSecondary,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: PT.headline()),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(subtitle!, style: PT.caption1(color: PT.labelTertiary)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}