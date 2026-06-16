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
        "https://shout-crisping-icing.ngrok-free.dev/student/submit-assignment",
      ),
    );

    request.fields['assignment_id'] = assignmentId;
    request.fields['student_id'] = studentId;

    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final response = await request.send();

    return response.statusCode == 200;
  }
}
