// features/parent/data/services/notification_service.dart
// ─────────────────────────────────────────────────────────────
// Parent-facing alerts: fees, attendance, homework, progress.
// MOCK MODE — see parent_api_service.dart header for swap notes.
// ─────────────────────────────────────────────────────────────

import '../models/child_model.dart';

class NotificationService {
  Future<List<ParentNotification>> getNotifications(String childId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    return [
      ParentNotification(
        id: 'n1',
        emoji: '💰',
        title: 'Fee due soon',
        subtitle: 'Term 3 fee of ₹15,000 is due on the 28th',
        category: 'fees',
        time: now.subtract(const Duration(hours: 2)),
      ),
      ParentNotification(
        id: 'n2',
        emoji: '📊',
        title: 'Weekly AI report ready',
        subtitle: 'Aarav\'s performance summary for this week is available',
        category: 'progress',
        time: now.subtract(const Duration(hours: 6)),
      ),
      ParentNotification(
        id: 'n3',
        emoji: '📝',
        title: 'Homework reminder',
        subtitle: 'Python loops worksheet is due in 3 days',
        category: 'homework',
        time: now.subtract(const Duration(days: 1)),
        read: true,
      ),
      ParentNotification(
        id: 'n4',
        emoji: '✅',
        title: 'Attendance marked',
        subtitle: 'Aarav was present today in Robotics Lab',
        category: 'attendance',
        time: now.subtract(const Duration(days: 1, hours: 3)),
        read: true,
      ),
      ParentNotification(
        id: 'n5',
        emoji: '⚠️',
        title: 'Absence recorded',
        subtitle: 'Aarav was marked absent last Tuesday',
        category: 'attendance',
        time: now.subtract(const Duration(days: 4)),
        read: true,
      ),
    ];
  }

  Future<List<ParentNotification>> getByCategory(
    String childId,
    String category,
  ) async {
    final all = await getNotifications(childId);
    if (category == 'all') return all;
    return all.where((n) => n.category == category).toList();
  }

  Future<int> getUnreadCount(String childId) async {
    final all = await getNotifications(childId);
    return all.where((n) => !n.read).length;
  }

  Future<void> markAllRead(String childId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    // Wire to PATCH /parent/notifications/read-all later.
  }
}
