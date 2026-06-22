import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

/// Circular progress ring showing homework completion ratio for the week.
class AssignmentTracker extends StatefulWidget {
  final int completed;
  final int total;
  final String childName;

  const AssignmentTracker({
    super.key,
    required this.completed,
    required this.total,
    required this.childName,
  });

  @override
  State<AssignmentTracker> createState() => _AssignmentTrackerState();
}

class _AssignmentTrackerState extends State<AssignmentTracker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = widget.total == 0 ? 0.0 : widget.completed / widget.total;
    final pct = (ratio * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: PT.widgetCard,
      child: Row(
        children: [
          // Ring
          SizedBox(
            width: 90,
            height: 90,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) => CustomPaint(
                painter: _RingPainter(
                    progress: ratio * _animation.value),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$pct%',
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: PT.blueDeep,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        'done',
                        style: PT.caption2(color: PT.labelTertiary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Homework',
                  style: PT.headline(),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.childName,
                  style: PT.caption1(color: PT.labelTertiary),
                ),
                const SizedBox(height: 14),
                _StatRow(
                    icon: Icons.check_circle_rounded,
                    color: PT.green,
                    label: 'Submitted',
                    value: '${widget.completed}'),
                const SizedBox(height: 6),
                _StatRow(
                    icon: Icons.radio_button_unchecked_rounded,
                    color: PT.orange,
                    label: 'Pending',
                    value: '${widget.total - widget.completed}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Text(label, style: PT.caption1(color: PT.labelSecondary)),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = (size.width - 14) / 2;

    // Track
    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..color = PT.separator
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -3.14159 / 2,
      2 * 3.14159 * progress,
      false,
      Paint()
        ..color = PT.blueDeep
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
