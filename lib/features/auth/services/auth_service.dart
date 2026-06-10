import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _host = 'http://192.168.1.3:8000';

  static const String _keyUserId    = 'user_id';
  static const String _keyUserName  = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole  = 'user_role';

  /// Login with email + password
  Future<bool> login(String email, String password) async {
    try {
      final body = jsonEncode({'username_or_email': email, 'password': password});

      for (final role in ['student', 'trainer', 'parent', 'admin']) {
        try {
          final resp = await http.post(
            Uri.parse('$_host/auth/$role/login'),
            headers: {'Content-Type': 'application/json'},
            body: body,
          ).timeout(const Duration(seconds: 6));

          if (resp.statusCode == 200) {
            final data = jsonDecode(resp.body) as Map<String, dynamic>;
            await _saveSession(data);
            print('✅ Login success: id=${data['id']} role=${data['role']}');
            return true;
          }
        } catch (e) {
          print('🔴 Login error for $role: $e');
        }
      }
      return false;
    } catch (e) {
      print('🔴 Login error: $e');
      return false;
    }
  }

  Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId,    data['id']?.toString() ?? '');
    await prefs.setString(_keyUserName,  data['name']?.toString() ?? '');
    await prefs.setString(_keyUserEmail, data['email']?.toString() ?? '');
    await prefs.setString(_keyUserRole,  data['role']?.toString() ?? '');
    await prefs.setString('student_name', data['name']?.toString() ?? '');
    await prefs.setString('user_id',      data['id']?.toString() ?? '');
  }

  Future<bool> signup(UserModel user) async {
    try {
      final body = jsonEncode({
        'full_name':        user.fullName ?? user.username,
        'username':         user.username,
        'email':            user.email ?? '',
        'password':         user.password,
        'confirm_password': user.password,
      });

      final resp = await http.post(
        Uri.parse('$_host/auth/${user.role}/signup'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 6));

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        await _saveSession(data);
        return true;
      }
      print('🔴 Signup failed: ${resp.statusCode} ${resp.body}');
      return false;
    } catch (e) {
      print('🔴 Signup error: $e');
      return false;
    }
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyUserId);
    return (id == null || id.isEmpty) ? null : id;
  }

  Future<String?> getCurrentRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  Future<bool> isLoggedIn() async {
    final id = await getUserId();
    return id != null && id.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserRole);
    await prefs.remove('student_name');
    await prefs.remove('user_id');
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyUserId);
    if (id == null || id.isEmpty) return null;
    return UserModel(
      username: prefs.getString(_keyUserName) ?? '',
      password: '',
      role:     prefs.getString(_keyUserRole) ?? 'student',
      fullName: prefs.getString(_keyUserName),
      email:    prefs.getString(_keyUserEmail),
    );
  }
}