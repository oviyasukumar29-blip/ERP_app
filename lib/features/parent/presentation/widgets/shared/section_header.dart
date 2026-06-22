// features/parent/presentation/widgets/shared/section_header.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.action = '',
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: PT.title3()),
        const Spacer(),
        if (action.isNotEmpty)
          GestureDetector(
            onTap: onActionTap,
            child: Text(action, style: PT.subheadline(color: PT.primary)),
          ),
      ],
    );
  }
}
