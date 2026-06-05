import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseService {
  Future<List<Map<String, dynamic>>> getCourses() async {
    try {
      final response = await http
          .get(Uri.parse("http://192.168.1.3:8000/student/courses"))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final courses = body["courses"] as List<dynamic>? ?? [];
        return courses.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
