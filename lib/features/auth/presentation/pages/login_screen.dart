// features/auth/presentation/pages/login_screen.dart

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../admin/presentation/pages/admin_screen.dart';
import '../../../parent/presentation/pages/parent_screen.dart';
import '../../../student/presentation/pages/student_screen.dart';
import '../../../trainer/presentation/pages/trainer_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _role = "Student";

  static const _roles = ["Student", "Trainer", "Parent", "Admin"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              CircleAvatar(
                radius: 45,
                backgroundColor: AppColors.primaryLight,
                child: const Icon(
                  Icons.school,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "ScholarHub",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "AI Powered Learning Platform",
                style: TextStyle(color: Colors.grey),
              ),
              const Spacer(),
              TextField(
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _role,
                    isExpanded: true,
                    items: _roles
                        .map(
                          (role) =>
                              DropdownMenuItem(value: role, child: Text(role)),
                        )
                        .toList(),
                    onChanged: (role) {
                      if (role != null) setState(() => _role = role);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(text: "Login", onTap: () => _openRole(context)),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _openRole(BuildContext context) {
    final Widget screen = switch (_role) {
      "Trainer" => const TrainerScreen(),
      "Parent" => const ParentScreen(),
      "Admin" => const AdminScreen(),
      _ => const StudentScreen(),
    };

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
