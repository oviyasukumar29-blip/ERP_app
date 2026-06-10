import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleOverviewCard extends StatelessWidget {
  final List<int> classMinutes;

  const ScheduleOverviewCard({
    super.key,
    this.classMinutes = const [80, 120, 60, 150, 90, 45, 30],
  });

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final maxMinutes = classMinutes.reduce((a, b) => a > b ? a : b);
    final todayIndex = DateTime.now().weekday - DateTime.monday;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _D.widgetCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Schedule Overview', style: _D.headline())),
              Text('This week', style: _D.caption1(color: _D.blue)),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(classMinutes.length, (index) {
                final value = classMinutes[index];
                final active = index == todayIndex;
                final height = 28 + (value / maxMinutes) * 72;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(value / 60).toStringAsFixed(value % 60 == 0 ? 0 : 1)}h',
                          style: _D.caption1(
                            color: active ? _D.blue : _D.labelQuaternary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          height: height,
                          decoration: BoxDecoration(
                            color: active
                                ? _D.blue
                                : _D.blue.withValues(alpha: .20),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: _D.blue.withValues(alpha: .25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          _days[index],
                          style: _D.caption1(
                            color: active ? _D.blue : _D.labelQuaternary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _D {
  static const blue = Color(0xFF14A0E0);
  static const bgElevated = Color(0xFFFFFAF4);
  static const labelPrimary = Color(0xFF1C1C1E);
  static const labelTertiary = Color(0xFF8E8E93);
  static const labelQuaternary = Color(0xFFC7C7CC);

  static TextStyle headline({Color? color}) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color ?? labelPrimary,
    letterSpacing: -.24,
  );

  static TextStyle caption1({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: color ?? labelTertiary,
    letterSpacing: .07,
  );

  static BoxDecoration get widgetCard => BoxDecoration(
    color: bgElevated,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .06),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: .03),
        blurRadius: 6,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
