import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parent_theme.dart';

/// Horizontal skill bars for soft/competency skills like
/// "Problem Solving", "Communication", "Teamwork" etc.
class SkillChart extends StatefulWidget {
  final List<Map<String, dynamic>> skills;
  // Each: { 'name': 'Problem Solving', 'value': 78 }

  const SkillChart({super.key, required this.skills});

  @override
  State<SkillChart> createState() => _SkillChartState();
}

class _SkillChartState extends State<SkillChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static const _skillColors = [
    PT.blueDeep,
    PT.purple,
    PT.green,
    PT.orange,
    PT.coral,
    PT.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: PT.widgetCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skills & Competencies', style: PT.headline()),
          const SizedBox(height: 16),
          ...List.generate(widget.skills.length, (i) {
            final skill = widget.skills[i];
            final value = (skill['value'] as num).toDouble();
            final color = _skillColors[i % _skillColors.length];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            skill['name'] as String? ?? '',
                            style: PT.subheadline(),
                          ),
                        ),
                        Text(
                          '${(value * _anim.value).round()}%',
                          style: GoogleFonts.fredoka(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: (value / 100) * _anim.value,
                        minHeight: 8,
                        backgroundColor: PT.separator,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
