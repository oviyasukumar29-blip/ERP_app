// features/parent/presentation/widgets/shared/loading_widget.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';

class ParentLoadingWidget extends StatelessWidget {
  final String? message;

  const ParentLoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: PT.widgetCard,
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: PT.primary,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 10),
              Text(message!, style: PT.caption1(color: PT.labelTertiary)),
            ],
          ],
        ),
      ),
    );
  }
}
