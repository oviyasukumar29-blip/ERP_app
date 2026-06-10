import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coding_challenge_page.dart' as challenge;

class CodingLevel {
  final int level;
  final String title;
  final String topic;
  final String prompt;
  final String starter;
  final String expectedOutput;
  final int xp;
  final bool unlocked;
  final bool completed;

  CodingLevel({
    required this.level,
    required this.title,
    required this.topic,
    required this.prompt,
    required this.starter,
    required this.expectedOutput,
    required this.xp,
    required this.unlocked,
    required this.completed,
  });
}

class CodingLevelsPage extends StatefulWidget {
  const CodingLevelsPage({super.key});

  @override
  State<CodingLevelsPage> createState() => _CodingLevelsPageState();
}

class _CodingLevelsPageState extends State<CodingLevelsPage>
    with SingleTickerProviderStateMixin {
  static const _storageCurrentLevel = 'coding_current_level';
  static const _storageCompleted = 'coding_level_completed';
  static const _storageStars = 'coding_stars_earned';
  static const _storageXp = 'coding_xp';

  int _currentLevel = 1;
  int _completedLevels = 0;
  int _starsEarned = 0;
  int _xp = 0;
  bool _loading = true;
  late final AnimationController _pageAnimation;

  final List<_LevelDefinition> _baseLevels = const [
    _LevelDefinition(
      level: 1,
      title: 'Variables',
      topic: 'Create and print values',
      prompt: 'Create a variable called score and set it to 10. Print score.',
      starter: 'score = 10\nprint(score)',
      expectedOutput: '10',
      xp: 10,
    ),
    _LevelDefinition(
      level: 2,
      title: 'Data Types',
      topic: 'Mix numbers and text',
      prompt: 'Create a text greeting and print: Hello Pinesphere',
      starter: 'name = "Pinesphere"\nprint("Hello " + name)',
      expectedOutput: 'Hello Pinesphere',
      xp: 12,
    ),
    _LevelDefinition(
      level: 3,
      title: 'Conditions',
      topic: 'Choose the right answer',
      prompt: 'Set x = 5 and print Yes if x > 3 otherwise print No.',
      starter: 'x = 5\nif x > 3:\n    print("Yes")\nelse:\n    print("No")',
      expectedOutput: 'Yes',
      xp: 14,
    ),
    _LevelDefinition(
      level: 4,
      title: 'Operators',
      topic: 'Calculate with + and -',
      prompt: 'Set result = 7 + 3 and print result.',
      starter: 'result = 7 + 3\nprint(result)',
      expectedOutput: '10',
      xp: 16,
    ),
    _LevelDefinition(
      level: 5,
      title: 'Loops',
      topic: 'Repeat actions',
      prompt: 'Print numbers 1, 2, 3 each on a new line.',
      starter: 'for i in range(1, 4):\n    print(i)',
      expectedOutput: '1\n2\n3',
      xp: 18,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLevel = prefs.getInt(_storageCurrentLevel) ?? 1;
      _completedLevels = prefs.getInt(_storageCompleted) ?? 0;
      _starsEarned = prefs.getInt(_storageStars) ?? _completedLevels;
      _xp = prefs.getInt(_storageXp) ?? 0;
      _loading = false;
    });
    await Future<void>.delayed(const Duration(milliseconds: 60));
    if (mounted) _pageAnimation.forward();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storageCurrentLevel, _currentLevel);
    await prefs.setInt(_storageCompleted, _completedLevels);
    await prefs.setInt(_storageStars, _starsEarned);
    await prefs.setInt(_storageXp, _xp);
  }

  List<CodingLevel> get _levels {
    return _baseLevels.map((base) {
      final unlocked = base.level <= _currentLevel;
      final completed = base.level <= _completedLevels;
      return CodingLevel(
        level: base.level,
        title: base.title,
        topic: base.topic,
        prompt: base.prompt,
        starter: base.starter,
        expectedOutput: base.expectedOutput,
        xp: base.xp,
        unlocked: unlocked,
        completed: completed,
      );
    }).toList();
  }

  void _openLevel(CodingLevel level) {
    if (!level.unlocked) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => challenge.CodingChallengePage(
          level: level,
          onCompleted: _onLevelCompleted,
        ),
      ),
    );
  }

  Future<void> _onLevelCompleted(CodingLevel level) async {
    final nextLevel = (level.level + 1).clamp(1, _baseLevels.length + 1);
    final completedLevels =
        level.level > _completedLevels ? level.level : _completedLevels;
    setState(() {
      _completedLevels = completedLevels;
      _currentLevel = nextLevel;
      _starsEarned = completedLevels;
      _xp = _baseLevels
          .take(completedLevels)
          .fold<int>(0, (sum, item) => sum + item.xp);
    });
    await _saveProgress();
  }

  @override
  void dispose() {
    _pageAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _DL.bgTop,
      body: Stack(
        children: [
          // Duolingo-style two-tone background
          Column(
            children: [
              Expanded(flex: 2, child: Container(color: _DL.bgTop)),
              Expanded(flex: 5, child: Container(color: _DL.bgBottom)),
            ],
          ),
          SafeArea(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: _DL.green))
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _TopHeader(
                          stars: _starsEarned,
                          xp: _xp,
                          completedLevels: _completedLevels,
                          totalLevels: _baseLevels.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _UnitBanner(
                          completedLevels: _completedLevels,
                          totalLevels: _baseLevels.length,
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverToBoxAdapter(
                          child: _LevelPath(
                            levels: _levels,
                            onTap: _openLevel,
                            animation: _pageAnimation,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _BottomTrophyCard(
                          animation: _pageAnimation,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── TOP HEADER (streak / xp / hearts) ──────────────────────────────────────

class _TopHeader extends StatelessWidget {
  final int stars;
  final int xp;
  final int completedLevels;
  final int totalLevels;

  const _TopHeader({
    required this.stars,
    required this.xp,
    required this.completedLevels,
    required this.totalLevels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _DL.bgTop,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: Row(
        children: [
          _IconStat(
            icon: Icons.local_fire_department_rounded,
            color: _DL.orange,
            value: '$stars',
          ),
          const SizedBox(width: 18),
          _IconStat(
            icon: Icons.bolt_rounded,
            color: _DL.yellow,
            value: '$xp XP',
          ),
          const Spacer(),
          _IconStat(
            icon: Icons.favorite_rounded,
            color: _DL.red,
            value: '${5 - (completedLevels ~/ 2).clamp(0, 4)}',
          ),
        ],
      ),
    );
  }
}

class _IconStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;

  const _IconStat({required this.icon, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 5),
        Text(value,
            style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
      ],
    );
  }
}

// ─── UNIT BANNER ─────────────────────────────────────────────────────────────

class _UnitBanner extends StatelessWidget {
  final int completedLevels;
  final int totalLevels;

  const _UnitBanner(
      {required this.completedLevels, required this.totalLevels});

  @override
  Widget build(BuildContext context) {
    final progress = completedLevels / totalLevels;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _DL.green,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _DL.green.withValues(alpha: 0.5),
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'SECTION 1',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.menu_book_rounded,
                  color: Colors.white70, size: 22),
            ],
          ),
          const SizedBox(height: 10),
          Text('Python Basics',
              style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text('Variables, types, loops and more',
              style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text('$completedLevels / $totalLevels levels complete',
              style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70)),
        ],
      ),
    );
  }
}

