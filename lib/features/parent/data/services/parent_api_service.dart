import 'dart:convert';
import 'package:http/http.dart' as http;

class ParentApiService {
  static const String baseUrl = "http://192.168.1.3:8000";

  Future<Map<String, dynamic>?> getDashboard() async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/parent/dashboard"))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
