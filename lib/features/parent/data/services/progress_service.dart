// features/parent/data/services/progress_service.dart
// ─────────────────────────────────────────────────────────────
// Fetches real course progress for a child from the backend.
// Endpoint: GET /parent/{parentId}/children/{childId}/progress
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_model.dart';

class ProgressService {
  static const _host = 'https://shout-crisping-icing.ngrok-free.dev';
  static const _headers = {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  Future<String?> _getParentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // ── Fetch real enrolled courses with progress ─────────────
  Future<List<CourseProgress>> getCourseProgress(String childId) async {
    final parentId = await _getParentId();
    if (parentId == null) return [];

    final response = await http.get(
      Uri.parse('$_host/parent/$parentId/children/$childId/progress'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CourseProgress(
            courseId: json['course_id'] as String,
            courseTitle: json['course_title'] as String,
            progress: (json['progress'] as num).toInt(),
            status: json['status'] as String,
            totalAssignments: (json['total_assignments'] as num).toInt(),
            submittedAssignments: (json['submitted_assignments'] as num).toInt(),
            totalQuizzes: (json['total_quizzes'] as num).toInt(),
            submittedQuizzes: (json['submitted_quizzes'] as num).toInt(),
          )).toList();
    } else {
      throw Exception('Failed to load progress: ${response.statusCode}');
    }
  }

  // ── Overall progress = average across all courses ─────────
  Future<num> getOverallProgress(String childId) async {
    final courses = await getCourseProgress(childId);
    if (courses.isEmpty) return 0;
    final avg = courses.fold<num>(0, (sum, c) => sum + c.progress) / courses.length;
    return avg.round();
  }

  // ── Skill graph — still mock until skill table exists ─────
  Future<Map<String, num>> getSkillGraph(String childId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      "Coding": 82,
      "Robotics": 75,
      "Communication": 68,
      "Creativity": 80,
      "Leadership": 60,
    };
  }

  // ── AI weekly summary — still mock until AI endpoint exists
  Future<String> getAiWeeklySummary(String childId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return "Summary will appear here once AI reporting is enabled.";
  }

  // ── Marks — built from real course progress data ──────────
  Future<List<ProgressMark>> getMarks(String childId) async {
    final courses = await getCourseProgress(childId);
    return courses.map((c) => ProgressMark(
          subject: c.courseTitle,
          score: c.progress,
          maxScore: 100,
          date: DateTime.now(),
        )).toList();
  }
}

// ── Model ─────────────────────────────────────────────────────
class CourseProgress {
  final String courseId;
  final String courseTitle;
  final int progress;
  final String status;
  final int totalAssignments;
  final int submittedAssignments;
  final int totalQuizzes;
  final int submittedQuizzes;

  const CourseProgress({
    required this.courseId,
    required this.courseTitle,
    required this.progress,
    required this.status,
    required this.totalAssignments,
    required this.submittedAssignments,
    required this.totalQuizzes,
    required this.submittedQuizzes,
  });
}