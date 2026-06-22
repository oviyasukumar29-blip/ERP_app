// features/parent/data/services/parent_api_service.dart
// ─────────────────────────────────────────────────────────────
// Real HTTP calls to the backend.
// getChildren() hits GET /parent/{parentId}/children and returns
// the actual linked student from the database.
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_model.dart';

class ParentApiService {
  static const _host = 'https://shout-crisping-icing.ngrok-free.dev'; // ← your ngrok URL
  static const _selectedChildKey = 'parent_selected_child_id';

  static const _headers = {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  // ── Fetch real linked children from backend ───────────────
  Future<List<ChildModel>> getChildren() async {
    final prefs = await SharedPreferences.getInstance();
    final parentId = prefs.getString('user_id');

    // If no parent ID saved (shouldn't happen), return empty list
    if (parentId == null || parentId.isEmpty) {
      return [];
    }

    try {
      final response = await http
          .get(
            Uri.parse('$_host/parent/$parentId/children'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ChildModel(
              id: json['id'] as String,
              name: json['name'] as String,
              course: json['course'] as String? ?? '',
              batch: json['batch'] as String? ?? '',
              branch: json['branch'] as String? ?? '',
              attendancePercent: (json['attendance_percent'] as num?)?.toInt() ?? 0,
              feeStatus: json['fee_status'] as String? ?? 'pending',
              progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
              xp: (json['xp'] as num?)?.toInt() ?? 0,
            )).toList();
      } else {
        throw Exception('Failed to load children: ${response.statusCode}');
      }
    } catch (e) {
      // Rethrow so the UI can show an error state
      rethrow;
    }
  }

  // ── Persist selected child across sessions ────────────────
  Future<void> setSelectedChildId(String childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedChildKey, childId);
  }

  Future<String?> getSelectedChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedChildKey);
  }

  // ── Dashboard summary (still mock — wire later) ───────────
  Future<Map<String, dynamic>> getDashboardSummary(String childId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      "child_id": childId,
      "course_progress": 0,
      "course_progress_text": "Not started",
      "continue_course": "",
      "attendance_percent": 0,
      "fee_status": "pending",
      "fee_due_amount": 0,
      "pending_homework_count": 0,
      "unread_messages": 0,
      "ai_summary": "Activity summary will appear here once data is available.",
      "skill_scores": <String, num>{},
    };
  }
}