// ─── LEVEL PATH ──────────────────────────────────────────────────────────────

class _LevelPath extends StatelessWidget {
  final List<CodingLevel> levels;
  final ValueChanged<CodingLevel> onTap;
  final Animation<double> animation;

  const _LevelPath(
      {required this.levels, required this.onTap, required this.animation});

  // Duolingo-style zigzag offsets (left → center → right → center → left)
  static const List<_NodePos> _positions = [
    _NodePos(alignment: _Align.center, isFirst: true),
    _NodePos(alignment: _Align.right),
    _NodePos(alignment: _Align.center, isMidBonusAbove: true),
    _NodePos(alignment: _Align.left),
    _NodePos(alignment: _Align.center),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < levels.length; i++) ...[
          if (i == 2) ...[
            _AnimatedEntry(
              animation: animation,
              index: i * 2,
              child: const _MascotRow(),
            ),
            const SizedBox(height: 4),
          ],
          _AnimatedEntry(
            animation: animation,
            index: i * 2 + 1,
            child: _NodeRow(
              level: levels[i],
              position: _positions[i],
              onTap: onTap,
            ),
          ),
          if (i < levels.length - 1)
            _ConnectorLine(
              fromAlign: _positions[i].alignment,
              toAlign: _positions[i + 1].alignment,
              bothCompleted: levels[i].completed && levels[i + 1].completed,
            ),
        ],
      ],
    );
  }
}

