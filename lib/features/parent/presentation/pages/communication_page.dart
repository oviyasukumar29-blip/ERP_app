// features/parent/presentation/pages/communication_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../parent_theme.dart';
import '../widgets/communication/trainer_tile.dart';
import '../widgets/communication/chat_bubble.dart';
import '../widgets/communication/complaint_form.dart';
import '../widgets/shared/loading_widget.dart';
import '../widgets/shared/empty_state_widget.dart';
import '../widgets/shared/parent_sub_app_bar.dart';
import '../../data/services/communication_service.dart';
import '../../data/models/child_model.dart';

class CommunicationPage extends StatefulWidget {
  final String selectedChildId;
  final String selectedChildName;

  const CommunicationPage({
    super.key,
    required this.selectedChildId,
    required this.selectedChildName,
  });

  @override
  State<CommunicationPage> createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  final _service = CommunicationService();
  List<TrainerContact> _teachers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _service.getTrainerContacts(widget.selectedChildId);
    if (mounted) {
      setState(() {
        _teachers = data;
        _loading = false;
      });
    }
  }

  void _openChat(TrainerContact teacher) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ChatPage(
          teacher: teacher,
          service: _service,
          childId: widget.selectedChildId,
        ),
      ),
    );
  }

  void _openComplaint() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ComplaintForm(),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PT.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ParentSubAppBar(
              title: 'Messages',
              subtitle: widget.selectedChildName,
              showBackButton: true,
              trailing: GestureDetector(
                onTap: _openComplaint,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: PT.tintRed,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: PT.red.withValues(alpha: .30)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.report_outlined, size: 13, color: PT.red),
                      const SizedBox(width: 4),
                      Text(
                        'Complaint',
                        style: GoogleFonts.fredoka(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: PT.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const ParentLoadingWidget()
                  : _teachers.isEmpty
                      ? const EmptyStateWidget(
                          emoji: '💬',
                          message: 'No teachers found yet.',
                        )
                      : RefreshIndicator(
                          color: PT.blueDeep,
                          onRefresh: _load,
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                            children: [
                              Container(
                                decoration: PT.widgetCard,
                                child: Column(
                                  children: List.generate(
                                    _teachers.length,
                                    (i) {
                                      final t = _teachers[i];
                                      return TrainerTile(
                                        name: t.name,
                                        subject: t.subject,
                                        lastMessage: t.lastMessage.isNotEmpty
                                            ? t.lastMessage
                                            : 'Tap to start conversation',
                                        timeAgo: _formatTimeAgo(t.lastMessageTime),
                                        unreadCount: t.unreadCount,
                                        last: i == _teachers.length - 1,
                                        onTap: () => _openChat(t),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Individual Chat Page ──────────────────────────────────────
class _ChatPage extends StatefulWidget {
  final TrainerContact teacher;
  final CommunicationService service;
  final String childId;

  const _ChatPage({
    required this.teacher,
    required this.service,
    required this.childId,
  });

  @override
  State<_ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<_ChatPage> {
  final _msgCtrl = TextEditingController();
  final _scroll = ScrollController();
  List<ChatMessage> _messages = [];
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await widget.service.getMessages(widget.teacher.id);
    if (mounted) {
      setState(() {
        _messages = data;
        _loading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final h = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final m = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();
    setState(() => _sending = true);
    _scrollToBottom();
    final sent = await widget.service.sendMessage(widget.teacher.id, text);
    if (mounted) {
      setState(() {
        _messages.add(sent);
        _sending = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final teacherName = widget.teacher.name;
    final subject = widget.teacher.subject;

    return Scaffold(
      backgroundColor: PT.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              color: PT.bgElevated,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 18, color: PT.labelSecondary),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: PT.tintPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('👩‍🏫', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(teacherName, style: PT.headline()),
                        Text(subject, style: PT.caption1(color: PT.labelTertiary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const ParentLoadingWidget()
                  : ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      itemCount: _messages.length,
                      itemBuilder: (_, i) {
                        final m = _messages[i];
                        return ChatBubble(
                          message: m.text,
                          time: _formatTime(m.time),
                          isMe: m.fromParent,
                          showAvatar: i == 0 || _messages[i - 1].fromParent,
                          senderName: m.fromParent ? null : teacherName,
                        );
                      },
                    ),
            ),
            Container(
              color: PT.bgElevated,
              padding: EdgeInsets.fromLTRB(
                  16, 10, 16, MediaQuery.of(context).viewInsets.bottom + 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: PT.bg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: PT.separator),
                      ),
                      child: TextField(
                        controller: _msgCtrl,
                        maxLines: null,
                        style: PT.subheadline(color: PT.labelPrimary),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: PT.subheadline(color: PT.labelQuaternary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sending ? null : _send,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: PT.blueDeep,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}