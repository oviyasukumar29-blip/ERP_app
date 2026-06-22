
// features/parent/presentation/widgets/shared/custom_parent_card.dart
import 'package:flutter/material.dart';
import '../../parent_theme.dart';

/// Generic rounded "widget card" container shared by every feature page,
/// matching the Apple-widget look from the student dashboard.
class CustomParentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final VoidCallback? onTap;

  const CustomParentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: decoration ?? PT.widgetCard,
      child: child,
    );

    if (onTap == null) return card;

    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: InkWell(onTap: onTap, child: card),
    );
  }
}