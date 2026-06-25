// features/parent/data/services/parent_api_service.dart
// ─────────────────────────────────────────────────────────────
// Wired to real backend. All mock data removed.
// Endpoints hit:
//   GET /parent/children?parent_id=...
//   GET /parent/children/{childId}/summary?parent_id=...
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_model.dart';

class ParentApiService {
  static const _host = 'https://shout-crisping-icing.ngrok-free.dev';
  static const _headers = {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };
  static const _selectedChildKey = 'parent_selected_child_id';

  Future<String?> _getParentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // ── GET /parent/children ─────────────────────────────────
  Future<List<ChildModel>> getChildren() async {
    final parentId = await _getParentId();
    if (parentId == null || parentId.isEmpty) return [];

    final response = await http.get(
      Uri.parse('$_host/parent/children?parent_id=$parentId'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => ChildModel(
                id: json['id'] as String,
                name: json['name'] as String,
                course: json['course'] as String? ?? '',
                batch: json['batch'] as String? ?? '',
                branch: json['branch'] as String? ?? '',
                attendancePercent:
                    (json['attendancePercent'] as num?)?.toInt() ?? 0,
                feeStatus: json['feeStatus'] as String? ?? 'pending',
                progressPercent:
                    (json['progressPercent'] as num?)?.toInt() ?? 0,
                xp: (json['xp'] as num?)?.toInt() ?? 0,
              ))
          .toList();
    } else {
      throw Exception('Failed to load children: ${response.statusCode}');
    }
  }

  // ── GET /parent/children/{childId}/summary ───────────────
  Future<Map<String, dynamic>> getDashboardSummary(String childId) async {
    final parentId = await _getParentId();
    if (parentId == null || parentId.isEmpty) return {};

    final response = await http.get(
      Uri.parse(
          '$_host/parent/children/$childId/summary?parent_id=$parentId'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Failed to load dashboard summary: ${response.statusCode}');
    }
  }

  // ── Persist selected child ───────────────────────────────
  Future<void> setSelectedChildId(String childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedChildKey, childId);
  }

  Future<String?> getSelectedChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedChildKey);
  }
}