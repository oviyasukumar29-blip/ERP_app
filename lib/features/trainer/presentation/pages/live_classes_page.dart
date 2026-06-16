import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/live_classes_service.dart';

class TrainerLiveClassesPage extends StatefulWidget {
  const TrainerLiveClassesPage({super.key});

  @override
  State<TrainerLiveClassesPage> createState() => _TrainerLiveClassesPageState();
}

class _TrainerLiveClassesPageState extends State<TrainerLiveClassesPage> {
  String? _activeClassId;
  bool _isHosting = false;
  String _meetingLink = 'https://pinesphere.live/orbt-d92';
  bool _isLoading = true;
  String? _errorMessage;

  final _liveClassesService = LiveClassesService();
  List<LiveClass> _classes = [];

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final classes = await _liveClassesService.fetchLiveClasses();
      setState(() {
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load classes. Tap to retry.';
        _isLoading = false;
      });
    }
  }

  Future<void> _startHosting(String classId) async {
    final result = await _liveClassesService.hostLiveClass(classId);
    setState(() {
      _activeClassId = classId;
      _isHosting = true;
      if (result?.meetingLink != null) {
        _meetingLink = result!.meetingLink!;
      } else {
        _meetingLink = 'https://pinesphere.live/orbt-${classId.substring(0, 6)}';
      }
    });
    await _fetchClasses();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Live class started!'),
          backgroundColor: const Color(0xFF58CC02),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _stopHosting() {
    setState(() {
      _isHosting = false;
      _activeClassId = null;
    });
  }

  void _copyMeetingLink() {
    Clipboard.setData(ClipboardData(text: _meetingLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link copied!',
            style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        backgroundColor: const Color(0xFF58CC02),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _openScheduleDialog(LiveClass cls) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;

    TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (pickedStartTime == null) return;

    TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (pickedEndTime == null) return;

    final startTime = DateTime(pickedDate.year, pickedDate.month,
        pickedDate.day, pickedStartTime.hour, pickedStartTime.minute);
    final endTime = DateTime(pickedDate.year, pickedDate.month,
        pickedDate.day, pickedEndTime.hour, pickedEndTime.minute);

    final result = await _liveClassesService.scheduleLiveClass(
        cls.id, startTime, endTime);

    if (result != null) {
      await _fetchClasses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Session scheduled!',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
            backgroundColor: const Color(0xFF58CC02),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to schedule. Try again.',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
            backgroundColor: const Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  // ── NEW: CREATE DIALOG ──────────────────────────────────────
  Future<void> _openCreateDialog() async {
    final titleController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Create Live Class',
            style: GoogleFonts.nunito(
                fontSize: 17, fontWeight: FontWeight.w800)),
        content: TextField(
          controller: titleController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'e.g. Mathematics – Chapter 5',
            hintStyle: GoogleFonts.nunito(color: const Color(0xFF8E8E93)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1CB0F6), width: 2),
            ),
          ),
          style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: GoogleFonts.nunito(color: const Color(0xFF8E8E93))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1CB0F6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Create',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a class title.',
              style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
          backgroundColor: const Color(0xFFFF4B4B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await _liveClassesService.createLiveClass(title);

    if (result != null) {
      await _fetchClasses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Class created! Tap "Host Now" to go live.',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
            backgroundColor: const Color(0xFF58CC02),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create class. Try again.',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
            backgroundColor: const Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6EC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1C1C1E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Live Classes',
            style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1C1C1E))),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: Color(0xFF8E8E93), size: 22),
            onPressed: _fetchClasses,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF58CC02)))
          : _errorMessage != null
              ? _buildErrorState()
              : _buildBody(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: GestureDetector(
        onTap: _fetchClasses,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                color: Color(0xFF8E8E93), size: 48),
            const SizedBox(height: 12),
            Text(_errorMessage!,
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: const Color(0xFF8E8E93),
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        _BroadcastCard(
          isHosting: _isHosting,
          meetingLink: _meetingLink,
          onCopy: _copyMeetingLink,
          onStop: _stopHosting,
        ),
        const SizedBox(height: 20),
        _LightButton(
          icon: Icons.add_circle_outline_rounded,
          label: 'Create Live Class',
          color: const Color(0xFF1CB0F6),
          onTap: _openCreateDialog, // ← WIRED UP
        ),
        const SizedBox(height: 10),
        _LightButton(
          icon: Icons.description_outlined,
          label: 'Create Draft',
          color: const Color(0xFF8E8E93),
          outlined: true,
          onTap: () {},
        ),
        const SizedBox(height: 24),
        Row(children: [
          Text('Upcoming Classes',
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1C1C1E))),
          const Spacer(),
          GestureDetector(
            onTap: _fetchClasses,
            child: Text('REFRESH',
                style: GoogleFonts.nunito(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1CB0F6),
                    letterSpacing: 0.5)),
          ),
        ]),
        const SizedBox(height: 14),
        if (_classes.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text('No classes yet. Create one above!',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93),
                      fontWeight: FontWeight.w600)),
            ),
          )
        else
          ..._classes.map((cls) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ClassCard(
                  cls: cls,
                  isActive: cls.id == _activeClassId,
                  onHost: () => _startHosting(cls.id),
                  onSchedule: () => _openScheduleDialog(cls),
                  onCopyLink: _copyMeetingLink,
                ),
              )),
      ],
    );
  }
}

