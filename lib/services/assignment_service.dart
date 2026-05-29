import 'package:http/http.dart' as http;

class AssignmentService {

  Future<bool> submitAssignment(
    String assignmentId,
    String studentId,
    String filePath,
  ) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        "http://192.168.1.3:8000/student/submit-assignment",
      ),
    );

    request.fields['assignment_id'] = assignmentId;
    request.fields['student_id'] = studentId;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
      ),
    );

    final response = await request.send();

    return response.statusCode == 200;
  }
}