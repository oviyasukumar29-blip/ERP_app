// features/student/presentation/pages/coding_playground_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _C {
  static const green = Color(0xFF46A800);
  static const orange = Color(0xFFF59000);
  static const blue = Color(0xFF14A0E0);
  static const purple = Color(0xFFBB6EF0);
  static const bg = Color(0xFFFDF6EC);
  static const card = Color(0xFFFFFAF4);
  static const codeBg = Color(0xFF111A1F);
  static const tintBlue = Color(0xFFEAF8FE);
  static const tintPurple = Color(0xFFF7EEFF);
  static const labelPrimary = Color(0xFF1C1C1E);
  static const labelTertiary = Color(0xFF8E8E93);

  static TextStyle title({Color? color, double size = 20}) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: FontWeight.w700,
    color: color ?? labelPrimary,
    height: 1.2,
  );

  static TextStyle body({Color? color}) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: color ?? labelTertiary,
    height: 1.35,
  );
}

class _CodeLevel {
  final String title;
  final String prompt;
  final String starter;
  final String expectedOutput;
  final int xp;

  const _CodeLevel({
    required this.title,
    required this.prompt,
    required this.starter,
    required this.expectedOutput,
    required this.xp,
  });
}

class CodingPlaygroundPage extends StatefulWidget {
  const CodingPlaygroundPage({super.key});

  @override
  State<CodingPlaygroundPage> createState() => _CodingPlaygroundPageState();
}