class _NodeRow extends StatelessWidget {
  final CodingLevel level;
  final _NodePos position;
  final ValueChanged<CodingLevel> onTap;

  const _NodeRow(
      {required this.level, required this.position, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget node = _LevelNode(level: level, onTap: onTap);
    switch (position.alignment) {
      case _Align.left:
        return Row(children: [node, const Spacer(), const Spacer()]);
      case _Align.right:
        return Row(children: [const Spacer(), const Spacer(), node]);
      case _Align.center:
        return Row(
            mainAxisAlignment: MainAxisAlignment.center, children: [node]);
    }
  }
}

// ─── CONNECTOR LINE ──────────────────────────────────────────────────────────

class _ConnectorLine extends StatelessWidget {
  final _Align fromAlign;
  final _Align toAlign;
  final bool bothCompleted;

  const _ConnectorLine(
      {required this.fromAlign,
      required this.toAlign,
      required this.bothCompleted});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: CustomPaint(
        painter:
            _ConnectorPainter(from: fromAlign, to: toAlign, filled: bothCompleted),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ConnectorPainter extends CustomPainter {
  final _Align from;
  final _Align to;
  final bool filled;

  _ConnectorPainter({required this.from, required this.to, required this.filled});

  double _xForAlign(_Align a, double w) {
    switch (a) {
      case _Align.left:
        return w * 0.18;
      case _Align.center:
        return w * 0.5;
      case _Align.right:
        return w * 0.82;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final color = filled ? _DL.green : _DL.trackGrey;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // Draw dashed connector
    final startX = _xForAlign(from, size.width);
    final endX = _xForAlign(to, size.width);
    final path = Path();
    path.moveTo(startX, 0);
    path.cubicTo(
        startX, size.height * 0.4, endX, size.height * 0.6, endX, size.height);

    // Dashed effect using path metrics
    final dashWidth = 8.0;
    final dashSpace = 6.0;
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectorPainter old) =>
      old.filled != filled || old.from != from || old.to != to;
}

// ─── LEVEL NODE ──────────────────────────────────────────────────────────────

class _LevelNode extends StatelessWidget {
  final CodingLevel level;
  final ValueChanged<CodingLevel> onTap;

  const _LevelNode({required this.level, required this.onTap});

  Color get _nodeColor {
    if (level.completed) return const Color(0xFFFFD93D);
    if (level.unlocked) return _DL.blue;
    return _DL.locked;
  }

  Color get _shadowColor {
    if (level.completed) return const Color(0xFFFFB700);
    if (level.unlocked) return const Color(0xFF0090D4);
    return const Color(0xFF4A4A4A);
  }

  bool get _isActive => level.unlocked && !level.completed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: level.unlocked ? () => onTap(level) : null,
      child: Column(
        children: [
          // Tooltip chip above active node
          if (_isActive)
            _ActiveChip(title: level.title)
          else
            const SizedBox(height: 28),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.9, end: _isActive ? 1.0 : 0.95),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Glow ring for active node
                if (_isActive)
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _DL.blue.withValues(alpha: 0.2),
                    ),
                  ),
                // Main circle
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _nodeColor,
                    boxShadow: [
                      BoxShadow(
                        color: _shadowColor,
                        blurRadius: 0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(child: _nodeIcon()),
                ),
                // Star badge for completed
                if (level.completed)
                  Positioned(
                    bottom: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _DL.yellow,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: _DL.bgBottom, width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: _DL.yellow.withValues(alpha: 0.4),
                              blurRadius: 6)
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 2),
                          Text('${level.xp} XP',
                              style: GoogleFonts.nunito(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _nodeIcon() {
    if (level.completed) {
      return Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 36),
          Text(
            '${level.level}',
            style: GoogleFonts.fredoka(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      );
    }
    if (level.unlocked) {
      return Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 32),
          Text(
            '${level.level}',
            style: GoogleFonts.fredoka(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2D6BFF),
            ),
          ),
        ],
      );
    }
    return const Icon(Icons.lock_rounded, color: Colors.white54, size: 28);
  }
}

class _ActiveChip extends StatefulWidget {
  final String title;
  const _ActiveChip({required this.title});

