import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseService {
  static const Map<String, String> _headers = {
    'ngrok-skip-browser-warning': 'true',
  };

  Future<List<Map<String, dynamic>>> getCourses() async {
    try {
      final response = await http
          .get(
            Uri.parse("https://shout-crisping-icing.ngrok-free.dev/student/courses"),
            headers: _headers, // ← added
          )
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