// ── BROADCAST CARD ────────────────────────────────────────────

class _BroadcastCard extends StatelessWidget {
  final bool isHosting;
  final String meetingLink;
  final VoidCallback onCopy;
  final VoidCallback onStop;

  const _BroadcastCard({
    required this.isHosting,
    required this.meetingLink,
    required this.onCopy,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHosting
              ? const Color(0xFFFF4B4B).withValues(alpha: 0.4)
              : const Color(0xFFE5E5EA),
          width: isHosting ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (isHosting)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4B4B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFFF4B4B).withValues(alpha: 0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                      color: Color(0xFFFF4B4B), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('LIVE SESSION ACTIVE',
                  style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFF4B4B),
                      letterSpacing: 0.8)),
            ]),
          ),
        if (isHosting) const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            const Icon(Icons.link_rounded, color: Color(0xFF8E8E93), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(meetingLink,
                  style: GoogleFonts.robotoMono(
                      fontSize: 11, color: const Color(0xFF1C1C1E))),
            ),
            GestureDetector(
              onTap: onCopy,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1CB0F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Copy',
                    style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1CB0F6))),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: isHosting ? onStop : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: isHosting
                  ? const Color(0xFFFF4B4B).withValues(alpha: 0.08)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isHosting
                    ? const Color(0xFFFF4B4B).withValues(alpha: 0.4)
                    : const Color(0xFFE5E5EA),
              ),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                isHosting
                    ? Icons.stop_circle_outlined
                    : Icons.radio_button_checked_rounded,
                color: isHosting
                    ? const Color(0xFFFF4B4B)
                    : const Color(0xFF8E8E93),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isHosting ? 'STOP BROADCAST' : 'NOT BROADCASTING',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isHosting
                      ? const Color(0xFFFF4B4B)
                      : const Color(0xFF8E8E93),
                  letterSpacing: 0.5,
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── LIGHT BUTTON ─────────────────────────────────────────────

class _LightButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool outlined;
  final VoidCallback onTap;

  const _LightButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: outlined ? Colors.white : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: outlined
                  ? const Color(0xFFE5E5EA)
                  : color.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: outlined ? const Color(0xFF8E8E93) : color, size: 18),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: outlined ? const Color(0xFF8E8E93) : color)),
        ]),
      ),
    );
  }
}

// ── CLASS CARD ────────────────────────────────────────────────

class _ClassCard extends StatelessWidget {
  final LiveClass cls;
  final bool isActive;
  final VoidCallback onHost;
  final VoidCallback onSchedule;
  final VoidCallback onCopyLink;

  const _ClassCard({
    required this.cls,
    required this.isActive,
    required this.onHost,
    required this.onSchedule,
    required this.onCopyLink,
  });

  String _emojiForSubject(String subject) {
    final s = subject.toLowerCase();
    if (s.contains('math')) return '📐';
    if (s.contains('physics') || s.contains('quantum')) return '⚗️';
    if (s.contains('english') || s.contains('literature')) return '📖';
    if (s.contains('chemistry')) return '🧪';
    if (s.contains('biology')) return '🧬';
    if (s.contains('computer') || s.contains('code')) return '💻';
    if (s.contains('python') || s.contains('stack')) return '🐍';
    return '📚';
  }

  String _formatTime(String? isoTime) {
    if (isoTime == null) return 'Time TBD';
    try {
      final dt = DateTime.parse(isoTime).toLocal();
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $ampm';
    } catch (_) {
      return 'Time TBD';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLive = isActive || cls.isLive;
    final emoji = _emojiForSubject(cls.title);
    final timeLabel = _formatTime(cls.startTime);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLive
              ? const Color(0xFF58CC02).withValues(alpha: 0.4)
              : const Color(0xFFE5E5EA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLive)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF58CC02).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                                color: Color(0xFF58CC02),
                                shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text('LIVE NOW',
                            style: GoogleFonts.nunito(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF58CC02),
                                letterSpacing: 0.5)),
                      ]),
                    ),
                  Text(cls.title,
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1C1C1E))),
                  const SizedBox(height: 2),
                  Text(
                    'Starts $timeLabel • ${cls.teacherName}',
                    style: GoogleFonts.nunito(
                        fontSize: 11, color: const Color(0xFF8E8E93)),
                  ),
                ]),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: onHost,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: const Color(0xFF58CC02),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF58CC02).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Center(
                  child: Text(
                    isActive ? 'Hosting Now' : 'Host Now',
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: cls.isLive ? onCopyLink : onSchedule,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E5EA)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                    cls.isLive
                        ? Icons.link_rounded
                        : Icons.calendar_month_rounded,
                    color: const Color(0xFF1CB0F6),
                    size: 16),
                const SizedBox(width: 6),
                Text(cls.isLive ? 'Copy Link' : 'Schedule',
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1CB0F6))),
              ]),
            ),
          ),
        ]),
      ]),
    );
  }
}