class _CodingPlaygroundPageState extends State<CodingPlaygroundPage>
    with SingleTickerProviderStateMixin {
  static const _levels = [
    _CodeLevel(
      title: 'Print Basics',
      prompt: 'Print exactly: Hello Pinesphere',
      starter: 'print("Hello Pinesphere")',
      expectedOutput: 'Hello Pinesphere',
      xp: 10,
    ),
    _CodeLevel(
      title: 'Add Numbers',
      prompt: 'Create a variable score = 40 + 10 and print score.',
      starter: 'score = 40 + 10\nprint(score)',
      expectedOutput: '50',
      xp: 15,
    ),
    _CodeLevel(
      title: 'Join Text',
      prompt: 'Set name = "Arjun" and print: Welcome Arjun',
      starter: 'name = "Arjun"\nprint("Welcome " + name)',
      expectedOutput: 'Welcome Arjun',
      xp: 20,
    ),
    _CodeLevel(
      title: 'Loop Power',
      prompt: 'Print numbers 1, 2, and 3 on separate lines.',
      starter: 'for i in range(1, 4):\n    print(i)',
      expectedOutput: '1\n2\n3',
      xp: 25,
    ),
  ];

  late final AnimationController _danceController;
  final TextEditingController _controller = TextEditingController();

  int _currentLevel = 0;
  int _completedLevels = 0;
  int _xp = 0;
  String _output = 'Run the code to complete this level.';
  bool _celebrating = false;

  _CodeLevel get _level => _levels[_currentLevel];

  @override
  void initState() {
    super.initState();
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _loadLevel(0);
  }

  @override
  void dispose() {
    _danceController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _loadLevel(int index) {
    _currentLevel = index;
    _controller.text = _levels[index].starter;
    _output = 'Run the code to complete this level.';
  }

  Future<void> _runCode() async {
    final result = _simulatePython(_controller.text).trim();
    final expected = _level.expectedOutput.trim();
    final correct = result == expected;

    setState(() {
      _output = result.isEmpty ? 'No output printed.' : result;
      _celebrating = correct;
    });

    if (!correct) return;

    _danceController.forward(from: 0);
    setState(() {
      _completedLevels = (_currentLevel + 1).clamp(0, _levels.length);
      _xp += _level.xp;
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    if (_currentLevel < _levels.length - 1) {
      setState(() {
        _loadLevel(_currentLevel + 1);
        _celebrating = false;
      });
    } else {
      setState(() {
        _output = 'All coding levels complete. Total XP: $_xp';
        _celebrating = false;
      });
    }
  }

  String _simulatePython(String code) {
    final variables = <String, String>{};
    final output = <String>[];
    final lines = code.split('\n');

    for (final originalLine in lines) {
      final line = originalLine.trim();
      if (line.isEmpty) continue;

      final assignment = RegExp(r'^(\w+)\s*=\s*(.+)$').firstMatch(line);
      if (assignment != null && !line.startsWith('print')) {
        variables[assignment.group(1)!] = _evaluate(
          assignment.group(2)!,
          variables,
        );
        continue;
      }

      final loop = RegExp(
        r'^for\s+\w+\s+in\s+range\(1,\s*4\):$',
      ).firstMatch(line);
      if (loop != null && code.contains('print(i)')) {
        output.addAll(['1', '2', '3']);
        continue;
      }

      final print = RegExp(r'^print\((.*)\)$').firstMatch(line);
      if (print != null) {
        output.add(_evaluate(print.group(1)!, variables));
      }
    }

    return output.join('\n');
  }

  String _evaluate(String expression, Map<String, String> variables) {
    var exp = expression.trim();

    if ((exp.startsWith('"') && exp.endsWith('"')) ||
        (exp.startsWith("'") && exp.endsWith("'"))) {
      return exp.substring(1, exp.length - 1);
    }

    if (exp.contains('+')) {
      final parts = exp.split('+').map((part) => part.trim()).toList();
      final numeric = parts.every((part) => int.tryParse(part) != null);
      if (numeric) {
        return parts.map(int.parse).reduce((a, b) => a + b).toString();
      }
      return parts.map((part) => _evaluate(part, variables)).join();
    }

    if (variables.containsKey(exp)) return variables[exp]!;
    return exp;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _completedLevels / _levels.length;

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        elevation: 0,
        foregroundColor: _C.labelPrimary,
        title: Text('Python Playground', style: _C.title()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _StatusBar(
            xp: _xp,
            completed: _completedLevels,
            total: _levels.length,
          ),
          const SizedBox(height: 12),
          _LevelMap(
            currentLevel: _currentLevel,
            completedLevels: _completedLevels,
            celebrating: _celebrating,
            controller: _danceController,
          ),
          const SizedBox(height: 14),
          _ChallengeCard(level: _level, progress: progress),
          const SizedBox(height: 14),
          _EditorCard(controller: _controller, onRun: _runCode),
          const SizedBox(height: 14),
          _OutputCard(
            output: _output,
            success:
                _output.trim() == _level.expectedOutput.trim() ||
                _completedLevels == _levels.length,
          ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final int xp;
  final int completed;
  final int total;

  const _StatusBar({
    required this.xp,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          _MiniBadge(icon: Icons.flag_rounded, label: '$completed/$total'),
          const SizedBox(width: 10),
          _MiniBadge(
            icon: Icons.local_fire_department_rounded,
            label: '$xp XP',
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _C.tintPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('LEVEL PATH', style: _C.body(color: _C.purple)),
          ),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _C.orange, size: 20),
        const SizedBox(width: 5),
        Text(label, style: _C.title(size: 14)),
      ],
    );
  }
}

class _LevelMap extends StatelessWidget {
  final int currentLevel;
  final int completedLevels;
  final bool celebrating;
  final AnimationController controller;

  const _LevelMap({
    required this.currentLevel,
    required this.completedLevels,
    required this.celebrating,
    required this.controller,
  });

  static const _nodeOffsets = [
    Offset(.50, .15),
    Offset(.27, .38),
    Offset(.64, .53),
    Offset(.42, .78),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      decoration: BoxDecoration(
        color: _C.codeBg,
        borderRadius: BorderRadius.circular(26),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final dollOffset = _nodeOffsets[currentLevel];

          return Stack(
            children: [
              Positioned(
                left: 18,
                right: 18,
                top: 18,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _C.orange,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SECTION 1, UNIT ${currentLevel + 1}',
                        style: _C.body(color: Colors.white70),
                      ),
                      Text(
                        'Solve Python programs',
                        style: _C.title(color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                top: 104,
                child: CustomPaint(
                  painter: _PathPainter(
                    offsets: _nodeOffsets,
                    completedLevels: completedLevels,
                  ),
                ),
              ),
              ...List.generate(_nodeOffsets.length, (index) {
                final offset = _nodeOffsets[index];
                final completed = index < completedLevels;
                final active = index == currentLevel;

                return Positioned(
                  left: width * offset.dx - 30,
                  top: 112 + (height - 132) * offset.dy - 30,
                  child: _LevelNode(
                    level: index + 1,
                    completed: completed,
                    active: active,
                  ),
                );
              }),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutBack,
                left: width * dollOffset.dx - 60,
                top: 112 + (height - 132) * dollOffset.dy + 28,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    final jump = celebrating
                        ? -18 * Curves.easeOut.transform(controller.value)
                        : 0.0;
                    return Transform.translate(
                      offset: Offset(0, jump),
                      child: Transform.rotate(
                        angle: celebrating ? .12 - controller.value * .24 : 0,
                        child: child,
                      ),
                    );
                  },
                  child: const _AnimatedDoll(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  final List<Offset> offsets;
  final int completedLevels;

  const _PathPainter({required this.offsets, required this.completedLevels});

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = Colors.white.withOpacity(.10)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final completePaint = Paint()
      ..color = _C.green
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    Offset point(Offset offset) {
      return Offset(size.width * offset.dx, size.height * offset.dy);
    }

    for (var i = 0; i < offsets.length - 1; i++) {
      canvas.drawLine(point(offsets[i]), point(offsets[i + 1]), pathPaint);
      if (i < completedLevels - 1) {
        canvas.drawLine(
          point(offsets[i]),
          point(offsets[i + 1]),
          completePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) {
    return oldDelegate.completedLevels != completedLevels;
  }
}

class _LevelNode extends StatelessWidget {
  final int level;
  final bool completed;
  final bool active;

  const _LevelNode({
    required this.level,
    required this.completed,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = completed
        ? _C.green
        : active
        ? _C.orange
        : _C.purple;

    return AnimatedScale(
      duration: const Duration(milliseconds: 260),
      scale: active ? 1.12 : 1,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.38),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: completed
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 30)
              : Text('$level', style: _C.title(color: Colors.white, size: 22)),
        ),
      ),
    );
  }
}

class _AnimatedDoll extends StatelessWidget {
  const _AnimatedDoll();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 104,
      child: CustomPaint(painter: _DollPainter()),
    );
  }
}

class _DollPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shadow = Paint()..color = Colors.black.withOpacity(.22);
    final purple = Paint()..color = _C.purple;
    final darkPurple = Paint()..color = const Color(0xFF7B42C8);
    final skin = Paint()..color = const Color(0xFFFFC7A8);
    final white = Paint()..color = Colors.white;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .52, h * .92),
        width: w * .45,
        height: h * .12,
      ),
      shadow,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * .37, h * .45, w * .25, h * .44),
        const Radius.circular(12),
      ),
      darkPurple,
    );
    canvas.drawCircle(Offset(w * .50, h * .30), w * .25, skin);
    canvas.drawPath(
      Path()
        ..moveTo(w * .22, h * .24)
        ..quadraticBezierTo(w * .38, h * .02, w * .73, h * .10)
        ..quadraticBezierTo(w * .76, h * .38, w * .54, h * .43)
        ..quadraticBezierTo(w * .34, h * .42, w * .22, h * .24),
      purple,
    );
    canvas.drawCircle(Offset(w * .40, h * .31), 4, white);
    canvas.drawCircle(Offset(w * .58, h * .31), 4, white);
    canvas.drawCircle(
      Offset(w * .42, h * .32),
      2,
      Paint()..color = _C.labelPrimary,
    );
    canvas.drawCircle(
      Offset(w * .60, h * .32),
      2,
      Paint()..color = _C.labelPrimary,
    );
    canvas.drawArc(
      Rect.fromLTWH(w * .42, h * .34, w * .22, h * .12),
      .2,
      2.2,
      false,
      Paint()
        ..color = _C.labelPrimary
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    canvas.drawLine(
      Offset(w * .38, h * .55),
      Offset(w * .18, h * .68),
      Paint()
        ..color = darkPurple.color
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(w * .60, h * .55),
      Offset(w * .80, h * .64),
      Paint()
        ..color = darkPurple.color
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(w * .15, h * .69), 6, skin);
    canvas.drawCircle(Offset(w * .83, h * .65), 6, skin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChallengeCard extends StatelessWidget {
  final _CodeLevel level;
  final double progress;

  const _ChallengeCard({required this.level, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(level.title, style: _C.title())),
              Text('+${level.xp} XP', style: _C.body(color: _C.orange)),
            ],
          ),
          const SizedBox(height: 8),
          Text(level.prompt, style: _C.body(color: _C.labelPrimary)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: _C.tintBlue,
              valueColor: const AlwaysStoppedAnimation(_C.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onRun;

  const _EditorCard({required this.controller, required this.onRun});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _C.tintBlue,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.code_rounded, color: _C.blue),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text('main.py', style: _C.title())),
              ElevatedButton.icon(
                onPressed: onRun,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('RUN'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 260,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _C.codeBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: 13,
                height: 1.45,
              ),
              cursorColor: _C.orange,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutputCard extends StatelessWidget {
  final String output;
  final bool success;

  const _OutputCard({required this.output, required this.success});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.codeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Output', style: _C.title(color: Colors.white)),
              const Spacer(),
              Icon(
                success ? Icons.check_circle_rounded : Icons.terminal_rounded,
                color: success ? Colors.greenAccent : _C.orange,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            output,
            style: GoogleFonts.jetBrainsMono(
              color: success ? Colors.greenAccent : Colors.white70,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: _C.card,
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(.06),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ],
);
