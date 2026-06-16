import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  Future<Map<String, dynamic>?> getDashboard() async {
    try {
      final response = await http.get(
        Uri.parse("https://shout-crisping-icing.ngrok-free.dev/student/dashboard"),
      ).timeout(const Duration(seconds: 10));

      print("✅ Status: ${response.statusCode}");
      print("✅ Body: ${response.body}");

      if (response.statusCode == 200) {
        var dashboardData = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Add student name from SharedPreferences if available
        final prefs = await SharedPreferences.getInstance();
        final studentName = prefs.getString('student_name');
        if (studentName != null) {
          dashboardData['student_name'] = studentName;
        }
        
        return dashboardData;
      } else {
        print("❌ Bad status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      
      // Return basic dashboard with student name even if API fails
      final prefs = await SharedPreferences.getInstance();
      final studentName = prefs.getString('student_name');
      if (studentName != null) {
        return {
          'student_name': studentName,
          'xp': 0,
          'streak_days': 0,
        };
      }
      return null;
    }
  }
}