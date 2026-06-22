import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

/// Animated bar chart displaying marks for recent tests/exams.
class MarksChart extends StatefulWidget {
  final List<Map<String, dynamic>> marks;
  // Each item: { 'label': 'Mid-Term', 'score': 82, 'max': 100 }

  const MarksChart({super.key, required this.marks});

  @override
  State<MarksChart> createState() => _MarksChartState();
}

class _MarksChartState extends State<MarksChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.marks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: PT.widgetCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Test Scores', style: PT.headline()),
              const Spacer(),
              Text('This term', style: PT.caption1(color: PT.blueDeep)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: widget.marks.map((m) {
                  final score = (m['score'] as num).toDouble();
                  final max = (m['max'] as num? ?? 100).toDouble();
                  final ratio = max > 0 ? (score / max) * _anim.value : 0.0;
                  final barH = ratio * 100;

                  final color = score / max >= 0.75
                      ? PT.green
                      : score / max >= 0.50
                          ? PT.orange
                          : PT.red;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${score.round()}',
                            style: GoogleFonts.fredoka(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedContainer(
                            duration: Duration.zero,
                            height: barH,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            m['label'] as String? ?? '',
                            textAlign: TextAlign.center,
                            style: PT.caption2(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