  @override
  State<_ActiveChip> createState() => _ActiveChipState();
}

class _ActiveChipState extends State<_ActiveChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _bounce = Tween(begin: 0.0, end: -6.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounce.value),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: _DL.blue,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0090D4),
              blurRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          widget.title.toUpperCase(),
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ─── MASCOT ROW ──────────────────────────────────────────────────────────────

class _MascotRow extends StatefulWidget {
  const _MascotRow();

  @override
  State<_MascotRow> createState() => _MascotRowState();
}

class _MascotRowState extends State<_MascotRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          final dy = Tween(begin: 0.0, end: -10.0)
              .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut))
              .value;
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: Image.asset(
          'assets/images/coding_mascot.png',
          height: 110,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Text('👾',
              style: TextStyle(fontSize: 64)),
        ),
      ),
    );
  }
}

// ─── BOTTOM TROPHY CARD ──────────────────────────────────────────────────────

class _BottomTrophyCard extends StatelessWidget {
  final Animation<double> animation;

  const _BottomTrophyCard({required this.animation});

  @override
  Widget build(BuildContext context) {
    return _AnimatedEntry(
      animation: animation,
      index: 12,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _DL.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _DL.cardBorder, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _DL.yellow.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.emoji_events_rounded,
                  color: _DL.yellow, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bonus Challenge',
                      style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: _DL.textPrimary)),
                  const SizedBox(height: 4),
                  Text('Earn all stars to unlock the final boss level!',
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _DL.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ANIMATED ENTRY ──────────────────────────────────────────────────────────

class _AnimatedEntry extends StatelessWidget {
  final Animation<double> animation;
  final int index;
  final Widget child;

  const _AnimatedEntry(
      {required this.animation, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(
        (index * 0.07).clamp(0.0, 0.85),
        ((index * 0.07) + 0.45).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                .animate(curved),
        child: child,
      ),
    );
  }
}

// ─── ENUMS / HELPERS ─────────────────────────────────────────────────────────

enum _Align { left, center, right }

class _NodePos {
  final _Align alignment;
  final bool isFirst;
  final bool isMidBonusAbove;

  const _NodePos({
    required this.alignment,
    this.isFirst = false,
    this.isMidBonusAbove = false,
  });
}

// ─── DESIGN TOKENS ───────────────────────────────────────────────────────────

class _DL {
  // Duolingo palette
  static const Color green = Color(0xFF58CC02);
  static const Color blue = Color(0xFF1CB0F6);
  static const Color yellow = Color(0xFFFFD900);
  static const Color orange = Color(0xFFFF9600);
  static const Color red = Color(0xFFFF4B4B);

  // Backgrounds
  static const Color bgTop = Color(0xFF235390);
  static const Color bgBottom = Color(0xFF1A3D6E);

  // Track
  static const Color trackGrey = Color(0xFF3A5E8C);
  static const Color locked = Color(0xFF8094A8);

  // Cards
  static const Color cardBg = Color(0xFF1F4A82);
  static const Color cardBorder = Color(0xFF2A5C9A);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFADC8E6);
}

// ─── MODEL ───────────────────────────────────────────────────────────────────

class _LevelDefinition {
  final int level;
  final String title;
  final String topic;
  final String prompt;
  final String starter;
  final String expectedOutput;
  final int xp;

  const _LevelDefinition({
    required this.level,
    required this.title,
    required this.topic,
    required this.prompt,
    required this.starter,
    required this.expectedOutput,
    required this.xp,
  });
}