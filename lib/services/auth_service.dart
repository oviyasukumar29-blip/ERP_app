import '../data/role_catalog.dart';
import '../models/erp_models.dart';

class AuthService {
  Future<ErpRole> login({
    required String email,
    required String password,
    required String roleId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw const FormatException('Enter email and password.');
    }
    return roleById(roleId);
  }
}
