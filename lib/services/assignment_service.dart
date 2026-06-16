import 'dart:convert';
import 'package:http/http.dart' as http;

class RoleDashboardService {
  Future<Map<String, dynamic>?> getDashboard(String path) async {
    try {
      final response = await http
          .get(Uri.parse("https://shout-crisping-icing.ngrok-free.dev$path"))
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
