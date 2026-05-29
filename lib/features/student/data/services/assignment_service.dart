import 'dart:convert';
import 'package:http/http.dart' as http;

class AssignmentService {

  Future<bool> submitAssignment(int assignmentId) async {

    try {

      final response = await http.post(
        Uri.parse(
          "http://192.168.1.3:8000/student/submit-assignment/$assignmentId",
        ),
      );

      print(response.body);

      if (response.statusCode == 200) {
        return true;
      }

      return false;

    } catch (e) {

      print(e);
      return false;
    }
  }
}