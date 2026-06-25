// features/parent/data/services/progress_service.dart
// ─────────────────────────────────────────────────────────────
// Wired to real backend.
// Endpoint: GET /parent/{parentId}/children/{childId}/progress
//
// getMarks()           → built from course progress (real)
// getOverallProgress() → average of all course completions (real)
// getSkillGraph()      → from quiz results by course category (real)
// getAiWeeklySummary() → generated from real progress data (real)
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

  // ── Core fetch: per-course progress array ────────────────
  Future<List<CourseProgress>> getCourseProgress(String childId) async {
    final parentId = await _getParentId();
    if (parentId == null) return [];

    final response = await http.get(
      Uri.parse('$_host/parent/$parentId/children/$childId/progress'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => CourseProgress(
                courseId: json['course_id'] as String,
                courseTitle: json['course_title'] as String,
                progress: (json['progress'] as num).toInt(),
                status: json['status'] as String,
                totalAssignments:
                    (json['total_assignments'] as num).toInt(),
                submittedAssignments:
                    (json['submitted_assignments'] as num).toInt(),
                totalQuizzes: (json['total_quizzes'] as num).toInt(),
                submittedQuizzes:
                    (json['submitted_quizzes'] as num).toInt(),
              ))
          .toList();
    } else {
      throw Exception('Failed to load progress: ${response.statusCode}');
    }
  }

  // ── Marks list — one ProgressMark per enrolled course ────
  // Used by progress_page.dart MarksChart + SubjectsTab
  Future<List<ProgressMark>> getMarks(String childId) async {
    final courses = await getCourseProgress(childId);
    return courses
        .map((c) => ProgressMark(
              subject: c.courseTitle,
              score: c.progress,
              maxScore: 100,
              date: DateTime.now(),
            ))
        .toList();
  }

  // ── Overall progress = average completion across courses ─
  Future<num> getOverallProgress(String childId) async {
    final courses = await getCourseProgress(childId);
    if (courses.isEmpty) return 0;
    final avg =
        courses.fold<num>(0, (sum, c) => sum + c.progress) / courses.length;
    return avg.round();
  }

  // ── Skill graph — derived from assignment/quiz completion
  // Each course contributes two skill dimensions:
  //   • "<course> Theory"  = quiz submission rate
  //   • "<course> Practice" = assignment submission rate
  Future<Map<String, num>> getSkillGraph(String childId) async {
    final courses = await getCourseProgress(childId);
    if (courses.isEmpty) return {};

    final Map<String, num> skills = {};
    for (final c in courses) {
      final quizScore = c.totalQuizzes > 0
          ? (c.submittedQuizzes / c.totalQuizzes * 100).round()
          : 0;
      final assignScore = c.totalAssignments > 0
          ? (c.submittedAssignments / c.totalAssignments * 100).round()
          : 0;

      // Use short course name to keep the chart readable
      final name = c.courseTitle.length > 14
          ? c.courseTitle.substring(0, 14)
          : c.courseTitle;
      skills['$name (Quiz)']       = quizScore;
      skills['$name (Assignment)'] = assignScore;
    }
    return skills;
  }

  // ── AI weekly summary — generated from real data ─────────
  Future<String> getAiWeeklySummary(String childId) async {
    final courses = await getCourseProgress(childId);
    if (courses.isEmpty) {
      return "No course data available yet. Summary will appear once your child is enrolled.";
    }

    final overall = courses.isEmpty
        ? 0
        : (courses.fold<num>(0, (s, c) => s + c.progress) / courses.length)
            .round();

    final best = courses.reduce((a, b) => a.progress > b.progress ? a : b);
    final pending = courses.fold<int>(
        0, (s, c) => s + (c.totalAssignments - c.submittedAssignments));

    return "Overall course completion is $overall%. "
        "Strongest progress is in ${best.courseTitle} at ${best.progress}%. "
        "${pending > 0 ? '$pending assignment${pending > 1 ? 's' : ''} still pending across all courses.' : 'All assignments are submitted — great work!'}";
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