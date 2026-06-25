// features/parent/data/services/attendance_service.dart
// ─────────────────────────────────────────────────────────────
// Wired to real backend.
// Endpoint: GET /parent/children/{childId}/attendance?parent_id=...&year=...&month=...
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_model.dart';

class AttendanceService {
  static const _host = 'https://shout-crisping-icing.ngrok-free.dev';
  static const _headers = {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  Future<String?> _getParentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // ── Full monthly attendance records ──────────────────────
  Future<List<AttendanceRecord>> getMonthlyAttendance(
    String childId, {
    DateTime? month,
  }) async {
    final parentId = await _getParentId();
    if (parentId == null) return [];

    final base = month ?? DateTime.now();
    final uri = Uri.parse(
      '$_host/parent/children/$childId/attendance'
      '?parent_id=$parentId&year=${base.year}&month=${base.month}',
    );

    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final records = body['records'] as List<dynamic>;
      return records
          .map((r) => AttendanceRecord(
                date: DateTime.parse(r['date'] as String),
                status: r['status'] as String,
              ))
          .toList();
    } else {
      throw Exception('Failed to load attendance: ${response.statusCode}');
    }
  }

  // ── Summary rollup (present/absent/leave/percent) ────────
  Future<Map<String, dynamic>> getAttendanceSummary(String childId) async {
    final parentId = await _getParentId();
    if (parentId == null) return {"present": 0, "absent": 0, "leave": 0, "total": 1, "percent": 0};

    final now = DateTime.now();
    final uri = Uri.parse(
      '$_host/parent/children/$childId/attendance'
      '?parent_id=$parentId&year=${now.year}&month=${now.month}',
    );

    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['summary'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load attendance summary: ${response.statusCode}');
    }
  }

  // ── Recent absences for alert card ───────────────────────
  Future<List<AttendanceRecord>> getRecentAbsences(String childId) async {
    final records = await getMonthlyAttendance(childId);
    return records
        .where((r) => r.status != 'present')
        .toList()
        .reversed
        .take(3)
        .toList();
  }
}