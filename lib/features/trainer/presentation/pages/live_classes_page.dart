import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinesphere_erp/core/theme/app_colors.dart';
import 'package:pinesphere_erp/features/student/presentation/widgets/dashboard/live_class_card.dart';

class TrainerLiveClassesPage extends StatefulWidget {
  const TrainerLiveClassesPage({super.key});

  @override
  State<TrainerLiveClassesPage> createState() => _TrainerLiveClassesPageState();
}

class _TrainerLiveClassesPageState extends State<TrainerLiveClassesPage> {
  String? _activeClassId;
  bool _isHosting = false;
  String _meetingLink = 'https://pinesphere.live/class/ABC123';

  final List<_TrainerLiveClass> _classes = [
    _TrainerLiveClass(
      id: 'math101',
      subject: '📐 Mathematics',
      teacher: 'You',
      time: '10:00 AM',
      isLive: true,
      studentsJoined: 24,
      scheduledAt: null,
      isReleased: true,
    ),
    _TrainerLiveClass(
      id: 'phy102',
      subject: '⚗️ Physics',
      teacher: 'You',
      time: '12:30 PM',
      isLive: false,
      studentsJoined: 0,
      scheduledAt: null,
      isReleased: false,
    ),
    _TrainerLiveClass(
      id: 'eng103',
      subject: '📖 English',
      teacher: 'You',
      time: '2:00 PM',
      isLive: false,
      studentsJoined: 0,
      scheduledAt: null,
      isReleased: false,
    ),
  ];

  void _startHosting(String classId) {
    setState(() {
      _activeClassId = classId;
      _isHosting = true;
      _meetingLink = 'https://pinesphere.live/class/$classId';
    });
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
      const SnackBar(content: Text('Meeting link copied')), 
    );
  }

  Future<void> _openScheduleDialog(_TrainerLiveClass cls) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (pickedTime == null) return;

    final scheduled = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
    setState(() {
      final idx = _classes.indexWhere((c) => c.id == cls.id);
      if (idx != -1) {
        _classes[idx] = _classes[idx].copyWith(scheduledAt: scheduled);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session scheduled')));
  }

  void _releaseClass(String classId) {
    setState(() {
      final idx = _classes.indexWhere((c) => c.id == classId);
      if (idx != -1) {
        final scheduled = _classes[idx].scheduledAt ?? DateTime.now();
        _classes[idx] = _classes[idx].copyWith(isReleased: true);
        // create meeting link for released session
        _meetingLink = 'https://pinesphere.live/class/$classId/${scheduled.millisecondsSinceEpoch}';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session released')));
  }

  @override
  Widget build(BuildContext context) {
    final activeClass = _classes.firstWhere(
      (item) => item.id == _activeClassId,
      orElse: () => _classes.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Live Classes',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _buildHostCard(activeClass),
          const SizedBox(height: 16),
          Text(
            'Your Classes',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ..._classes.map((liveClass) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  LiveClassCard(
                    subject: liveClass.subject,
                    teacher: 'Teacher: ${liveClass.teacher}',
                    time: liveClass.time,
                    isLive: liveClass.id == _activeClassId || liveClass.isLive,
                    studentsJoined: liveClass.studentsJoined,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _startHosting(liveClass.id),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                liveClass.id == _activeClassId && _isHosting
                                    ? 'Hosting Now'
                                    : 'Host Now',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _openScheduleDialog(liveClass),
                                child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.primary),
                                  ),
                                  child: Center(
                                    child: Text(
                                      liveClass.scheduledAt == null ? 'Schedule' : _formatScheduled(liveClass.scheduledAt!),
                                      style: GoogleFonts.nunito(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: liveClass.isReleased ? _copyMeetingLink : () => _releaseClass(liveClass.id),
                              child: Container(
                                height: 44,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: liveClass.isReleased ? AppColors.primary : const Color(0xFFF0F7FF),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Center(
                                  child: Text(
                                    liveClass.isReleased ? 'Copy Link' : 'Release',
                                    style: GoogleFonts.nunito(
                                      color: liveClass.isReleased ? Colors.white : AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHostCard(_TrainerLiveClass activeClass) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: .8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha((.08 * 255).round()),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Host Live Class',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _isHosting
                ? 'Your students can join the live session now using the link below.'
                : 'Select a class below to begin hosting and let students attend instantly.',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha((.18 * 255).round()),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.link_rounded, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _meetingLink,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _copyMeetingLink,
                  child: Text(
                    'Copy',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (_isHosting)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${activeClass.subject} • ${activeClass.time}',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: _stopHosting,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEBEB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Stop',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE24B4A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TrainerLiveClass {
  final String id;
  final String subject;
  final String teacher;
  final String time;
  final bool isLive;
  final int studentsJoined;
  final DateTime? scheduledAt;
  final bool isReleased;

  const _TrainerLiveClass({
    required this.id,
    required this.subject,
    required this.teacher,
    required this.time,
    required this.isLive,
    required this.studentsJoined,
    this.scheduledAt,
    this.isReleased = false,
  });

  _TrainerLiveClass copyWith({DateTime? scheduledAt, bool? isReleased}) {
    return _TrainerLiveClass(
      id: id,
      subject: subject,
      teacher: teacher,
      time: time,
      isLive: isLive,
      studentsJoined: studentsJoined,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isReleased: isReleased ?? this.isReleased,
    );
  }
}

String _formatScheduled(DateTime dt) {
  final date = '${dt.day}/${dt.month}/${dt.year}';
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final ampm = dt.hour >= 12 ? 'PM' : 'AM';
  return '$date • $hour:$minute $ampm';
}
