// features/parent/data/services/homework_service.dart
// ─────────────────────────────────────────────────────────────
// Homework / assignment tracking visible to parents (read-only —
// parents monitor, students submit from their own app).
// MOCK MODE — see parent_api_service.dart header for swap notes.
// ─────────────────────────────────────────────────────────────

import '../models/child_model.dart';

class HomeworkService {
  Future<List<HomeworkItem>> getHomework(String childId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    return [
      HomeworkItem(
        id: 'hw_1',
        title: 'Build a line-following robot circuit',
        subject: 'Robotics',
        dueDate: now.add(const Duration(days: 1)),
        status: 'pending',
      ),
      HomeworkItem(
        id: 'hw_2',
        title: 'Python loops worksheet',
        subject: 'Coding',
        dueDate: now.add(const Duration(days: 3)),
        status: 'pending',
      ),
      HomeworkItem(
        id: 'hw_3',
        title: 'Sensor simulation quiz',
        subject: 'Robotics',
        dueDate: now.subtract(const Duration(days: 1)),
        status: 'submitted',
      ),
      HomeworkItem(
        id: 'hw_4',
        title: 'AI ethics short essay',
        subject: 'AI Fundamentals',
        dueDate: now.subtract(const Duration(days: 4)),
        status: 'missed',
      ),
    ];
  }

  Future<List<HomeworkItem>> getUpcomingDeadlines(String childId) async {
    final items = await getHomework(childId);
    return items.where((h) => h.status == 'pending').toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  Future<Map<String, int>> getHomeworkSummary(String childId) async {
    final items = await getHomework(childId);
    return {
      "pending": items.where((h) => h.status == 'pending').length,
      "submitted": items.where((h) => h.status == 'submitted').length,
      "missed": items.where((h) => h.status == 'missed').length,
    };
  }
}
