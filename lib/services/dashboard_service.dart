import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {

  Future<Map<String, dynamic>?> getDashboard() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.3:8000/student/dashboard"),
      ).timeout(const Duration(seconds: 10));

      print("✅ Status: ${response.statusCode}");
      print("✅ Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ Bad status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}