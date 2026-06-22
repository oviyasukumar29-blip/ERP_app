
// features/parent/presentation/widgets/shared/empty_state_widget.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String emoji;
  final String message;

  const EmptyStateWidget({
    super.key,
    this.emoji = '📭',
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: PT.widgetCard,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: PT.subheadline(color: PT.labelTertiary),
            ),
          ],
        ),
      ),
    );
  }
}