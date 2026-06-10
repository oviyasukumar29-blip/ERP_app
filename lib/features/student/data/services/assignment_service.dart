import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudentAssignment {
  final String id;
  final String title;
  final String subject;
  final String dueDate;
  final String status;

  StudentAssignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.status,
  });

  factory StudentAssignment.fromJson(Map<String, dynamic> json) {
    return StudentAssignment(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      dueDate: json['due_date']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Open',
    );
  }
}

class AssignmentService {
  static const String _host = 'http://192.168.1.3:8000';

  Future<String?> _getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');
    print('🔴 student_id from prefs = "$id"');
    return id;
  }

  Future<List<StudentAssignment>> fetchMyAssignments() async {
    final studentId = await _getStudentId();

    if (studentId == null || studentId.isEmpty) {
      print('🔴 No student_id — returning empty list');
      return [];
    }

    try {
      print('🟡 Fetching: $_host/student/my-assignments/$studentId');
      final response = await http.get(
        Uri.parse('$_host/student/my-assignments/$studentId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 6));

      print('🟢 Status: ${response.statusCode}');
      print('🟢 Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => StudentAssignment.fromJson(e)).toList();
      }
    } catch (e) {
      print('🔴 Error fetching assignments: $e');
    }

    return [];
  }

  Future<bool> submitAssignment(String assignmentId) async {
    final studentId = await _getStudentId();
    if (studentId == null || studentId.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse(
            '$_host/student/submit-assignment/$assignmentId?student_id=$studentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'notes': ''}),
      ).timeout(const Duration(seconds: 6));

      print('🟢 Submit status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('🔴 Submit error: $e');
      return false;
    }
  }
}