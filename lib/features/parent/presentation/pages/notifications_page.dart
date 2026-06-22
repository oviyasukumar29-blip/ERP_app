// features/parent/presentation/pages/notifications_page.dart
import 'package:flutter/material.dart';
import '../parent_theme.dart';
import '../widgets/notifications/notification_tile.dart';
import '../widgets/notifications/notification_filter.dart';
import '../widgets/notifications/alert_card.dart';
import '../widgets/shared/loading_widget.dart';
import '../widgets/shared/empty_state_widget.dart';
import '../widgets/shared/parent_sub_app_bar.dart';
import '../../data/services/notification_service.dart';
import '../../data/models/child_model.dart';

class NotificationsPage extends StatefulWidget {
  final String selectedChildId;
  final String selectedChildName;

  const NotificationsPage({
    super.key,
    required this.selectedChildId,
    required this.selectedChildName,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _service = NotificationService();
  List<ParentNotification> _notifications = [];
  bool _loading = true;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _service.getNotifications(widget.selectedChildId);
    if (mounted) {
      setState(() {
        _notifications = data;
        _loading = false;
      });
    }
  }

  List<ParentNotification> get _filtered {
    if (_filter == 'All') return _notifications;
    return _notifications
        .where((n) => n.category.toLowerCase() == _filter.toLowerCase())
        .toList();
  }

  int get _unreadCount => _notifications.where((n) => !n.read).length;

  // The model has no explicit "urgent" flag — fee-related notices are
  // treated as the alert-worthy category since they're the one type
  // that needs immediate parent action.
  List<ParentNotification> get _alerts => _notifications
      .where((n) => n.category.toLowerCase() == 'fees' && !n.read)
      .take(2)
      .toList();

  void _markAllRead() {
    setState(() {
      _notifications = _notifications
          .map((n) => ParentNotification(
                id: n.id,
                emoji: n.emoji,
                title: n.title,
                subtitle: n.subtitle,
                category: n.category,
                time: n.time,
                read: true,
              ))
          .toList();
    });
    _service.markAllRead(widget.selectedChildId);
  }

  void _dismiss(ParentNotification notification) {
    setState(() => _notifications.removeWhere((n) => n.id == notification.id));
  }

  void _markRead(ParentNotification notification) {
    setState(() {
      _notifications = _notifications
          .map((n) => n.id == notification.id
              ? ParentNotification(
                  id: n.id,
                  emoji: n.emoji,
                  title: n.title,
                  subtitle: n.subtitle,
                  category: n.category,
                  time: n.time,
                  read: true,
                )
              : n)
          .toList();
    });
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
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
              title: 'Notifications',
              subtitle: _unreadCount > 0
                  ? '$_unreadCount unread'
                  : 'All caught up',
              showBackButton: true,
              trailing: _unreadCount > 0
                  ? GestureDetector(
                      onTap: _markAllRead,
                      child: Text(
                        'Mark all read',
                        style: PT.caption1(color: PT.blueDeep),
                      ),
                    )
                  : null,
            ),
            // Filter chips
            NotificationFilter(
              selected: _filter,
              onChanged: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const ParentLoadingWidget()
                  : RefreshIndicator(
                      color: PT.blueDeep,
                      onRefresh: _load,
                      child: _filtered.isEmpty
                          ? const EmptyStateWidget(
                              emoji: '🔔',
                              message: "No notifications. You're all caught up!",
                            )
                          : ListView(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 4, 16, 120),
                              children: [
                                // Urgent alerts at top
                                if (_filter == 'All' && _alerts.isNotEmpty)
                                  ..._alerts.map((a) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: AlertCard(
                                          emoji: a.emoji,
                                          title: a.title,
                                          subtitle: a.subtitle,
                                          color: PT.red,
                                          onAction: () => _markRead(a),
                                          onDismiss: () => _dismiss(a),
                                        ),
                                      )),
                                // Notification list
                                Container(
                                  decoration: PT.widgetCard,
                                  child: Column(
                                    children: List.generate(
                                      _filtered.length,
                                      (i) {
                                        final n = _filtered[i];
                                        return NotificationTile(
                                          emoji: n.emoji,
                                          title: n.title,
                                          body: n.subtitle,
                                          timeAgo: _formatTimeAgo(n.time),
                                          category: n.category,
                                          isRead: n.read,
                                          last: i == _filtered.length - 1,
                                          onTap: () => _markRead(n),
                                          onDismiss: () => _dismiss(n),
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