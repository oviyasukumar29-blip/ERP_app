import 'dart:convert';
import 'package:http/http.dart' as http;

class RoleDashboardService {
  Future<Map<String, dynamic>?> getDashboard(String path) async {
    try {
      final response = await http
          .get(Uri.parse("http://192.168.1.3:8000$path"))
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
