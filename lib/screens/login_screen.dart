import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/role_catalog.dart';
import '../models/erp_models.dart';
import '../services/auth_service.dart';
import 'roles/branch_admin_screen.dart';
import 'roles/counsellor_screen.dart';
import 'roles/finance_team_screen.dart';
import 'roles/franchise_owner_screen.dart';
import 'roles/hr_screen.dart';
import 'roles/parent_screen.dart';
import 'roles/placement_partner_screen.dart';
import 'roles/student_screen.dart';
import 'roles/super_admin_screen.dart';
import 'roles/trainer_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@pinesphere.in');
  final _passwordController = TextEditingController(text: 'postgres');
  final _authService = AuthService();
  String _roleId = roleCatalog.first.id;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
              shrinkWrap: true,
              children: [
                const _MascotBadge(),
                const SizedBox(height: 22),
                Text(
                  'Learn. Manage. Grow.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pinesphere ERP for AI training, robotics labs, LMS, CRM, finance, and branch operations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _roleId,
                  decoration: const InputDecoration(
                    labelText: 'Login as',
                    prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                  ),
                  items: [
                    for (final role in roleCatalog)
                      DropdownMenuItem(value: role.id, child: Text(role.name)),
                  ],
                  onChanged: (value) =>
                      setState(() => _roleId = value ?? _roleId),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.6),
                        )
                      : const Text('Log in'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final role = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
        roleId: _roleId,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => _screenFor(role)),
      );
    } on FormatException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _screenFor(ErpRole role) {
    switch (role.id) {
      case 'branch_admin':
        return BranchAdminScreen();
      case 'counsellor':
        return CounsellorScreen();
      case 'trainer':
        return TrainerScreen();
      case 'student':
        return StudentScreen();
      case 'parent':
        return ParentScreen();
      case 'hr':
        return HrScreen();
      case 'finance_team':
        return FinanceTeamScreen();
      case 'franchise_owner':
        return FranchiseOwnerScreen();
      case 'placement_partner':
        return PlacementPartnerScreen();
      case 'super_admin':
      default:
        return SuperAdminScreen();
    }
  }
}

class _MascotBadge extends StatelessWidget {
  const _MascotBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 104,
        height: 104,
        decoration: BoxDecoration(
          color: AppTheme.green,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3358CC02),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.school_rounded, color: Colors.white, size: 50),
            Positioned(
              right: 17,
              top: 18,
              child: Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  color: AppTheme.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
