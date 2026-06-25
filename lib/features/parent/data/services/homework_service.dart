// features/parent/data/services/homework_service.dart
// ─────────────────────────────────────────────────────────────
// Wired to real backend (read-only — parents monitor only).
// Endpoint: GET /parent/children/{childId}/homework?parent_id=...
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_model.dart';

class HomeworkService {
  static const _host = 'https://shout-crisping-icing.ngrok-free.dev';
  static const _headers = {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  Future<String?> _getParentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // ── All homework items ───────────────────────────────────
  Future<List<HomeworkItem>> getHomework(String childId) async {
    final parentId = await _getParentId();
    if (parentId == null) return [];

    final response = await http.get(
      Uri.parse(
          '$_host/parent/children/$childId/homework?parent_id=$parentId'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final items = body['items'] as List<dynamic>;
      return items
          .map((i) => HomeworkItem(
                id: i['id'] as String,
                title: i['title'] as String,
                subject: i['subject'] as String,
                dueDate: i['dueDate'] != null
                    ? DateTime.parse(i['dueDate'] as String)
                    : DateTime.now(),
                status: i['status'] as String,
              ))
          .toList();
    } else {
      throw Exception('Failed to load homework: ${response.statusCode}');
    }
  }

  // ── Upcoming deadlines (pending only, sorted by due date) 
  Future<List<HomeworkItem>> getUpcomingDeadlines(String childId) async {
    final items = await getHomework(childId);
    return items.where((h) => h.status == 'pending').toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // ── Summary counts for dashboard chip row ───────────────
  Future<Map<String, int>> getHomeworkSummary(String childId) async {
    final parentId = await _getParentId();
    if (parentId == null) return {"pending": 0, "submitted": 0, "missed": 0};

    final response = await http.get(
      Uri.parse(
          '$_host/parent/children/$childId/homework?parent_id=$parentId'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final summary = body['summary'] as Map<String, dynamic>;
      return {
        "pending":   (summary['pending']   as num?)?.toInt() ?? 0,
        "submitted": (summary['submitted'] as num?)?.toInt() ?? 0,
        "missed":    (summary['missed']    as num?)?.toInt() ?? 0,
      };
    } else {
      throw Exception('Failed to load homework summary: ${response.statusCode}');
    }
  }
}