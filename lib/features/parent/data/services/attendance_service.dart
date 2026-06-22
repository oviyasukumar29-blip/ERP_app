// features/parent/data/services/attendance_service.dart
// ─────────────────────────────────────────────────────────────
// Attendance history + weekly/monthly summary for a given child.
// MOCK MODE — see parent_api_service.dart header for swap notes.
// ─────────────────────────────────────────────────────────────

import '../models/child_model.dart';

class AttendanceService {
  /// Full calendar-month attendance for the given child.
  Future<List<AttendanceRecord>> getMonthlyAttendance(
    String childId, {
    DateTime? month,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final base = month ?? DateTime.now();
    final daysInMonth = DateTime(base.year, base.month + 1, 0).day;
    final records = <AttendanceRecord>[];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(base.year, base.month, day);
      if (date.isAfter(DateTime.now())) break;
      if (date.weekday == DateTime.sunday) continue;

      String status = 'present';
      if (day % 11 == 0) {
        status = 'absent';
      } else if (day % 7 == 0) {
        status = 'leave';
      }
      records.add(AttendanceRecord(date: date, status: status));
    }
    return records;
  }

  /// Quick rollup used by the attendance overview card + chart.
  Future<Map<String, dynamic>> getAttendanceSummary(String childId) async {
    final records = await getMonthlyAttendance(childId);
    final present = records.where((r) => r.status == 'present').length;
    final absent = records.where((r) => r.status == 'absent').length;
    final leave = records.where((r) => r.status == 'leave').length;
    final total = records.length == 0 ? 1 : records.length;

    return {
      "present": present,
      "absent": absent,
      "leave": leave,
      "total": total,
      "percent": ((present / total) * 100).round(),
    };
  }

  /// Recent absences worth flagging to the parent (used by absence_alert_card).
  Future<List<AttendanceRecord>> getRecentAbsences(String childId) async {
    final records = await getMonthlyAttendance(childId);
    return records.where((r) => r.status != 'present').toList().reversed.take(3).toList();
  }
}