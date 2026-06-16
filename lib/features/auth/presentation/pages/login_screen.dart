import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/services/auth_service.dart';
import '../../../admin/presentation/pages/admin_screen.dart';
import '../../../parent/presentation/pages/parent_screen.dart';
import '../../../student/presentation/pages/student_screen.dart';
import '../../../trainer/presentation/pages/trainer_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Original backend login (untouched) ────────────────────────
  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter username and password');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _authService.login(username, password);

      if (!mounted) return;

      if (success) {
        final role = await _authService.getCurrentRole();
        if (!mounted) return;

        final Widget screen = switch (role) {
          'trainer' => const TrainerScreen(),
          'parent'  => const ParentScreen(),
          'admin'   => const AdminScreen(),
          _         => const StudentScreen(),
        };

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => screen),
          (route) => false,
        );
      } else {
        setState(() => _errorMessage = 'Invalid username or password');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Connection failed. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Bypass: seeds SharedPreferences with real DB values ───────
  Future<void> _goToStudent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id',      '7c0b0e4c-c6a1-4554-afc5-05d7ee902a01'); // fluttertest
    await prefs.setString('user_name',    'fluttertest');
    await prefs.setString('user_email',   '');
    await prefs.setString('user_role',    'student');
    await prefs.setString('student_name', 'fluttertest');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const StudentScreen()),
      (route) => false,
    );
  }

  Future<void> _goToTrainer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id',      '99e61ed1-b195-4eb9-b85a-a78e60206980'); // trainertest
    await prefs.setString('user_name',    'trainertest');
    await prefs.setString('user_email',   '');
    await prefs.setString('user_role',    'trainer');
    await prefs.setString('student_name', 'trainertest');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const TrainerScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),

              // ── Logo ─────────────────────────────────────────────
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF58CC02),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF58CC02).withValues(alpha: .30),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),

              Text(
                'PineSphere',
                style: GoogleFonts.fredoka(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'AI Powered Learning Platform',
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: const Color(0xFF8E8E93),
                ),
              ),

              const SizedBox(height: 52),

              // ── Role select heading ───────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Continue as',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1C1C1E),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Student card ──────────────────────────────────────
              _RoleCard(
                label: 'Student',
                subtitle: 'fluttertest • view assignments & progress',
                emoji: '🎓',
                accentColor: const Color(0xFF58CC02),
                onTap: _goToStudent,
              ),
              const SizedBox(height: 16),

              // ── Trainer card ──────────────────────────────────────
              _RoleCard(
                label: 'Trainer',
                subtitle: 'trainertest • manage courses & students',
                emoji: '🧑‍💻',
                accentColor: const Color(0xFF1CB0F6),
                onTap: _goToTrainer,
              ),

              const SizedBox(height: 40),

              // ── Dev mode badge ────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFFD700).withValues(alpha: .5),
                  ),
                ),
                child: Text(
                  '⚠️  Dev mode — login bypassed',
                  style: GoogleFonts.fredoka(
                    fontSize: 13,
                    color: const Color(0xFF856404),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Role card widget ──────────────────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.subtitle,
    required this.emoji,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final String emoji;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: accentColor.withValues(alpha: .40),
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: .10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji bubble
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.fredoka(
                      fontSize: 13,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios_rounded, size: 15, color: accentColor),
          ],
        ),
      ),
    );
  }
}

// ── Input field (kept for when login is restored) ─────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.fredoka(fontSize: 15, color: const Color(0xFF1C1C1E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.fredoka(fontSize: 14, color: const Color(0xFFC7C7CC)),
          prefixIcon: Icon(icon, color: const Color(0xFF8E8E93), size: 20),
          suffixIcon: suffix != null
              ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}